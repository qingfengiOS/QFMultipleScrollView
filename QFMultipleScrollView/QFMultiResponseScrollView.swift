//
//  QFMultiResponseScrollView.swift
//  QFMultipleScrollView
//
//  Created by ios on 2019/9/27.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit

class QFMultiResponseScrollView: UIScrollView {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
