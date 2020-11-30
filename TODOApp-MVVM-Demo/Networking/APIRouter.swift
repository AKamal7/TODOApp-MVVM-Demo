
import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible{
    
    // The endpoint name
    case login(_ user: User)
    case register(_ user: User)
    case getTodos
    case addTask(_ task: Task)
    case logOut
    case updateUserData(_ user: User)
    case getUserData
    case deleteTask(_ id: String)
    case getImage(_ userID: String)
    
    // MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self{
        case .getTodos, .getUserData, .getImage:
            return .get
        case .updateUserData:
            return .put
        case .deleteTask:
            return .delete
        default:
            return .post
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }
    // MARK: - Path
    private var path: String {
        switch self {
        case .login:
            return URLs.login
        case .register:
            return URLs.register
        case .getTodos, .addTask:
            return URLs.task
        case .logOut:
            return URLs.userLogOut
        case .updateUserData, .getUserData:
            return URLs.userData
        case .deleteTask(let id):
            return "\(URLs.task)/\(id)"
        case .getImage(let userID):
            return URLs.user + "/\(userID)" + "/avatar"
        }
    }
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try URLs.base.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        //httpMethod
        urlRequest.httpMethod = method.rawValue
        switch self {
        case .getTodos, .addTask, .logOut, .updateUserData, .getUserData, .deleteTask:
            urlRequest.setValue("Bearer \(UserDefaultsManager.shared().token ?? "")",
            forHTTPHeaderField: HeaderKeys.authorization)
        default:
            break
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: HeaderKeys.contentType)
        
        // HTTP Body
        let httpBody: Data? = {
            switch self {
            case .login(let body):
                return encodeToJSON(body)
            case .register(let body):
                return encodeToJSON(body)
            case .addTask(let body):
                return encodeToJSON(body)
            case .updateUserData(let body):
                return encodeToJSON(body)
            default:
                return nil
            }
        }()
        urlRequest.httpBody = httpBody
        
        // Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get, .delete:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        print(try encoding.encode(urlRequest, with: parameters))
        return try encoding.encode(urlRequest, with: parameters)
    }
    
}

extension APIRouter {
    private func encodeToJSON<T: Encodable>(_ body: T) -> Data? {
        do {
            let anyEncodable = AnyEncodable(body)
            let jsonData = try JSONEncoder().encode(anyEncodable)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            return jsonData
        } catch {
            print(error)
            return nil
        }
    }
}

// type-erasing wrapper
struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    
    public init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
