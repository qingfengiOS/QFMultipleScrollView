# QFMultipleScrollView
scrollView嵌套tableView联动滚动最佳实践

### 前言
随着业务的发展，页面的复杂度越来越高，嵌套滚动视图的方式也越来越受设计师们的青睐，在各大电商App十分常见。如下Demo图：
	
![](https://user-gold-cdn.xitu.io/2019/10/10/16db58d4e00ded51?w=213&h=419&f=gif&s=4079393)

但是这样的交互官方并不推荐,而且对开发来说确是不那么友好，需要处理滚动手势的冲突，页面的多层级嵌套都给开发带来了一定程度的麻烦。接下里我聊聊我们的实现思路。

### 思路和过程

对应这种页面结构应该毫无疑问是最底层是一个纵向滚动的scrollView，它的页面上面放一个固定高度的header,紧接着下面一个支持横向滚动切换的容器scrollView，容器上面才是各个页面具体的tableView，如下图：

![struct](https://user-gold-cdn.xitu.io/2019/10/10/16db58657fa5f51a?w=379&h=556&f=png&s=27823)

#### 思路一 
最先想到的是，既然是滚动视图那么我们是否可以通过滚动视图的可滚动属性来做呢，在初始时把最上层具体业务的tableView禁止滚动，那么根据事件响应链,滚动事件事件会由底层的ScrollView接收并处理，在到达最大偏移量之后，禁用底层的ScrollView滚动，同时开启上层的tableView，使得上层可以滑动，想起来是有一定可行性的，可惜，事实现实是残酷的，效果如下： 

![](https://user-gold-cdn.xitu.io/2019/10/14/16dca215e8b63e5d?w=212&h=420&f=gif&s=2132154)  

这样会导致当偏移量到达临界值时，由于设置了scrollEnable属性和最大偏移量，此次滚动手势会被截断，需要再次拖拽才能继续滚动，显然，这样的效果是无法接受的。

#### 思路二 
这是同事提供的思路，在做这个时和同事有过讨论，他们之前有这样的交互页面，使用的是自定义手势，但由于UIScrollView是有弹性效果的，一般的滑动手势做不到这一点的，所以需要引入UIDynamic模拟力场，实现阻尼效果。想了一下，虽然有一定的可行性，但是为了一个联动滑动，要做这么多的事情，感觉比较繁琐，而且自定义手势做的模拟弹性效果可能和原生ScrollView的效果还是有一定的差距，所以选择放弃。

#### 思路三 
回到我们思路一，除了边界位置会阻断联动滚动外，其他效果还是可以的，那么能不能通过手段解决这个问题呢？既然能写到了这里，那么毫无疑问，肯定是可以的。通过**手势穿透**,即让一个滑动手势既作用于底层的ScrollView又能作用于上层的业务tableView,同时控制他们的滚动即可达成目的。通过让底层的scrollView实现一个手势识别的协议，同时响应滚动事件：

```
func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
```
根据[官方文档](https://developer.apple.com/documentation/uikit/uigesturerecognizerdelegate/1624208-gesturerecognizer?language=objc)描述：

```
Asks the delegate if two gesture recognizers should be allowed to recognize gestures simultaneously.
```
表达的意思是询问委托是否允许两个手势识别器同时识别手势，那么我们实现这个协议，”穿透“手势，分别在底层容器和上层业务中实现滚动视图的代理方法```func scrollViewDidScroll(_ scrollView: UIScrollView)```，分别控制他们的可滚动状态和偏移量则能实现目的。部分实现如下：  

底层容器ScrollView： 

```
func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.isHidden = scrollView.contentOffset.y >= maxOffset ? true : false
        if !superCanScroll {
            scrollView.contentOffset.y = maxOffset
            currentVC.childCanScroll = true
        } else {
            if scrollView.contentOffset.y >= maxOffset {
                scrollView.contentOffset.y = maxOffset
                superCanScroll = false
                currentVC.childCanScroll = true
            }
        }
    }
```  
上层业务tableView： 

```
func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !childCanScroll {
            scrollView.contentOffset.y = 0
        } else {
            if scrollView.contentOffset.y <= 0 {
                childCanScroll = false
                superCanScrollBlock?(true)
            }
        }
    }
```
通过底层ScrollView是否达到最大偏移量控制header的显示隐藏和对应的偏移量及可滚动状态，在业务tableView使用回调将ScrollView的可滚动状态回调达到状态同步。总体来说还是比较清晰，更多细节请看[QFMultipleScrollView](https://github.com/qingfengiOS/QFMultipleScrollView)

