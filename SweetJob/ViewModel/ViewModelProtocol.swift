//
//  ViewModelProtocol.swift
//  SweetJob
//
//  Created by WOONCHUN HWANG on 2021/04/23.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input {get}
    var output: Output {get}
}
