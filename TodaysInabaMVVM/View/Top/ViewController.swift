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

class ViewController: UIViewController, StoryboardInstantiatable {
    
    //MARK: - DI
    struct Dependency {
        let viewModel: TopViewModel
    }
    func inject(_ dependency: Dependency) {
        viewModel = dependency.viewModel
    }
    
    let disposeBag = DisposeBag()
    var viewModel: TopViewModel!
    var datePicker = UIDatePicker()
    
    @IBOutlet weak var historyBotton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDatePicker()
        nameTextField.returnKeyType = .done
        
        //input
        let _ = nameTextField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(nameTextField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] element in
                guard let self = self else {return}
                self.viewModel.userName.onNext(element)
            }).disposed(by: disposeBag)
        
        //output
        //MARK: - レスポンス契機で遷移
        let _ = viewModel.todaysInabaResponse
            .subscribe(onNext: { [weak self] element in
                guard let self = self else {return}
                let viewModel = ResultViewModel()
                let dependency = ResultViewController.Dependency(viewModel: viewModel)
                let vc = ResultViewController.instantiate(with: dependency)
                self.present(vc, animated: true, completion: {
                    self.nameTextField.text = ""
                })
            }).disposed(by: disposeBag)
        
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
        
        //通信状態に応じてインジケータを表示
        let _ = viewModel.isFetching
            .subscribe(onNext: { element in
                element ? HUD.show(.progress) : HUD.hide()
            }).disposed(by: disposeBag)
        
        //other
        let _ = historyBotton.rx.tap
            .subscribe(onNext: { [weak self] element in
                guard let self = self else {return}
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
