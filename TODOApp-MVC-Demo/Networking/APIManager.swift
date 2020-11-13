

import Foundation
import Alamofire

class APIManager {
    
    // Login to API
    class func  login(with user: User, completion: @escaping (Result<LoginResponse, Error>)-> ()){
        request(APIRouter.login(user)){ (response) in
            completion(response)
        }
    }
    
    // Register API
    class func register(with user: User, completion: @escaping (Result<LoginResponse, Error>) -> Void ) {
        request(APIRouter.register(user)) { (response) in
            completion(response)
        }
    }

    
    //get Task
    class func getTask(completion: @escaping (Result<TaskResponse, Error>) -> Void) {
        request(APIRouter.getTodos) { (response) in
            completion(response)
        }
    }
    
    //add task
    class func addTask(with task: Task, completion: @escaping (Bool) -> Void) {
        requestBool(APIRouter.addTask(task)) { (response) in
            completion(response)
        }
    }
    
    //delete task
    class func deleteTask(by id: String, completion: @escaping (Bool) -> Void) {
        requestBool(APIRouter.deleteTask(id)) { (response) in
            completion(response)
        }
    }
    
    //get user data
    class func getUserData(completion: @escaping (Result<UserData, Error>) -> Void) {
        request(APIRouter.getUserData) { (response) in
            completion(response)
        }
    }
    
    // log out
    class func logOut(completion: @escaping (Bool) -> Void) {
        requestBool(APIRouter.logOut) { (response) in
            completion(response)
        }
    }
    
    // Upload Image
    class func uploadImage(with image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let jpegImage = image.jpegData(compressionQuality: 0.8),
            let token = UserDefaultsManager.shared().token else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: "Bearer \(token)"]
        
        AF.upload(multipartFormData: { (formData) in
            formData.append(jpegImage, withName: "avatar", fileName: "/home/ali/Mine/c/nodejs-blog/public/img/blog-header.jpg", mimeType: "blog-header.jpg")
        }, to: URLs.base + URLs.uploadImage, method: HTTPMethod.post, headers: headers).response {
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
    class func getImage(userID: String, completion: @escaping (Result<Data, Error>) -> Void) {
        requestData(APIRouter.getImage(userID)) { (response) in
            completion(response)
        }
    }
    
    // Update User Data
    class func updateUserData(with user: User, completion: @escaping (Bool) -> Void) {
        requestBool(APIRouter.updateUserData(user)) { (response) in
            completion(response)
        }
    }
}

extension APIManager{
    // MARK:- The request function to get results in a closure
    private static func request<T: Decodable>(_ urlConvertible: URLRequestConvertible, completion:  @escaping (Result<T, Error>) -> ()) {
        // Trigger the HttpRequest using AlamoFire
        AF.request(urlConvertible).responseDecodable { (response: AFDataResponse<T>) in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        .responseJSON { response in
            print(response)
        }
    }
    
    private static func requestData(_ urlConvertible: URLRequestConvertible, completion:  @escaping (Result<Data, Error>) -> Void) {
        AF.request(urlConvertible).response { (response) in
            switch response.result {

            case .success(let data):
                guard let data = data else {return}
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private static func requestBool(_ urlConvertible: URLRequestConvertible, completion: @escaping (Bool) ->  Void) {
        AF.request(urlConvertible).response { response in
            switch response.result {
                
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
}


