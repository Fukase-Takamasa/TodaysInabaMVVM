//
//  ImageSearchStore.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2021/07/14.
//

import Foundation
import RxSwift
import RxCocoa

final class ImageSearchStore {
    
    static var shard = ImageSearchStore()
    
    var imageSearchResponse: Observable<ImageSearchResponse?> {
        _response.asObservable()
    }
    var imageSearchResponseValue: ImageSearchResponse? {
        _response.value
    }
    
    var error: Observable<Error> {
        _error.asObservable()
    }
        
    var _response = BehaviorRelay<ImageSearchResponse?>(value: nil)
    var _error = PublishRelay<Error>()
    
    private let disposeBag = DisposeBag()
    
}
