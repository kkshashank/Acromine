//
//  DefinitionRequest.swift
//  Acromine
//
//  Created by Shashank Kumar on 4/24/17.
//  Copyright © 2017 Shashank. All rights reserved.
//

import Alamofire

class DefinitionRequest {
    
    public static let sharedDefinitionRequest: DefinitionRequest = DefinitionRequest()
    
    //MARK: - GetDefinitionsFromURL
    
    private let baseURL = "http://www.nactem.ac.uk/software/acromine/dictionary.py"
    private let baseURLDefinitionParameter = "?sf="
    
    typealias completionHandler = (_ data: [String]?, _ error: Error?) -> ()
    
    private var request: DataRequest!
    
    
    func getDefinitions(definitionForAcronym acronym: String, completion: @escaping completionHandler) {
        if request != nil {
            request.delegate.queue.cancelAllOperations()
        }
        request = Alamofire.request("\(baseURL)\(baseURLDefinitionParameter)\(acronym)").validate().responseJSON { [weak weakSelf = self] response in
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
    
    //MARK: - JSONToDefinitions
    
    private func getDataFromJSON(json: Any?) -> [String] {
        var definitions = [String]()
        guard let dataArray = json as? [Dictionary<String,Any>] else {
            return ["Problem obtaining data"]
        }
        for data in dataArray {
            if let definitionsArray = data["lfs"] as? [Dictionary<String,Any>] {
                for definition in definitionsArray {
                    definitions.append(definition["lf"] as! String)
                }
            }
        }
        return definitions.count == 0 ? [DefinitionsDataError.noResults.rawValue] : definitions
    }
    
}

