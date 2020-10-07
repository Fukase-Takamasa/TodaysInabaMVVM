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
    
    @IBOutlet weak var historyBotton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //input
        viewModel.userName.onNext("")
        
        //output
        viewModel.todaysInabaResponse
            .subscribe(onNext: { element in
                print("vc_response: \(element)")
            }).disposed(by: disposeBag)
    }


}

