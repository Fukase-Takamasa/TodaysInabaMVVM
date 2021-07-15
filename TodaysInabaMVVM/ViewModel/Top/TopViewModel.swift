//
//  TopViewModel.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/08.
//

import Foundation
import RxSwift
import RxCocoa

class TopViewModel {
    
    //input
    let userName: AnyObserver<String>
    
    //output
    let todaysInabaResponse: Observable<ImageSearchResponse?>
    let error: Observable<Error>
    let isFetching: Observable<Bool>
    
    //other
    private let disposeBag = DisposeBag()

    init() {
        let store = ImageSearchStore.shard
        
        let _todaysInabaResponse = PublishRelay<ImageSearchResponse?>()
        self.todaysInabaResponse = _todaysInabaResponse.asObservable()
        
        let _error = PublishRelay<Error>()
        self.error = _error.asObservable()
        
        let _isFetching = PublishRelay<Bool>()
        self.isFetching = _isFetching.asObservable()
        
        
        //output
        let _ = store.imageSearchResponse
            .subscribe(onNext: { element in
                _todaysInabaResponse.accept(element)
                _isFetching.accept(false)
            }).disposed(by: disposeBag)
        
        let _ = store.error
            .subscribe(onNext: { element in
                _error.accept(element)
                _isFetching.accept(false)
            }).disposed(by: disposeBag)
        
        
        
        //input
        self.userName = AnyObserver<String>() { event in
            guard let text = event.element else {return}
            guard !text.isEmpty else {return}
            
            _isFetching.accept(true)
            
            ImageSearchRepository.getRandomInabaImages()
        }
    }
}
