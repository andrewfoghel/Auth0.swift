// SilentSafariViewController.swift
//
// Copyright (c) 2017 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import SafariServices

class SilentSafariViewController: SFSafariViewController {
    
    required init(url URL: URL) {
        #if swift(>=3.2)
            if #available(iOS 11.0, *) {
                super.init(url: URL, configuration: SFSafariViewController.Configuration())
            } else {
                super.init(url: URL, entersReaderIfAvailable: false)
            }
        #else
            super.init(url: URL, entersReaderIfAvailable: false)
        #endif
        
        self.view.alpha = 0.05 // Apple does not allow invisible SafariViews, this is the threshold.
        self.modalPresentationStyle = .overCurrentContext
    }
}

class FullScreenSilentSafariViewController: UIViewController, SFSafariViewControllerDelegate {
    
    // MARK: Dependencies
    
    private var onResult: (Bool) -> Void = { _ in }
    private var safariVC: SilentSafariViewController

    // MARK: UI
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Init
    
    required init(url URL: URL, callback: @escaping (Bool) -> Void) {
        self.safariVC = SilentSafariViewController(url: URL)
        self.onResult = callback
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .clear
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        safariVC.delegate = self
        
        // Kind of a hack, in that we really aren't removing the navbar
        // Rather we are adjusting the starting point of the vpc object
        // so it appears as the navbar is hidden
        present(safariVC, animated: false) {
            var frame = self.safariVC.view.frame
            let OffsetY: CGFloat = 64
            
            frame.origin = CGPoint(x: frame.origin.x, y: frame.origin.y - OffsetY)
            frame.size = CGSize(width: frame.size.width, height: frame.size.height + OffsetY)
            self.safariVC.view.frame = frame
        }
    }
    
    // MARK: SFSafariViewControllerDelegate
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        controller.dismiss(animated: false) { [weak self] in
            self?.dismiss(animated: true) { [weak self] in
                self?.onResult(didLoadSuccessfully)
            }
        }
    }
}
