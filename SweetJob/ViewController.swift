//
//  ViewController.swift
//  SweetJob
//
//  Created by WOONCHUN HWANG on 2021/04/23.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //self.tableview.register(JobTableViewCell.self, forCellReuseIdentifier: "JobTableViewCell")
        self.bindView()
    }
    
    private func bindView() {
        
        let viewModel = JobViewModel()
        
        //textfield event
        self.textField.rx.controlEvent(.editingDidEndOnExit)
            //두번째부터 아이템 방출 한글자는 안돼
            .withLatestFrom(self.textField.rx.text.orEmpty)
            .subscribe(onNext: {
                viewModel.input.search.onNext($0)
            }).disposed(by: self.disposeBag)
        
        //tableview reuseable
        viewModel.output.searchResult
            .observe(on: MainScheduler.instance)
            .bind(to: self.tableview.rx.items(cellIdentifier: "JobTableViewCell",
                                              cellType: JobTableViewCell.self)) { (row, element, cell) in
                cell.backgroundColor = UIColor.clear
                cell.titleLabel.text = element.jobName
                cell.corpLabel.text = element.corpName
            }.disposed(by: self.disposeBag)

        //tableview select
        tableview.rx.itemSelected
          .subscribe(onNext: { indexPath in
            print(indexPath.row)
          }).disposed(by: self.disposeBag)

    }
}

