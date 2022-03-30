//
//  ViewController.swift
//  EkycSample
//
//  Created by Alchera on 2022/03/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnRun: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRun.layer.cornerRadius = 20
    }
    
    /* WebView 실행 */
    @IBAction func runButtonPressed(_ sender: UIButton) {
        if let webVC = storyboard?.instantiateViewController(identifier: WebViewController.storyboardID) {
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
}

