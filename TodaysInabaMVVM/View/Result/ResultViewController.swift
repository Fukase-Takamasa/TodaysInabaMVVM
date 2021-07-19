//
//  ResultViewController.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/09.
//

import UIKit
import Kingfisher
import SkeletonView
import Instantiate
import InstantiateStandard
import RxSwift
import RxCocoa

//結果画面
class ResultViewController: UIViewController, StoryboardInstantiatable {
    
    //MARK: - DI
    struct Dependency {
        let viewModel: ResultViewModel
    }
    func inject(_ dependency: Dependency) {
        viewModel = dependency.viewModel
    }

    let disposeBag = DisposeBag()
    var viewModel: ResultViewModel!
        
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toTopPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isSkeletonable = true
        imageView.showAnimatedGradientSkeleton()
        
        //output
        //実際にレスポンスの中身を使って表示処理
        let _ = viewModel.todaysInabaResponse
            .subscribe(onNext: { [weak self] element in
                guard let self = self else {return}
                self.showRandomImage(response: element)
            }).disposed(by: disposeBag)
        
        //other
        let _ = toTopPageButton.rx.tap
            .subscribe(onNext: { [weak self] element in
                guard let self = self else {return}
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        //APIを叩いたりしないのでerrorやisFetchingの監視は不要。
        
    }
    
    func showRandomImage(response: ImageSearchResponse?) {
        guard let resultImageUrl = response?.items[Int.random(in: 0...9)].link else {return}
        imageView.kf.setImage(with: URL(string: resultImageUrl), completionHandler:  { _ in
            self.imageView.hideSkeleton()
        })

        //UDに保存
        UserDefaultsModel.saveUrl(value: resultImageUrl)
    }
    
}
