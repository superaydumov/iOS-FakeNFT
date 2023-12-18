//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 12.12.23.
//

import UIKit        //Это относится к части statistics2-3, сверстал чтобы проверить работу перехода
import WebKit

class WebViewController: UIViewController {

    var url: URL!

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var backBarButtonItem: UIBarButtonItem = {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                        style: .plain, target: self,
                                        action: #selector(leftBarButtonItemTapped))
        backButton.tintColor = .black
        return backButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(webView)
        
        navigationItem.leftBarButtonItem = backBarButtonItem

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc private func leftBarButtonItemTapped() {
        navigationController?.popViewController(animated: true)
    }
}
