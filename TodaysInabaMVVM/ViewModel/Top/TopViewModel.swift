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
    let todaysInabaResponse: Observable<GoogleData>
    let error: Observable<Error>
    let isFetching: Observable<Bool>
    
    init() {
        let disposeBag = DisposeBag()
        
        //output
        let _todaysInabaResponse = PublishRelay<GoogleData>()
        self.todaysInabaResponse = _todaysInabaResponse.asObservable()
        
        let _error = PublishRelay<Error>()
        self.error = _error.asObservable()
        
        let _isFetching = PublishRelay<Bool>()
        self.isFetching = _isFetching.asObservable()
        
        //input
        self.userName = AnyObserver<String>() { event in
            guard let text = event.element else {return}
            guard !text.isEmpty else {return}
            
            _isFetching.accept(true)
            
            APIModel.getTodaysInabaImages()
                .subscribe({ event in
                    
                    switch event {
                    case let .next(response):
                        print("vm_next: \(response)")
                        _todaysInabaResponse.accept(response)
                        
                    case let .error(error):
                        print("vm_error: \(error)")
                        _error.accept(error)

                    case .completed:
                        print("vm_completed")
                        break
                    }
                    
                    _isFetching.accept(false)
                    
                }).disposed(by: disposeBag)
        }
    }
}
