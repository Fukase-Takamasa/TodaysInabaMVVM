//
//  HistoryView.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/10.
//

import SwiftUI
import struct Kingfisher.KFImage

struct HistoryView: View {
    
    @State var imageUrlArr: [String] = []
    
    var body: some View {
        GeometryReader { bodyView in
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 0) {
                    ForEach(0..<self.imageUrlArr.count, id: \.self) { index in
                        KFImage(URL(string: self.imageUrlArr[index]))
                            .resizable()
                            .scaledToFit()
                            .frame(width: bodyView.size.width / 2, height: bodyView.size.width / 2)
                    }
                }
            }
            .onAppear {
                self.imageUrlArr = UserDefaultsModel.getUrlArr()
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
