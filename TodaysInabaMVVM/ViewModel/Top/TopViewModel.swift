//
//  TopViewModel.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/08.
//

import Foundation
import RxSwift
import RxCocoa

/*
 ※MJCみたいなinput/outputをハンドリングする〜ViewModelTypeというプロトコルを作ってないが、後でここら辺に追加する予定です
 
 */

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
        
        //PublishRelayにしてる理由（API叩く契機がText入力完了という明確なトリガーであり、初期値も不要だから）
        let _todaysInabaResponse = PublishRelay<ImageSearchResponse?>()
        self.todaysInabaResponse = _todaysInabaResponse.asObservable()
        
        let _error = PublishRelay<Error>()
        self.error = _error.asObservable()
        
        //インジケーターのON/OFF制御のフラグ、VC側がこれの値の変化を監視して、随時インジケータを出す
        let _isFetching = PublishRelay<Bool>()
        self.isFetching = _isFetching.asObservable()
        
        
        //MARK: - output
        //↓のinputのレポジトリ経由で叩いた画像一覧レスポンスをVCが検知できる様に繋げておく
        //この画面ではレスポンスを画面遷移のトリガーとして使用するだけで、レスポンスの中身は使わない。
        //（接続を繋げるだけなら.bindの方がコンパクトだが、それだとインジケータを止めたり他の処理ができないのでsubscribeする）
        //基本VM内のsubscribeでは[weak self]は不要
        let _ = store.imageSearchResponse
            .subscribe(onNext: { element in
                _todaysInabaResponse.accept(element)
                _isFetching.accept(false)
            }).disposed(by: disposeBag)
        
        //エラーが流れてきたらダイアログ出る様に接続を繋げておく＆インジケータを止める
        //（接続を繋げるだけなら.bindの方がコンパクトだが、それだとインジケータを止めたり他の処理ができないのでsubscribeする）
        let _ = store.error
            .subscribe(onNext: { element in
                _error.accept(element)
                _isFetching.accept(false)
            }).disposed(by: disposeBag)
        
        
        
        //MARK: - input
        //VCでのTextFieldの入力完了のトリガー（入力された文字も一緒に受け取っているが現状ほぼ使ってない）
        self.userName = AnyObserver<String>() { event in
            guard let text = event.element else {return}
            guard !text.isEmpty else {return}
            
            //インジケーター開始
            _isFetching.accept(true)
            
            //レポジトリ経由でAPI叩く
            ImageSearchRepository.getRandomInabaImages()
        }
    }
}
