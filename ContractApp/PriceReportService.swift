//
//  PriceReportService.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/6/3.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation



class PriceReportService : BasicService {
    
    func search(userId: String, keyword: String, startDate: NSDate, endDate: NSDate, index: Int, pageSize: Int, completion: ((response: SearchPriceReportResponse) -> Void)) -> SearchPriceReportResponse {
        let response = SearchPriceReportResponse()

        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let parameters = ["userid": userId, "keyword": keyword, "startdate": formatter.stringFromDate(startDate), "enddate": formatter.stringFromDate(endDate), "index": "\(index)", "pagesize": "\(pageSize)"]

        print(parameters)
        sendRequest(ServiceConfiguration.searchPriceReportUrl, parameters: parameters, serverResponse: response) { dict -> Void in
            if response.status == 0 {
                var reports = [PriceReport]()
                let jsonReports = dict["reports"] as! NSArray
                for jsonReport in jsonReports {
                    
                    let report = PriceReport(id: jsonReport["id"] as! String, reporter: jsonReport["reporter"] as! String, date: jsonReport["date"] as! String, status: jsonReport["status"] as! String, detailInfo: jsonReport["detailInfo"] as! String)
                    
                    reports.append(report)
                }
                response.priceReports = reports
                response.totalNumber = dict["totalNumber"] as! Int
            }
            completion(response: response)
        }
        return response
    }
    
    func getPriceReport(userId: String, reportId: String, index: Int, pageSize: Int, completion: ((response: GetPriceReportResonse) -> Void)) -> GetPriceReportResonse {
        let response = GetPriceReportResonse()
        
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let parameters = ["userid": userId, "reportId": reportId, "index": "\(index)", "pagesize": "\(pageSize)"]
        
        sendRequest(ServiceConfiguration.getPriceReportUrl, parameters: parameters, serverResponse: response) { dict -> Void in
            if response.status == 0 {
                var products = [Product]()
                let jsonReports = dict["products"] as! NSArray
                for jsonProduct in jsonReports {
                    
                    let product = Product(id: jsonProduct["id"] as! String, name: jsonProduct["name"] as! String, specification: jsonProduct["specification"] as! String, price: jsonProduct["price"] as! NSNumber, moneyType: jsonProduct["moneyType"] as! String, englishName: jsonProduct["englishName"] as! String)
                    
                    products.append(product)
                }
                response.products = products
                response.totalNumber = dict["totalNumber"] as! Int
            }
            completion(response: response)
        }
        return response
    }
    
    func searchProducts(userId: String, codes: [String], completion: ((response: SearchProductsResonse) -> Void)) -> SearchProductsResonse {
        let response = SearchProductsResonse()
        
        
        var codeString = ""
        for code in codes {
            codeString = codeString + "#@#" +  code
        }
        
        let parameters = ["userid": userId, "codes": codeString]
        
        sendRequest(ServiceConfiguration.searchProducstUrl, parameters: parameters, serverResponse: response) { dict -> Void in
            if response.status == 0 {
                var products = [Product]()
                let jsonReports = dict["products"] as! NSArray
                for jsonProduct in jsonReports {
                    
                    let product = Product(id: jsonProduct["id"] as! String, name: jsonProduct["name"] as! String, specification: jsonProduct["specification"] as! String, price: jsonProduct["price"] as! NSNumber, moneyType: jsonProduct["moneyType"] as! String, englishName: jsonProduct["englishName"] as! String)
                    
                    products.append(product)
                }
                response.products = products
            }
            completion(response: response)
        }
        return response
    }
    
    func submitReport(userId: String, codes: [String], completion: ((response: SubmitReportResonse) -> Void)) -> SubmitReportResonse {
        let response = SubmitReportResonse()
        
        var codeString = ""
        for code in codes {
            codeString = codeString + "#@#" +  code
        }
        
        let parameters = ["userid": userId, "codes": codeString]
        
        sendRequest(ServiceConfiguration.submitReportUrl, parameters: parameters, serverResponse: response) { dict -> Void in
            if response.status == 0 {
                let jsonReport = dict["report"] as! NSDictionary
                let report = PriceReport(id: jsonReport["id"] as! String, reporter: jsonReport["reporter"] as! String, date: jsonReport["date"] as! String, status: jsonReport["status"] as! String, detailInfo: jsonReport["detailInfo"] as! String)
                response.report = report
            }
            completion(response: response)
        }
        return response
    }

    


}
