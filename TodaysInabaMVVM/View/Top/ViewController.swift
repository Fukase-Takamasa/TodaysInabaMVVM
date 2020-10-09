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

class ViewController: UIViewController, StoryboardInstantiatable {
    
    let disposeBag = DisposeBag()
    let viewModel = TopViewModel()
    var datePicker = UIDatePicker()
    
    @IBOutlet weak var historyBotton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //input
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.userName)
            .disposed(by: disposeBag)
        
        //output
        viewModel.todaysInabaResponse
            .subscribe(onNext: { element in
                print("vc_response: \(element)")
                
                let resultImageUrl = element.items[Int.random(in: 0...9)].link
                
                let vc = ResultViewController.instantiate()
                vc.viewModel = ResultViewModel(resultImageUrl: resultImageUrl)
                self.present(vc, animated: true, completion: nil)
                
            }).disposed(by: disposeBag)
    }
    
    @objc func done() {
        view.endEditing(true)
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

extension ViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//
//        if !(nameTextField.text?.isEmpty ?? true) {
//            print("名前の入力が完了しました")
//            searchRequest()
//        }
//        return true
//    }
}
