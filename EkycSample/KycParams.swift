//
//  KycParams.swift
//  EkycSample
//
//  Created by Alchera on 2022/03/31.
//

import Foundation

class KycParams {
    // 고객사에서 사용자 필수정보를 관리 안함
    static let ocr                  = ["customer_id": "2", "id": "demoUser", "key": "demoUser0000!"]
    static let ocr_face             = ["customer_id": "3", "id": "demoUser", "key": "demoUser0000!"]
    static let ocr_face_liveness    = ["customer_id": "4", "id": "demoUser", "key": "demoUser0000!"]
    static let all                  = ["customer_id": "5", "id": "demoUser", "key": "demoUser0000!"]
    static let account              = ["customer_id": "6", "id": "demoUser", "key": "demoUser0000!"]
    static let ocr_account          = ["customer_id": "7", "id": "demoUser", "key": "demoUser0000!"]
    static let ocr_face_account     = ["customer_id": "8", "id": "demoUser", "key": "demoUser0000!"]
    // 고객사에서 사용자 필수정보를 관리 중
    static let db_ocr               = ["customer_id": "9", "id": "demoUser", "key": "demoUser0000!"]
    static let db_ocr_face          = ["customer_id": "10", "id": "demoUser", "key": "demoUser0000!"]
    static let db_ocr_face_liveness = ["customer_id": "11", "id": "demoUser", "key": "demoUser0000!"]
    static let db_all               = ["customer_id": "12", "id": "demoUser", "key": "demoUser0000!"]
    static let db_account           = ["customer_id": "13", "id": "demoUser", "key": "demoUser0000!"]
    static let db_ocr_account       = ["customer_id": "14", "id": "demoUser", "key": "demoUser0000!"]
    static let db_ocr_face_account  = ["customer_id": "15", "id": "demoUser", "key": "demoUser0000!"]
}
