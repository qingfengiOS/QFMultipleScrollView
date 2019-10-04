//
//  QFSecondViewController.swift
//  QFMultipleScrollView
//
//  Created by ios on 2019/8/31.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit

class QFSecondViewController: QFFirstViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "secondCell")
    }

    // MARK: - TableView Delegate/DataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "Second:\(indexPath.row)"
        return cell
    }
}
