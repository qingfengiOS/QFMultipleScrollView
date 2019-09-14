//
//  QFFirstViewController.swift
//  QFMultipleScrollView
//
//  Created by ios on 2019/8/31.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit

class QFFirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        _initUI()
    }

    // MARK: - Initialize Appreaence
    private func _initUI() {
        _initTableView()
    }

    private func _initTableView() {
        let tableView = UITableView()
        self.tableView = tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "First:\(indexPath.row)"
        return cell
    }
}
