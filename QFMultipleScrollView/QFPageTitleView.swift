//
//  QFPageTitleView.swift
//  QFMultipleScrollView
//
//  Created by ios on 2019/8/31.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit

class QFPageTitleView: UIView {

    let height: CGFloat = 40.0

    // MARK: - Properties
    var titles: [String] = [String]()

    // MARK: - Life Cycle
    init(_ titles: [String]) {
        self.titles = titles
        super.init(frame: .zero)
        initUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Initialize Appreaence
    private func initUI() {
        initTitleView()
    }

    private func initTitleView() {
        let titleWidth = Screen.width / CGFloat(titles.count)
        for (index, titleString) in titles.enumerated() {
            let titleView = QFTitleItemView()
            titleView.frame = CGRect(x: CGFloat(index) * titleWidth,
                                     y: 0,
                                     width: titleWidth,
                                     height: height)
            self.addSubview(titleView)
            titleView.titleString = titleString
            titleView.titleWidth = titleWidth
        }
    }
}


class QFTitleItemView: UIView {

    // MARK: - Properties
    weak var titleButton: UIButton!
    weak var indicateLabel: UILabel!

    var titleString: String = "" {
        didSet {
            setTitle(titleString)
        }
    }

    var titleWidth: CGFloat = 0.0 {
        didSet {
            setTitleWidth(titleWidth)
        }
    }


    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        _initUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Initialize Appreaence
    private func _initUI() {

        let titleBtn = UIButton()
        self.titleButton = titleBtn
        self.addSubview(titleBtn)
        titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleBtn.titleLabel?.textColor = UIColor.blue

        let indicateLine = UILabel()
        self.indicateLabel = indicateLine
        self.addSubview(indicateLine)
        indicateLine.backgroundColor = UIColor.blue
    }

    private func setTitle(_ titleString: String) {
        titleButton.setTitle(titleString, for: .normal)
    }

    private func setTitleWidth(_ width: CGFloat) {
        titleButton.frame = CGRect(x: 0, y: 0, width: width, height: 39)
        indicateLabel.frame = CGRect(x: 0, y: 39, width: width, height: 1)
    }

}
