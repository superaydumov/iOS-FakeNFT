import Foundation
import ProgressHUD

protocol ProfilePresenter: AnyObject {
    func updateUser(user: [Profile])
}

class ProfilePresenterImpl {
    // MARK: - Public Properties
    var user: [Profile] = []
    var defaultNetworkClient = DefaultNetworkClient()
    // MARK: - Private Properties
    private weak var view: ProfilePresenter?
    // MARK: - Initializers
    init(view: ProfilePresenter) {
        self.view = view
    }
    
    // MARK: - Prublic Methods
    
    func fetchData() {
        ProgressHUD.show()
        _ = defaultNetworkClient.send(request: ProfileRequest(), completionQueue: .main) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let profile = try JSONDecoder().decode(Profile.self, from: data)
                    print("Decoded profile model: \(profile)")
                    
                    DispatchQueue.main.async {
                        self?.view?.updateUser(user: [profile])
                        ProgressHUD.dismiss()
                    }
                } catch {
                    print("Failed JSON data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
                    print("Error decoding JSON: \(error)")
                    ProgressHUD.dismiss()
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
                ProgressHUD.dismiss()
            }
        }
    }
    
    
    func getDataUser(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1") else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("\(RequestConstants.accessToken)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                completion(.success(data))
            } else {
                let noDataError = NSError(domain: "NoData", code: 0, userInfo: nil)
                completion(.failure(noDataError))
            }
        }
        task.resume()
        // return urlRequest
    }
    
    
    func updateProfileData(updatedProfile: Profile, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            let putRequest = PutProfileRequest(updatedProfile: updatedProfile)
            guard let endpoint = putRequest.endpoint else {
                completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
                return
            }
            var urlRequest = URLRequest(url: endpoint)
            urlRequest.httpMethod = putRequest.httpMethod.rawValue
            urlRequest.httpBody = putRequest.httpBody
            urlRequest.setValue("\(RequestConstants.accessToken)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
            print("URL запроса:", urlRequest.url?.absoluteString ?? "")
            print("Тело запроса:", String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) ?? "")

            defaultNetworkClient.send(request: putRequest, completionQueue: .main) { result in
                switch result {
                case .success(let data):
                    print("Профиль успешно обновлен на сервере.")
                    completion(.success(data))
                case .failure(let error):
                    print("Ошибка при обновлении профиля на сервере: \(error)")
                    completion(.failure(error))
                }
            }
        } catch {
            print("Ошибка кодирования данных профиля: \(error)")
            completion(.failure(error))
        }
    }
}
