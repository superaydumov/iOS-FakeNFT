import UIKit

protocol ProfilePresenter {
    func viewDidLoad()
    func numberOfRows(in section: Int) -> Int
    func configure(cell: UITableViewCell, at indexPath: IndexPath)
    func getAvatarImage() -> UIImage
    
    func updateBio(_ newBio: String)
    func updateName(_ newName: String)
    func updateLink(_ newLink: String)
    
    func updateProfile(name: String, bio: String, link: String)
}

class ProfilePresenterImpl: ProfilePresenter {
    weak var view: ProfileView?
    var model: ProfileModel

    init(view: ProfileView, model: ProfileModel) {
        self.view = view
        self.model = model
    }

    func viewDidLoad() {
        view?.updateUI(with: model)
    }

    func numberOfRows(in section: Int) -> Int {
        return model.cellTexts.count
    }

    func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cell.textLabel?.text = model.cellTexts[indexPath.row]
        cell.textLabel?.textColor = .black
    }

    func getAvatarImage() -> UIImage {
        return model.avatarImage
    }
    func updateBio(_ newBio: String) {
          model.bio = newBio
          view?.updateUI(with: model)
      }
    
    func updateName(_ newName: String) {
          model.name = newName
          view?.updateUI(with: model)
      }
    func updateLink(_ newLink: String) {
          model.link = newLink
          view?.updateUI(with: model)
      }
    func updateProfile(name: String, bio: String, link: String) {
            model.name = name
            model.bio = bio
            model.link = link
            view?.updateUI(with: model)
        }
}
