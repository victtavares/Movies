//
//  UIViewController+Extension.swift
//  Movies
//
//  Created by Victor Tavares on 11/10/16.
//  Copyright © 2016 Victor. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    

    
    func displayAlertMessage(title: String? = nil, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: handler))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
