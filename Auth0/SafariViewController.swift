//
//  SafariViewController.swift
//  Auth0.iOS
//
//  Created by Andrew  Foghel on 5/13/20.
//  Copyright © 2020 Auth0. All rights reserved.
//

import UIKit
import SafariServices

class SafariViewController: SFSafariViewController {
    
    // MARK: -
    // MARK: Properties
    
    var callback: (() -> Void)?
    
    // MARK: -
    // MARK: Initialization
    
    deinit {
        callback?()
    }
    
    required init(url URL: URL, callback: (() -> Void)? = nil) {
        #if swift(>=3.2)
        if #available(iOS 11.0, *) {
            super.init(url: URL, configuration: SFSafariViewController.Configuration())
        } else {
            super.init(url: URL, entersReaderIfAvailable: false)
        }
        #else
        super.init(url: URL, entersReaderIfAvailable: false)
        #endif
        
        self.callback = callback
    }
    
}
