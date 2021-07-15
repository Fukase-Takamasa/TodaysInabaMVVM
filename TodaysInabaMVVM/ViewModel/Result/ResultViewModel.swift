//
//  ResultViewModel.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/09.
//

import Foundation
import RxSwift
import RxCocoa

class ResultViewModel {
    
    //input
    
    //output
    let todaysInabaResponse: Observable<ImageSearchResponse?>
    
    //other
    private let disposeBag = DisposeBag()

    init(resultImageUrl: String?) {
        let store = ImageSearchStore.shard
        
        let _todaysInabaResponse = PublishRelay<ImageSearchResponse?>()
        self.todaysInabaResponse = _todaysInabaResponse.asObservable()
        
        //output
        let _ = store.imageSearchResponse
            .bind(to: _todaysInabaResponse)
            .disposed(by: disposeBag)
        
        
        //input
    }
}
