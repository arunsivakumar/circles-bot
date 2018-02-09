//
//  NetworkHelper.swift
//  CirclesBot
//
//  Created by Lakshmi on 2/9/18.
//  Copyright © 2018 com.arunsivakumar. All rights reserved.
//

import Foundation


//
//  NetworkHelper.swift
//  FlickrIt
//
//  Created by Lakshmi on 8/3/17.
//  Copyright © 2017 com.arunsivakumar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON



typealias NetworkResponse = (NetworkResult) -> Void

enum NetworkResult{
    case success(JSON)
    case failure(Error)
}


struct NetworkHelper{
    
    /**
     Performs a GET request with parameters and returns a NetworkResponse
     
     - Parameters:
     - url: url of the request
     - params: parameters(optional)
     - completion: NetworkResponse
     - Returns:
     NetworkResponse
     */
    
    static func getRequest(url:String,params: [String:String]?, completion: @escaping NetworkResponse){
        
        Alamofire.request(url).validate(statusCode: 200..<300).responseJSON { (response) in
            
            switch response.result {
            case .success:
                //                print(response.result.value)
                if let value = response.result.value {
                    let json = JSON(value)
                    completion(.success(json))
                }else{
                    
                }
                
            case .failure(let error):
                //print(error)
                completion(.failure(error))
            }
        }
    }
    
    static func postRequest(url:String,params: [String:String]?, header:[String:String]?, completion: @escaping NetworkResponse){
     
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
//                print(response.request as Any)  // original URL request
//                print(response.response as Any) // URL response
//                print(response.result.value as Any)   // result of response serialization
                
                switch response.result {
                case .success:
                    //                print(response.result.value)
                    if let value = response.result.value {
                        let json = JSON(value)
                        completion(.success(json))
                    }else{
                        // handle network response error
                    }
                    
                case .failure(let error):
                    //print(error)
                    completion(.failure(error))
                }

        }
        
    }
    

}
