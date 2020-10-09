//
//  UserDefaultsModel.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/10.
//

import Foundation

final class UserDefaultsModel {
    
    //MARK: - Properties
    private static let ud = UserDefaults.standard
    
    //MARK: - Init
    init() {
        UserDefaultsModel.ud.setValue([String](), forKey: "imageUrlArr")
    }
    
    //MARK: - Methods
    static func saveUrl(value: String) {
        guard var imageUrlArr = ud.value(forKey: "imageUrlArr") as? [String] else {
            print("imageUrlArr取得失敗")
            return
        }
        imageUrlArr.insert(value, at: 0)
        ud.setValue(imageUrlArr, forKey: "imageUrlArr")
    }
    
    static func getUrlArr() -> [String] {
        if let imageUrlArr = ud.value(forKey: "imageUrlArr") as? [String] {
            return imageUrlArr
        }else {
            print("imageUrlArr取得失敗")
            return []
        }
    }
}
