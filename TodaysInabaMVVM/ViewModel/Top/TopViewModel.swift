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
    
    init() {
        let disposeBag = DisposeBag()
        
        //output
        let _todaysInabaResponse = PublishRelay<GoogleData>()
        self.todaysInabaResponse = _todaysInabaResponse.asObservable()
        
        //input
        self.userName = AnyObserver<String>() { event in 
//            guard let text = event.element else {return}
            APIModel.getTodaysInabaImages()
                .bind(to: _todaysInabaResponse)
                .disposed(by: disposeBag)
        }
    }
}
