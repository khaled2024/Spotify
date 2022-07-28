//  WelcomeViewController.swift
//  Spotify
//  Created by KhaleD HuSsien on 27/07/2022.

import UIKit
class WelcomeViewController: UIViewController {
    //MARK: - vars & outlets
    // sign in
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In With Spotify", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 15
        button.backgroundColor = .white
        return button
    }()
    //MARK: - Life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTappedSignInButton), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 20, y: view.height - 70 - view.safeAreaInsets.bottom, width: view.width - 40, height: 50)
    }
    //MARK: - Private func
    @objc private func didTappedSignInButton(){
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handelSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    private func handelSignIn(success: Bool){
        // log user in or get error
        guard success else{
            let alert = UIAlertController(title: "Opps", message: "something wrong when sign in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "cancle", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        let mainAppTabBar = TabBarViewController()
        mainAppTabBar.modalPresentationStyle = .fullScreen
        present(mainAppTabBar, animated: true)
        
    }
}
