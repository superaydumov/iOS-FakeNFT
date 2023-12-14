import Foundation

protocol ProfilePresenter: AnyObject {
    func updateUser(user: [ProfileModelImpl])
}

class ProfilePresenterImpl {
    // MARK: - Public Properties
    var user: [ProfileModelImpl] = []
    var defaultNetworkClient = DefaultNetworkClient()
    // MARK: - Private Properties
    private weak var view: ProfilePresenter?
    // MARK: - Initializers
    init(view: ProfilePresenter) {
        self.view = view
    }
    
    // MARK: - Prublic Methods
    func fetchData() {
        _ = getDataUser { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let usersList = try JSONDecoder().decode(ProfileList.self, from: data)
                    let dummyUsers = usersList.enumerated().map { index, element in
                        let nfts = element.nfts.compactMap { $0.value as? String }
                        
                        let profileModel = ProfileModelImpl(
                            name: element.name,
                            description: element.description.rawValue,
                            website: element.website,
                            avatarImage: element.avatar, nfts: nfts
                        )
                        return profileModel
                    }
                    self?.user = dummyUsers
                    let nftCount = dummyUsers.compactMap { $0.nfts }.count
                    DispatchQueue.main.async {
                        self?.view?.updateUser(user: dummyUsers)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    func getDataUser(completion: @escaping (Result<Data, Error>) -> Void) -> URLRequest? {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/users") else {
            return nil
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
        return urlRequest
    }
}
