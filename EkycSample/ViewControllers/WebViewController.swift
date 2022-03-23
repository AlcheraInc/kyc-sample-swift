//
//  WebViewController.swift
//  EkycSample
//
//  Created by Alchera on 2022/03/21.
//

import UIKit
import WebKit
import AVFoundation

class WebViewController: UIViewController, WKUIDelegate {
    static let storyboardID = "webView"
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "eKYC"
        
        // Camera 권한 체크
        let permission = AVCaptureDevice.authorizationStatus(for: .video)
        switch permission {
        case .authorized:
            DispatchQueue.main.async { self.loadWebView() }
        case .denied:
            let alert = UIAlertController(title: "카메라 권한 필요",
                                          message: "설정 > 개인 정보 보호 > 카메라에서 권한을 변경하실 수 있습니다.",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
            return
        case .notDetermined:
            // 권한 요청
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async { self.loadWebView() }
                } else {
                    NSLog("권한이 거부되었습니다.")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        default:
            NSLog("Permission = \(permission.rawValue)")
        }
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    /* webView 불러오기 */
    func loadWebView() {
        guard let url = URL(string: "https://kyc-demo-stg.useb.co.kr") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
