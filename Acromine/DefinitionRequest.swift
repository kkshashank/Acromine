//
//  DefinitionRequest.swift
//  Acromine
//
//  Created by Shashank Kumar on 4/24/17.
//  Copyright © 2017 Shashank. All rights reserved.
//

import Alamofire

class DefinitionRequest{
    
    public static let definitionRequestInstance: DefinitionRequest = DefinitionRequest()
    
    private let baseURL = "http://www.nactem.ac.uk/software/acromine/dictionary.py"
    private let baseURLExtension = "?sf="
    
    typealias completionHandler = (_ data: [String]?, _ error: Error?) -> ()
    
    private var request: DataRequest!
    
    func getDefinitions(definitionForAcronym acronym: String, completion: @escaping completionHandler){
        print(acronym)
        if request != nil{
            request.delegate.queue.cancelAllOperations()
        }
        request = Alamofire.request("\(baseURL)\(baseURLExtension)\(acronym)").validate().responseJSON { [weak weakSelf = self] response in
            switch response.result {
            case .success:
                //print("Validation Successful")
                let definitions = weakSelf?.getDataFromJSON(json: response.result.value)
                completion(definitions, nil)
            case .failure(let error):
                //print(error.localizedDescription)
                completion(nil, error)
            }
        }
    }
    
    private func getDataFromJSON(json: Any?) -> [String] {
        var definitions = [String]()
        guard let dataArray = json as? [Dictionary<String,Any>] else{
            return ["Error converting json to dictionary"]
        }
        for data in dataArray{
            if let definitionsArray = data["lfs"] as? [Dictionary<String,Any>]{
                for definition in definitionsArray{
                    definitions.append(definition["lf"] as! String)
                }
            }
        }
        return definitions.count == 0 ? ["No results found"]:definitions
    }
    
}

