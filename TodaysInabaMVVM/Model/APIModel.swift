//
//  APIModel.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/08.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

final class APIModel {
    
    static let provider = MoyaProvider<API>()
    private static let disposeBag = DisposeBag()
    private static let store = Store.shard
    
    static func getInaba() {
        provider.rx.request(.CustomSearch(
                query: "稲葉浩志" + ["かっこいい", "かわいい", "眼鏡", "へそ", "97年"].randomElement()!,
                startIndex: Int.random(in: 1...10)))
            .map { response in
                try! JSONDecoder().decode(GoogleData.self, from: response.data)
            }.asObservable()
            .materialize().subscribe(onNext: { event in
                switch event {
                case .next(let value):
                    store._response.accept(value)
                case .error(let error):
                    store._error.accept(error)
                case .completed: break
                }
            }).disposed(by: disposeBag)
    }
        
}
