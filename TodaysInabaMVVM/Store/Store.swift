//
//  Store.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2021/07/14.
//

import Foundation
import RxSwift
import RxCocoa

final class Store {
    
    static var shard = Store()
    
    var response: Observable<ImageSearchResponse?> {
        _response.asObservable()
    }
    var responseValue: ImageSearchResponse? {
        _response.value
    }
    
    var error: Observable<Error> {
        _error.asObservable()
    }
        
    var _response = BehaviorRelay<ImageSearchResponse?>(value: nil)
    var _error = PublishRelay<Error>()
    
    private let disposeBag = DisposeBag()
    
}
