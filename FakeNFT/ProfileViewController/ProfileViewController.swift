
import UIKit

protocol ProfileView: AnyObject {
    func updateUI(with model: ProfileModel)
}
final class ProfileViewController: UIViewController, ProfileView {
    private var presenter:  ProfilePresenter!
    private var cellTexts = ["Мои NFT", "Избранные NFT", "О разработчике"]
    /* let servicesAssembly: ServicesAssembly
     init(servicesAssembly: ServicesAssembly) {
     self.servicesAssembly = servicesAssembly
     super.init(nibName: nil, bundle: nil)
     }
     required init?(coder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
     }
     @objc
     func showNft() {
     let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
     }*/
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    var newLink = ""
    
    private lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = label.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        return tableView
    }()
    private lazy var editButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(named: "editButton")//(systemName: "square.and.pencil")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold))
        barButtonItem.tintColor = .black
        barButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 9)
        barButtonItem.action = #selector(editButtonTapped)
        barButtonItem.target = self
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.topItem?.rightBarButtonItem = editButton
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        presenter = ProfilePresenterImpl(view: self, model: ProfileModelImpl())
        presenter.viewDidLoad()
        
        setupUI()
        setupConstraints()
        
    }
    
    func updateUI(with model: ProfileModel) {
        nameLabel.text = model.name
        bioLabel.text = model.bio
        
        let attributedString = NSMutableAttributedString(string: model.link)
        attributedString.addAttribute(.link, value: model.link, range: NSRange(location: 0, length: attributedString.length))
        linkLabel.attributedText = attributedString
        
        avatarImageView.image = presenter.getAvatarImage()
        
        cellTexts = model.cellTexts
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(bioLabel)
        view.addSubview(linkLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.bottomAnchor.constraint(equalTo: bioLabel.topAnchor, constant: -20),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 28),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 41),
            
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            bioLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            bioLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            bioLabel.bottomAnchor.constraint(equalTo: linkLabel.topAnchor, constant: -8),
            
            linkLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 8),
            linkLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            linkLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            linkLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -40),
            
            tableView.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    func createChevronImageView() -> UIImageView {
        let chevronImage = UIImage(systemName: "chevron.right")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let chevronImageView = UIImageView(image: chevronImage)
        return chevronImageView
    }
    
    @objc func editButtonTapped() {
        let profileEditViewController = ProfileEditViewController()
        profileEditViewController.presenter = self.presenter
        let navigationController = UINavigationController(rootViewController: profileEditViewController)
        present(navigationController, animated: true, completion: nil)
    }

}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let chevronImageView = createChevronImageView()
        cell.accessoryView = chevronImageView
        presenter.configure(cell: cell, at: indexPath)
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
}
