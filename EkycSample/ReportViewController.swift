//
//  ReportViewController.swift
//  EkycSample
//
//  Created by Alchera on 2022/03/30.
//

import UIKit

class ReportViewController: UIViewController {
    static let storyboardID = "reportView"
    var response: KycResponse?
    private let NOTAVAILABLE = "N/A"
    
    @IBOutlet weak var idVerification: UIStackView!
    @IBOutlet weak var lblIdVerified: UILabel!
    @IBOutlet weak var imgIdMasking: UIImageView!
    @IBOutlet weak var imgIdOrigin: UIImageView!
    
    @IBOutlet weak var faceAuthentication: UIStackView!
    @IBOutlet weak var lblSimilarity: UILabel!
    @IBOutlet weak var imgIdCrop: UIImageView!
    @IBOutlet weak var imgSelfie: UIImageView!
    
    @IBOutlet weak var liveness: UIStackView!
    @IBOutlet weak var lblLive: UILabel!
    
    @IBOutlet weak var accountVerification: UIStackView!
    @IBOutlet weak var lblAccountVerification: UILabel!
    @IBOutlet weak var lblAccountUser: UILabel!
    @IBOutlet weak var lblAccountFinance: UILabel!
    @IBOutlet weak var lblFinanceCode: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        idVerification.isHidden = true
        faceAuthentication.isHidden = true
        liveness.isHidden = true
        accountVerification.isHidden = true
        
        guard let response = response,
              let detail = response.review_result else { return }
        
        if detail.module.id_card_ocr, detail.module.id_card_verification {
            idVerification.isHidden = false
            if let id_card = detail.id_card {
                lblIdVerified.text = id_card.verified ? "성공" : "실패"
                imgIdMasking.image = UIImage(data: id_card.id_card_image)
                imgIdOrigin.image = UIImage(data: id_card.id_card_origin)
            } else {
                lblIdVerified.text = NOTAVAILABLE
            }
        }
        
        if detail.module.face_authentication {
            faceAuthentication.isHidden = false
            if let face_check = detail.face_check {
                lblSimilarity.text = face_check.is_same_person ? "높음" : "낮음"
                imgIdCrop.image = UIImage(data: detail.id_card?.id_crop_image ?? Data())
                imgSelfie.image = UIImage(data: face_check.selfie_image)
            } else {
                lblSimilarity.text = NOTAVAILABLE
            }
        }
        
        if detail.module.liveness {
            liveness.isHidden = false
            if let face_check = detail.face_check {
                lblLive.text = face_check.is_live ? "성공" : "실패"
            } else {
                lblLive.text = NOTAVAILABLE
            }
        }
        
        if detail.module.account_verification {
            accountVerification.isHidden = false
            if let account = detail.account {
                lblAccountVerification.text = account.verified ? "성공" : "실패"
                lblAccountUser.text = account.user_name ?? NOTAVAILABLE
                lblAccountFinance.text = account.finance_company ?? NOTAVAILABLE
                lblFinanceCode.text = account.finance_code ?? NOTAVAILABLE
                lblAccountNumber.text = account.account_number ?? NOTAVAILABLE
            } else {
                lblAccountVerification.text = NOTAVAILABLE
            }
        }
    }
}
