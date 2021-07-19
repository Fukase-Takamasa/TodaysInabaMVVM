//
//  ViewController.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/09/27.
//

import UIKit
import RxSwift
import RxCocoa
import Instantiate
import InstantiateStandard
import PKHUD
import SwiftUI

//トップ画面（API叩く画面）
class ViewController: UIViewController, StoryboardInstantiatable {
    
    let disposeBag = DisposeBag()
    var viewModel = TopViewModel()
    var datePicker = UIDatePicker()
    
    @IBOutlet weak var historyBotton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDatePicker()
        nameTextField.returnKeyType = .done
        
        //input
        //text入力完了トリガーをイベント取得してsubscribe（基本VC内ではselfを使うことが多いので、[weak self]を忘れずにつけて、guard let でアンラップする）
        //ここでは、withLatestFromを使って、別の値（入力値）も一緒に合成してsubscribeしてる
        //このwithLatestFromの書き方だと、subscribeで流れてくる値の中身はwithLatestFromの値に上書きされる。もし元の値と別の値、両方使いたい場合は.withLatestFrom(hoge) { (hoge1, hoge2) in return (hoge1, hoge2)} みたいな書き方をする（MJC参照）
        let _ = nameTextField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(nameTextField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] element in
                guard let self = self else {return}
                //API叩くトリガー
                self.viewModel.userName.onNext(element)
            }).disposed(by: disposeBag)
        
        //output
        //MARK: - レスポンス契機で遷移（ここではレスポンスの中身は使わない）
        let _ = viewModel.todaysInabaResponse
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                
                //遷移先画面でViewModelの初期化を強制するDIが使われている（DipendencyInjectionを使っている）
                let viewModel = ResultViewModel()
                let dependency = ResultViewController.Dependency(viewModel: viewModel)
                let vc = ResultViewController.instantiate(with: dependency)
                self.present(vc, animated: true, completion: {
                    self.nameTextField.text = ""
                })
            }).disposed(by: disposeBag)
        
        //VMでエラーが流れてきたらアラートを出す
        let _ = viewModel.error
            .subscribe(onNext: { [weak self] element in
                guard let self = self else {return}
                print("vc_error: \(element)")
                
                let alert = UIAlertController(title: "通信に失敗しました。",
                                              message: element.localizedDescription,
                                              preferredStyle: .alert)
                let ok = UIAlertAction(title: "閉じる", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true)
                
            }).disposed(by: disposeBag)
        
        //インジケータの表示/非表示
        let _ = viewModel.isFetching
            .subscribe(onNext: { element in
                element ? HUD.show(.progress) : HUD.hide()
            }).disposed(by: disposeBag)
        
        //other
        let _ = historyBotton.rx.tap
            .subscribe(onNext: { [weak self] element in
                guard let self = self else {return}
                //ここだけSwiftUIの画面に遷移している
                self.present(UIHostingController(rootView: HistoryView()), animated: true)
            }).disposed(by: disposeBag)
    }
    
    func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .compact
        datePicker.frame = dateTextField.frame
        dateTextField.backgroundColor = .clear
        dateTextField.addSubview(datePicker)
        dateTextField.placeholder = ""
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = .current
        datePicker.tintColor = UIColor(red: 33/255, green: 173/255, blue: 182/255, alpha: 1)
        dateTextField.inputView = datePicker
        dateTextField.inputView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
