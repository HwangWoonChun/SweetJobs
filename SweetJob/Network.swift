//
//  Network.swift
//  SweetJob
//
//  Created by WOONCHUN HWANG on 2021/04/23.
//

import UIKit
import Kanna
import RxSwift

struct CommonURL {
    //common
    static let saraminSearchURL: String = "https://www.saramin.co.kr/zf_user/search?search_area=main&search_done=y&search_optional_item=n&searchType=default_mysearch&searchword="
    static let jobkoreaSearchURL: String = "https://www.jobkorea.co.kr/Search/?stext="
}

class Network {
    //Base
    static let sharedAPI = Network()
    
    func getSaramin(searchText: String) -> [Job] {
        print(searchText)
        
        let mainURL = CommonURL.saraminSearchURL + searchText
        
        guard let main = URL(string: mainURL) else {
            print("Error: \(mainURL) doesn't seem to be a valid URL")
            return []
        }
        do {
            let lolMain = try String(contentsOf: main, encoding: .utf8)
            let doc = try HTML(html: lolMain, encoding: .utf8)
            var jobList: [Job] = []
            for (index, corp) in doc.xpath("//div[@class='area_corp']").enumerated() {
                let corpName = corp.at_xpath("strong")?.text
                let href = doc.xpath("//h2[@class='job_tit']/a")[index]["href"] ?? ""
                let title = doc.xpath("//h2[@class='job_tit']/a")[index]["title"] ?? ""
                let job = Job(jobName: title, corpName: corpName, url: href)
                jobList.append(job)
            }
            return jobList
        } catch let error {
            print(error)
            return []
        }
    }
    
    func getJobKorea(searchText: String) -> [Job] {
        print(searchText)
        
        let mainURL = CommonURL.jobkoreaSearchURL + searchText
        
        guard let main = URL(string: mainURL) else {
            print("Error: \(mainURL) doesn't seem to be a valid URL")
            return []
        }
        do {
            let lolMain = try String(contentsOf: main, encoding: .utf8)
            let doc = try HTML(html: lolMain, encoding: .utf8)
            
            var jobList: [Job] = []

            for (index, corp) in doc.xpath("//div[@class='post-list-corp']/a").enumerated() {
                let corpName = corp.text ?? ""
                let title = doc.xpath("//div[@class='post-list-info']/a")[index]["title"] ?? ""
                let href = doc.xpath("//div[@class='post-list-info']/a")[index]["href"] ?? ""

                if title.count != 0 && corpName.count != 0 && href.count != 0 {
                    let job = Job(jobName: title, corpName: corpName, url: href)
                    jobList.append(job)
                }
            }
            return jobList
        } catch let error {
            print(error)
            return []
        }
    }
}
