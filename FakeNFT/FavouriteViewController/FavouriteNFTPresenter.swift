import Foundation
import ProgressHUD

protocol FavoritePresenterProtocol: AnyObject {
    func nftViewDidLoad()
}

final class FavoriteNFTPresenter {
    private weak var view: FavoriteViewProtocol?
    var defaultNetworkClient = DefaultNetworkClient()
    private var onNFTCountUpdate: ((Int) -> Void)?

    private var likedNFTIds: String = ""

    init(view: FavoriteViewProtocol) {
        self.view = view
    }

    func nftViewDidLoad() {
        ProgressHUD.show()
        fetchLikedNFTs()
    }

    func toggleLike(for nftId: String) {
        var likedNFTsArray = likedNFTIds.components(separatedBy: ",").filter { !$0.isEmpty }
        if let index = likedNFTsArray.firstIndex(of: nftId) {
            likedNFTsArray.remove(at: index)
        } else {
            likedNFTsArray.append(nftId)
        }
        likedNFTIds = likedNFTsArray.joined(separator: ",")

        updateNFTs()
        sendUpdatedProfileToServer()
    }

    private func fetchLikedNFTs() {
        _ = defaultNetworkClient.send(request: ProfileRequest(), completionQueue: .main) { [weak self] result in
            ProgressHUD.dismiss()
            switch result {
            case .success(let data):
                do {
                    let profile = try JSONDecoder().decode(Profile.self, from: data)

                    if let likes = profile.likes {
                        let likesString = likes.joined(separator: ",")
                        self?.likedNFTIds = likesString
                    } else {
                        print("Liked NFTs IDs is nil")
                    }
                    self?.updateNFTs()
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print("Error fetching liked NFTs data: \(error)")
            }
        }
    }

    private func updateNFTs() {
        let mockNFTs = createMockNFTsFromNetwork()

        // только те NFT, которые отмечены лайками
        let likedNFTs = mockNFTs.filter { likedNFTIds.contains($0.id) }

        let nftCount = likedNFTs.count
        onNFTCountUpdate?(nftCount)

        view?.updateFavNFT(viewModel: likedNFTs)
    }

    private func updateProfileData(updatedProfile: Profile, completion: @escaping (Result<Data, Error>) -> Void) {
        let putRequest = PutProfileRequest(updatedProfile: updatedProfile)

        guard let urlRequest = createURLRequest(for: putRequest, with: updatedProfile) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
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
    }

    private func createURLRequest(for request: NetworkRequest, with profile: Profile) -> URLRequest? {
        guard let endpointURL = request.endpoint else {
            return nil
        }
        var urlRequest = URLRequest(url: endpointURL)
        urlRequest.httpMethod = request.httpMethod.rawValue

        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(RequestConstants.accessToken, forHTTPHeaderField: "X-Practicum-Mobile-Token")

        if let parameters = createParameters(for: profile) {
            let parameterString = parameters
                .map { "\($0.key)=\($0.value)" }
                .joined(separator: "&")
            urlRequest.httpBody = parameterString.data(using: .utf8)
        }
        return urlRequest
    }

    private func createParameters(for profile: Profile) -> [String: Any]? {
        let parameters: [String: Any] = [
            "likes": likedNFTIds
        ]
        return parameters
    }

    private func sendUpdatedProfileToServer() {
        let updatedProfile = Profile(
            name: "",
            description: "",
            website: "",
            avatar: "",
            nfts: nil,
            likes: likedNFTIds.components(separatedBy: ","),
            id: ""
        )
        updateProfileData(updatedProfile: updatedProfile) { result in
            switch result {
            case .success:
                print("Updated likes on the server: \(self.likedNFTIds)")
            case .failure(let error):
                print("Error updating the profile: \(error)")
            }
        }
    }

    // Создание NFT с замоканными данными
    private func createMockNFTsFromNetwork() -> [FavoriteNFTViewModel] {
        let mockNFT1 = FavoriteNFTViewModel(
            images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!],
            name: "Lilo",
            rating: 3,
            price: 10.99,
            isFavorite: true,
            id: "739e293c-1067-43e5-8f1d-4377e744ddde"
        )

        let mockNFT2 = FavoriteNFTViewModel(
            images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!],
            name: "Spring",
            rating: 3,
            price: 15.99,
            isFavorite: true,
            id: "77c9aa30-f07a-4bed-886b-dd41051fade2"
        )

        let mockNFT3 = FavoriteNFTViewModel(
            images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!],
            name: "Aprill",
            rating: 4,
            price: 18.99,
            isFavorite: true,
            id: "ca34d35a-4507-47d9-9312-5ea7053994c0"
        )
        return [mockNFT1, mockNFT2, mockNFT3]
    }
}
