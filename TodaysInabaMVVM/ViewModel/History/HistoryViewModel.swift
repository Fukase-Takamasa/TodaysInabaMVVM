//
//  HistoryViewModel.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/10.
//

import Foundation

///ここの画面（VC）だけSwiftUI使っちゃってるのでこの画面はお気になさらず
class HistoryViewModel: ObservableObject {
    
    //input
    
    //output
    @Published var imageUrlArr = [String]()
    
    init() {
        imageUrlArr = UserDefaultsModel.getUrlArr()
    }
    
}
