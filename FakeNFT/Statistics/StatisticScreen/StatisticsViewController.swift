//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 10.12.23.
//

protocol StatisticsViewOutput: AnyObject {
    func fetchData(isFirstLoad: Bool)
    func sortUsersByRating()
    func sortUsersByName()
    func numberOfUsers() -> Int
    func user(at index: Int) -> StatisticsUserModel
    func updateUsers(users: [StatisticsUserModel])
}

import UIKit

final class StatisticsViewController: UIViewController, UINavigationControllerDelegate {
    private var output: StatisticsViewOutput?
    private let refreshControl = UIRefreshControl()
    private var isFirstLoad = true
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = true
        tableView.rowHeight = 80
        tableView.layer.cornerRadius = 12
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var sortBarButtonItem: UIBarButtonItem = {
        let sortImage = UIImage(named: "sort")
        let sortButton = UIButton(type: .system)
        sortButton.setBackgroundImage(sortImage, for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: sortButton)
        return barButtonItem
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .black
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        output = StatisticsPresenter(view: self)
        setupTableView()
        setupConstraints()
        output?.fetchData(isFirstLoad: true)
        
        navigationItem.rightBarButtonItem = sortBarButtonItem
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = .white
        }
    }
    
    func updateUsers(users: [StatisticsUserModel]) {
        output?.updateUsers(users: users)
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.register(StatisticsTableViewCell.self, forCellReuseIdentifier: "UserCell")
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func sortButtonTapped() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        let sortByNameAction = UIAlertAction(title: "По имени", style: .default) { [weak self] _ in
            self?.output?.sortUsersByName()
        }
        alertController.addAction(sortByNameAction)
        
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.output?.sortUsersByRating()
        }
        alertController.addAction(sortByRatingAction)
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func refreshData(_ sender: Any) {
        output?.fetchData(isFirstLoad: false)
    }
}

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output?.numberOfUsers() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? StatisticsTableViewCell else {
            return UITableViewCell()
        }
        if let user = output?.user(at: indexPath.row) {
            cell.configure(with: user, at: indexPath.row)
            cell.selectionStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = output?.user(at: indexPath.row) {
            let userCardVC = UserCardViewController(user: user)
            navigationController?.pushViewController(userCardVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension StatisticsViewController: StatisticsViewInput {
    func showActivityIndicator(isFirstLoad: Bool) {
        if isFirstLoad {
            activityIndicator.startAnimating()
        } else {
            refreshControl.beginRefreshing()
        }
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func showErrorAlert() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let alertController = UIAlertController(
                title: "Не удалось получить\nданные",
                message: nil,
                preferredStyle: .alert
            )
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let retryAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
                self?.output?.fetchData(isFirstLoad: true)
            }
            
            alertController.addAction(retryAction)
            alertController.preferredAction = retryAction
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
