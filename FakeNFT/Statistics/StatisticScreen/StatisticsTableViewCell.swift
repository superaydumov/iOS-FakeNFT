//
//  StatisticsTableViewCell.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 10.12.23.
//

import UIKit

final class StatisticsTableViewCell: UITableViewCell {
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = UIColor.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.textPrimary
        return label
    }()
    
    private let nftCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.textPrimary
        return label
    }()
    
    private let grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yaLightGrayLight
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grayBackgroundView.layer.cornerRadius = 12
        grayBackgroundView.layer.masksToBounds = true
    }
    
    private func setupSubviews() {
        [rankLabel, grayBackgroundView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [avatarImageView, usernameLabel, nftCountLabel].forEach {
            grayBackgroundView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            rankLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            rankLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 20),
            rankLabel.heightAnchor.constraint(equalToConstant: 27),
            
            grayBackgroundView.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 8),
            grayBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            grayBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            grayBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            grayBackgroundView.heightAnchor.constraint(equalToConstant: 80),
            
            avatarImageView.leadingAnchor.constraint(equalTo: grayBackgroundView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: grayBackgroundView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            avatarImageView.heightAnchor.constraint(equalToConstant: 28),
            
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            usernameLabel.centerYAnchor.constraint(equalTo: grayBackgroundView.centerYAnchor),
            
            nftCountLabel.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor, constant: -16),
            nftCountLabel.centerYAnchor.constraint(equalTo: grayBackgroundView.centerYAnchor),
        ])
    }
    
    func configure(with user: UserModel, at index: Int) {
        rankLabel.text = "\(index + 1)"
        
        if let avatarURL = URL(string: user.avatar ?? "") {
            avatarImageView.kf.setImage(with: avatarURL, placeholder: UIImage(named: "userplaceholder"))
        } else {
            avatarImageView.image = UIImage(named: "userplaceholder")
        }
        
        usernameLabel.text = user.username
        
        if let nftCount = user.nftCount {
            nftCountLabel.text = "\(nftCount)"
        } else {
            nftCountLabel.text = "N/A"
        }
    }
}
