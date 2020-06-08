//
//  SecondViewController.swift
//  SoftUIExample
//
//  Created by Ivan Manov on 21.02.2020.
//  Copyright © 2020 hellc. All rights reserved.
//

import UIKit
import SoftUI

class SecondViewController: UIViewController {
    @IBOutlet weak var softCard: SoftCard!

    override func viewDidLoad() {
        super.viewDidLoad()

        var model = SoftCardItemModel()
        model.image = UIImage(named: "image_doc")
        model.title = "Title"
        model.description = "Description"
//        model.actionTitle = "Action"
//        model.actionHandler = { sender in
//            // TODO: Handle action
//        }

        let softCardItem = SoftCardItem(frame: self.softCard.bounds)
        softCardItem.configure(with: model)

        let softCardItem2 = SoftCardItem(frame: self.softCard.bounds)
        softCardItem2.configure(with: model)

        softCard.items = [softCardItem, softCardItem2]
    }
}
