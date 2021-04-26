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
        input.search
            .subscribe(onNext: {
                let ob = Observable.combineLatest(Network.sharedAPI.getJobKorea(searchText: $0),
                                                  Network.sharedAPI.getSaramin(searchText: $0), resultSelector: { ($0, $1) })
                ob.subscribe(onNext: { //[weak self] in
                    print(($0 ?? []) + ($1 ?? []))
                    self.output.searchResult.accept(($0 ?? []) + ($1 ?? []))
                }).disposed(by: self.disposeBag)
            }).disposed(by: self.disposeBag)
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
