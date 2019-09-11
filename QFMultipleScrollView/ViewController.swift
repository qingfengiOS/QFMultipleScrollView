//
//  ViewController.swift
//  QFMultipleScrollView
//
//  Created by ios on 2019/8/31.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit

struct Screen {
    //当前屏幕尺寸
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    static let navigationBarHeight = UIApplication.shared.statusBarFrame.height + 44
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let size = UIScreen.main.bounds.size
}

class ViewController: UIViewController {

    // MARK: - Properties
    weak var bottomScrollView: UIScrollView!
    weak var headerView: UIView!
    weak var pageTitleView: QFPageTitleView!

    weak var firstViewController: QFFirstViewController!
    weak var secondViewController: QFSecondViewController!

    let headerHeight: CGFloat = 150.0
    let titleHeight: CGFloat = 40

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

    private func initBootomScrollView() {
        let bottomScrollView = UIScrollView()
        bottomScrollView.frame = CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height)
        self.bottomScrollView = bottomScrollView
        view.addSubview(bottomScrollView)

        bottomScrollView.contentSize = CGSize(width: Screen.width, height: Screen.height + headerHeight)
    }

    private func initHeaderView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(Screen.width), height: Int(headerHeight)))
        headerView.backgroundColor = UIColor.red
        bottomScrollView.addSubview(headerView)
    }

    private func initPageTitleView() {
        let titles = ["First", "Second"]
        let pageTitleView = QFPageTitleView(titles)
        self.pageTitleView = pageTitleView
        bottomScrollView.addSubview(pageTitleView)
        pageTitleView.frame = CGRect(x: 0, y: Int(headerHeight), width: Int(Screen.width), height: Int(titleHeight))
        pageTitleView.backgroundColor = UIColor.gray
    }

    private func initSubControllers() {
        let containerScrollView = UIScrollView()
        bottomScrollView.addSubview(containerScrollView)
        let height = Screen.height - headerHeight - titleHeight
        containerScrollView.frame = CGRect(x: 0, y: headerHeight + titleHeight, width: Screen.width, height: height)
        containerScrollView.contentSize = CGSize(width: Screen.width, height: height)

        let first = QFFirstViewController()
        self.firstViewController = first
        self.addChild(first)
        first.view.bounds.size = containerScrollView.bounds.size
        first.view.bounds.origin = CGPoint(x: 0, y: 0)
        containerScrollView.addSubview(first.view)

        let second = QFSecondViewController()
        self.secondViewController = second
        self.addChild(second)
        second.view.bounds.size = containerScrollView.bounds.size
        second.view.bounds.origin = CGPoint(x: Screen.width, y: 0)
        containerScrollView.addSubview(second.view)
    }


}

