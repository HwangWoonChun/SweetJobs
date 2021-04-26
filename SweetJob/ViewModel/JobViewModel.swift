//
//  JobViewModel.swift
//  SweetJob
//
//  Created by WOONCHUN HWANG on 2021/04/23.
//

import UIKit
import RxSwift
import RxCocoa

class JobViewModel: ViewModelType {
    
    let input: Input = Input()
    let output: Output = Output()
    let disposeBag = DisposeBag()
    
    init() {
        input.search.map { Network.sharedAPI.getSaramin(searchText: $0) }
            .bind(to: output.searchResult)
            .disposed(by: disposeBag)
    }
}

extension JobViewModel {
    struct Input {
        let search = PublishSubject<String>()
    }
    
    struct Output {
        let searchResult = PublishRelay<[Job]>()
    }
}
