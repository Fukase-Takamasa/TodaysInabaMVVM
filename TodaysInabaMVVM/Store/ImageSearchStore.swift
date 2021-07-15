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
    
    //Observableとして受け取りたい時用
    var imageSearchResponse: Observable<ImageSearchResponse?> {
        _response.asObservable()
    }
    //Subscribeせずに値を使いたい時用（RxじゃないtableViewなどでVCから参照する時や、VM内でidなどを使いたい時用）
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
