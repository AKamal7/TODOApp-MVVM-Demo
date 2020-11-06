

import Foundation
import Alamofire

class APIManager {
    
    // Login to API
    class func login(with email: String, password: String, completion: @escaping (_ error: Error?, _ loginData: LoginResponse?) -> Void) {
        let headers: HTTPHeaders = [HeaderKeys.contentType: "application/json"]
        let params: [String: Any] = [ParameterKeys.email: email,
                                     ParameterKeys.password: password]
        
        AF.request(URLs.login, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print(response.error!)
                completion(response.error, nil)
                return
            }
            
            guard let data = response.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let loginData = try decoder.decode(LoginResponse.self, from: data)
                completion(nil, loginData)
            } catch let error {
                completion(error,nil)
                print(error)
            }
        }
    }
    
    // Register API
    class func register(with user: User, completion: @escaping (_ error: Error?, _ userData: LoginResponse?) -> Void) {
        let headers: HTTPHeaders = [HeaderKeys.contentType: "application/json"]
        let params: [String: Any] = [ParameterKeys.age: user.age,
                                     ParameterKeys.email: user.email,
                                     ParameterKeys.name: user.name,
                                     ParameterKeys.password: user.password]
        
        AF.request(URLs.register, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print(response.error!)
                completion(response.error, nil)
                return
            }
            
            guard let data = response.data else {
                print("didnt get data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let registerData = try decoder.decode(LoginResponse.self, from: data)
                completion(nil, registerData)
            } catch let error {
                completion(error, nil)
                print(error)
            }
        }
    }
    
    class func getTask(completion: @escaping (_ error: Error?, _ taskData: [TaskData]?) -> Void) {
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(UserDefaultsManager.shared().token!)",
            HeaderKeys.contentType: "application/json"]
        AF.request(URLs.task, method: .get ,encoding: JSONEncoding.default, headers: headers).response {
            respnose in
            guard respnose.error == nil else {
                print(respnose.error!)
                completion(respnose.error, nil)
                return
            }
            guard let data = respnose.data else {
                print("there is no data")
                return
            }
            do {
                let decoder = JSONDecoder()
                let taskData = try decoder.decode(TaskResponse.self, from: data).data
                completion(nil, taskData)
            } catch let error {
                completion(error, nil)
                print(error)
            }
            
        }
    }
    
    class func addTask(description: String, completion: @escaping (_ success: Bool) -> Void) {
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(UserDefaultsManager.shared().token!)",
            HeaderKeys.contentType: "application/json"]
        let params: [String: Any] = [ParameterKeys.description: description]
        AF.request(URLs.task, method: .post, parameters: params ,encoding: JSONEncoding.default, headers: headers).response { response in
            guard response.error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
        
    }
    
    
}



