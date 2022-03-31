//
//  WebViewController.swift
//  EkycSample
//
//  Created by Alchera on 2022/03/21.
//

import UIKit
import WebKit
import AVFoundation

class WebViewController: UIViewController, WKUIDelegate, WKScriptMessageHandler {
    static let storyboardID = "webView"
    
    var webView: WKWebView!
    var customerData: [String: Any]? = nil
    private let responseName = "alcherakyc"
    private var result: String?
    private var responseJson: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "eKYC"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkCameraPermission()
    }
    
    /* View 불러오기 */
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        // 고객 정보를 담은 postMessage 설정
        if let requestData = encodedPostMessage() {
            let userScript = WKUserScript(source: "postMessage('\(requestData)')", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            webConfiguration.userContentController.addUserScript(userScript)
            webConfiguration.preferences.javaScriptEnabled = true
        }
        // 메시지 수신할 핸들러 등록
        webConfiguration.userContentController.add(self, name: responseName)
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    /* WebView 불러오기 */
    func loadWebView() {
        guard let url = URL(string: "https://kyc.useb.co.kr/auth") else { return }
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
    /* KYC 결과 창으로 이동 */
    func loadReportView() {
        if let reportVC = storyboard?.instantiateViewController(identifier: ReportViewController.storyboardID) as? ReportViewController {
            reportVC.result = result
            reportVC.responseJson = responseJson
            navigationController?.pushViewController(reportVC, animated: true)
        }
    }
    
    /* WebView 메시지 핸들러 */
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == responseName, let body = message.body as? String else { return }
        guard let decodedMessage = decodedPostMessage(body) else {
            NSLog("KYC 응답 메시지 분석에 실패했습니다.")
            return
        }
        
        guard let kycResponse = parsingJson(decodedMessage) else {
            NSLog("KYC 응답 메시지 변환에 실패했습니다.")
            return
        }
        
        result = kycResponse.result
        switch kycResponse.result {
        case "success":
            NSLog("KYC 작업이 성공했습니다.")
            responseJson = decodedMessage
        case "failed":
            NSLog("KYC가 작업이 실패했습니다.")
            responseJson = decodedMessage
        case "complete":
            NSLog("KYC가 완료되었습니다.")
            responseJson = responseJson ?? decodedMessage
            loadReportView()
        case "close":
            NSLog("KYC가 완료되지 않았습니다.")
            responseJson = responseJson ?? decodedMessage
            loadReportView()
        default:
            result = nil
            responseJson = nil
            break
        }
    }
    
    /* Camera 권한 체크 */
    func checkCameraPermission() {
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
    
    /* PostMessage로 보낼 고객 정보를 생성합니다. */
    func encodedPostMessage() -> String? {
        var jsonData: [String: Any] = KycParams.all
        if let customerData = customerData {
            jsonData = KycParams.db_all
            for (key, value) in customerData { jsonData[key] = value }
        }
        
        do {
            // JSON -> encodeURIComponent -> Base64Encoding
            let jsonData = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8),
               let uriEncoded = jsonString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return uriEncoded.data(using: .utf8)?.base64EncodedString()
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        
        return nil
    }
    
    /* KYC 수행 결과를 분석합니다. */
    func decodedPostMessage(_ encodedMessage: String) -> String? {
        // Base64Decoding -> decodeURIComponent -> JSON
        if let base64DecodedData = Data(base64Encoded: encodedMessage),
           let base64DecodedString = String(data: base64DecodedData, encoding: .utf8) {
            let jsonString = base64DecodedString.removingPercentEncoding
            return jsonString
        }
        
        return nil
    }
}
