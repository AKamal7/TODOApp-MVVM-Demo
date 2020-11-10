

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
    
    //get Task
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
    
    //add task
    class func addTask(description: String, completion: @escaping (Bool) -> Void) {
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
    
    //delete task
    class func deleteTask(by id: String, completion: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(UserDefaultsManager.shared().token!)",
            HeaderKeys.contentType: "application/json"]
        AF.request(URLs.task + "/\(id)", method: .delete, headers: headers).response {
            response in
            guard response.error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    //get user data
    class func getUserData(completion: @escaping (_ error: Error?, _ userData: UserData?) -> Void) {
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(UserDefaultsManager.shared().token!)"]
        AF.request(URLs.userData, method: .get, headers: headers).response {
            response in
            guard response.error == nil else {
                completion(response.error, nil)
                return
            }
            guard let data = response.data else {
                print("there is no data")
                return
            }
            do {
                let decoder = JSONDecoder()
                let userData = try decoder.decode(UserData.self, from: data)
                completion(nil, userData)
            } catch let error {
                completion(error, nil)
                print(error)
            }
        }
    }
    
    // log out
    class func logOut(completion: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(UserDefaultsManager.shared().token!)"]
        AF.request(URLs.userLogOut, method: .post, headers: headers).response {
            response in
            guard response.error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // Upload Image
    class func uploadImage(with image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let jpegImage = image.jpegData(compressionQuality: 0.8),
            let token = UserDefaultsManager.shared().token else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(token)"]
        
        AF.upload(multipartFormData: { (formData) in
            formData.append(jpegImage, withName: "avatar", fileName: "/home/ali/Mine/c/nodejs-blog/public/img/blog-header.jpg", mimeType: "blog-header.jpg")
        }, to: URLs.uploadImage, method: HTTPMethod.post, headers: headers).response {
            respnose in
            guard respnose.error == nil else {
                print(respnose.error!.localizedDescription)
                completion(false)
                return
            }
            print(respnose)
            completion(true)
        }
    }
    
    // Get Profile Image
    class func getImage(userId: String, completion: @escaping (Error?, Data?) -> Void) {
        AF.request(URLs.user + "/\(userId)" + "/avatar", method: HTTPMethod.get).response { respone in
            guard respone.error == nil else {
                print(respone.error!)
                completion(respone.error, nil)
                return
            }
            guard let data = respone.data else {
                print("there is no data")
                return
            }
            completion(nil, data)
        }
    }
    
    // Update User Data
    class func updateUserData(with email: String, name: String, age: Int, completion: @escaping (Bool) -> Void) {
        let params: [String: Any] = [ParameterKeys.email: email,
                                     ParameterKeys.name: name,
                                     ParameterKeys.age: age]
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(UserDefaultsManager.shared().token!)",
            HeaderKeys.contentType: "application/json"]
        
        AF.request(URLs.userData, method: HTTPMethod.put,parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                completion(false)
                return
            }
             completion(true)
        }
    }
    
}

