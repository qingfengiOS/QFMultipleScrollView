//
//  ViewController.swift
//  QFMultipleScrollView
//
//  Created by ios on 2019/8/31.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit
import SnapKit

struct Screen {
    //当前屏幕尺寸
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    static let navigationBarHeight = UIApplication.shared.statusBarFrame.height + 44
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let size = UIScreen.main.bounds.size
}

class ViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Properties
    weak var bottomScrollView: QFMultiResponseScrollView!
    weak var headerView: UIView!
    weak var pageTitleView: QFPageTitleView!
    weak var containerScrollView: UIScrollView!

    weak var firstViewController: QFFirstViewController!
    weak var secondViewController: QFSecondViewController!

    let headerHeight: CGFloat = 150.0
    let titleHeight: CGFloat = 40
    let maxOffset: CGFloat = 115 - Screen.statusBarHeight //最大偏移量

    var superCanScroll = true

    private weak var currentVC: QFFirstViewController!


    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initBootomScrollView()
        initHeaderView()
        initPageTitleView()
        initSubControllers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Initialize Appreaence
    private func initBootomScrollView() {
        let bottomScrollView = QFMultiResponseScrollView()
        self.bottomScrollView = bottomScrollView
        bottomScrollView.delegate = self
        view.addSubview(bottomScrollView)
        bottomScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        bottomScrollView.contentSize = CGSize(width: Screen.width, height: Screen.height + headerHeight)
    }

    private func initHeaderView() {
        let headerView = UIView()
        self.headerView = headerView
        headerView.backgroundColor = UIColor.orange
        bottomScrollView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.top.equalTo(-Screen.statusBarHeight)
            make.width.equalTo(Screen.width)
            make.height.equalTo(headerHeight)
        }
    }

    private func initPageTitleView() {
        let titles = ["First Page", "Second Page"]
        let pageTitleView = QFPageTitleView(titles)
        self.pageTitleView = pageTitleView
        bottomScrollView.addSubview(pageTitleView)
        pageTitleView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.width.equalTo(Screen.width)
            make.top.equalTo(headerHeight - Screen.statusBarHeight)
            make.height.equalTo(40)
        }
        pageTitleView.clickBlock = { [weak self] (index) in
            self?.containerScrollView.contentOffset = CGPoint(x: CGFloat(index) * Screen.width, y: 0.0)
            self?.currentVC = index == 0 ? self?.firstViewController : self?.secondViewController
        }
    }

    private func initSubControllers() {
        let containerScrollView = UIScrollView()
        self.containerScrollView = containerScrollView
        containerScrollView.isScrollEnabled = false
        bottomScrollView.addSubview(containerScrollView)
        let height = Screen.height - titleHeight - Screen.statusBarHeight
        containerScrollView.contentSize = CGSize(width: Screen.width * 2, height: height)
        containerScrollView.snp.makeConstraints { (make) in
            make.leading.bottom.equalTo(0)
            make.top.equalTo(pageTitleView.snp.bottom)
            make.width.equalTo(Screen.width)
            make.height.equalTo(height)

        }

        let first = QFFirstViewController()
        self.firstViewController = first
        self.addChild(first)
        containerScrollView.addSubview(first.view)
        first.view.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(0)
            make.height.equalTo(Screen.height - titleHeight - Screen.statusBarHeight)
            make.width.equalTo(Screen.width)
        }

        let second = QFSecondViewController()
        self.secondViewController = second
        self.addChild(second)
        containerScrollView.addSubview(second.view)
        second.view.snp.makeConstraints { (make) in
            make.leading.equalTo(Screen.width)
            make.top.bottom.equalTo(0)
            make.width.equalTo(Screen.width)
            make.height.equalTo(Screen.height - titleHeight - Screen.statusBarHeight)
        }
        currentVC = firstViewController

        first.superCanScrollBlock = { [weak self] (canScroll) in
            self?.superCanScroll = canScroll
        }
        second.superCanScrollBlock = { [weak self] (canScroll) in
            self?.superCanScroll = canScroll
        }
    }

    // MARK: - UIScrollViewDelegate
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
}
