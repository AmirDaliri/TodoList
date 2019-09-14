//
//  Helpers.swift
//  TestTodoList_Realm
//
//  Created by Amir Daliri on 14.09.2019.
//  Copyright © 2019 Amir Daliri. All rights reserved.
//

import Foundation
import UIKit

class Helpers: NSObject {
    
    static func showSortActionSheetAlert(_ viewController: UIViewController, atoZHandler: ((UIAlertAction) -> Swift.Void)?, dateHandler: ((UIAlertAction) -> Swift.Void)?) {
        let alert = UIAlertController(title: "sort list by:", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(Bool) in })
        let aToZAction = UIAlertAction(title: "A-Z", style: .default, handler: atoZHandler)
        let dateAction = UIAlertAction(title: "Date", style: .default, handler: dateHandler)
        alert.addAction(aToZAction)
        alert.addAction(dateAction)
        alert.addAction(cancel)
        viewController.present(alert, animated: true, completion:nil)
    }
    
}
