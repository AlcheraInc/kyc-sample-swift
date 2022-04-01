//
//  ViewController.swift
//  EkycSample
//
//  Created by Alchera on 2022/03/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirthYear: UITextField!
    @IBOutlet weak var txtBirthMonth: UITextField!
    @IBOutlet weak var txtBirthDay: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnRun: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRun.layer.cornerRadius = 20
        txtName.delegate = self
        txtBirthYear.delegate = self
        txtPhoneNumber.delegate = self
        txtEmail.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /* WebView 실행 */
    @IBAction func runButtonPressed(_ sender: UIButton) {
        guard let webVC = storyboard?.instantiateViewController(identifier: WebViewController.storyboardID) as? WebViewController else {
            return
        }
        
        if let name = txtName.text, !name.isEmpty,
           let year = txtBirthYear.text, !year.isEmpty,
           let month = txtBirthMonth.text, !month.isEmpty,
           let day = txtBirthDay.text, !day.isEmpty,
           let phoneNumber = txtPhoneNumber.text, !phoneNumber.isEmpty,
           let email = txtEmail.text, !email.isEmpty {
            let customerData: [String: Any] = ["name": name,
                                               "birthday": "\(year)-\(month)-\(day)",
                                               "phone_number": phoneNumber,
                                               "email": email]
            webVC.customerData = customerData
        }
        navigationController?.pushViewController(webVC, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    /* 키보드 생성 시 화면 이동 */
    @objc func keyboardWillShow(notification: NSNotification) {
        if view.frame.origin.y == 0 { view.frame.origin.y -= 150 }
    }
    
    /* 키보드 제거 시 화면 원복 */
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    /* 화면 클릭 시 키보드 내림 */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /* 키보드의 Return 버튼 클릭 시 */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
}

