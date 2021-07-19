//
//  ResultViewModel.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/09.
//

import Foundation
import RxSwift
import RxCocoa

/*
 ※MJCみたいなinput/outputをハンドリングする〜ViewModelTypeというプロトコルを作ってないが、後でここら辺に追加する予定です
 
 */

class ResultViewModel {
    
    //input
    
    //output
    let todaysInabaResponse: Observable<ImageSearchResponse?>
    
    //other
    private let disposeBag = DisposeBag()

    init() {
        let store = ImageSearchStore.shard
        
        //こちらはBehaviorRelayにしている。（初期値を持たせられて、subscribeされると初回に一回あたいを流すタイプ）
        //理由：APIはすでに前の画面で叩いてレスポンスも返ってきていて、リアルタイムのレスポンス受け取りじゃないため、PublishRelayにするとsubscribeしても初回は値を流さない。
        //遷移後のこの画面では、すでにStoreに保管されているレスポンスを後から取り出して表示するイメージ。
        //ちなみに初期値（value）はnilだが、storeのレスポンスをbindしていて値が入るので、ちゃんとレスポンスが初回に流れる
        let _todaysInabaResponse = BehaviorRelay<ImageSearchResponse?>(value: nil)
        self.todaysInabaResponse = _todaysInabaResponse.asObservable()
        
        //output
        //ここだとインジケータを止めたりなどの他の処理が不要なので、bindだけでOK
        let _ = store.imageSearchResponse
            .bind(to: _todaysInabaResponse)
            .disposed(by: disposeBag)
        
        /*----------
        bindとsubscribeの使い分けイメージ↓
        bind: bind先の変数に流す値の型は変えられない（変える必要がない時に使う）ボタンタップならVoid型だけ、textFieldならstringだけなど。
        subscribe: いろいろ処理をしたいときに使う。ボタンタップでもBoolフラグやIntのIDを流してもいいし、画面遷移処理書いたりいろいろできる
         ----------*/
        
        
        //input
    }
}
