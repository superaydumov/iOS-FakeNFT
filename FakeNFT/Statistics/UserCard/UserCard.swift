//
//  UserCard.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 12.12.23.
//

import UIKit

class UserCard: UIViewController {

    private let user: UserModel
    
    init(user: UserModel) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // UI элементы
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
//        label.text = "Andrey"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
//        label.text = "Omnomnom"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private let websiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nftButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Устанавливаем текст кнопки
        button.setTitle("Коллекция NFT", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)

        // Задаем изображение для значка
        let arrowImage = UIImage(systemName: "chevron.right")
        button.setImage(arrowImage?.withTintColor(.black), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit

        // Отступ для изображения от левого края
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        
        // Устанавливаем отступы
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)

        button.addTarget(self, action: #selector(nftButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(websiteButton)
        view.addSubview(nftButton)
        
        if let avatarURL = URL(string: user.avatar ?? "") {
            avatarImageView.kf.setImage(with: avatarURL, placeholder: UIImage(named: "placeholder"))
        } else {
            avatarImageView.image = UIImage(named: "placeholder")
        }
        
        nameLabel.text = user.username
        descriptionLabel.text = user.description
    }

    private func setupConstraints() {
        // Аватарка
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 29),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),

        // Имя пользователя
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),

        // Description
            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

        // Кнопка "Перейти на сайт пользователя"
            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            websiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            websiteButton.heightAnchor.constraint(equalToConstant: 40),

        // Кнопка "Коллекция NFT"
            nftButton.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 40),
            nftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }

    @objc private func websiteButtonTapped() {
        if let websiteString = user.website, let websiteURL = URL(string: websiteString) {
            let webViewController = WebViewController()
            webViewController.url = websiteURL
            navigationController?.pushViewController(webViewController, animated: true)
        } else {
            // Обработка случаев, когда websiteString или URL не могут быть созданы
            print("Invalid website URL")
        }
    }



    @objc private func nftButtonTapped() {
        // Обработка нажатия на кнопку "Коллекция NFT"
    }
}
