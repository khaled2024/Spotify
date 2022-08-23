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
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "albums")
        return image
    }()
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
    }()
    private let logoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "Logo")
        return image
    }()
    private let lable: UILabel = {
        let lable = UILabel()
        lable.textColor = .white
        lable.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        lable.text = "Listen to millions of Songs"
        lable.textAlignment = .center
        lable.numberOfLines = 0
        return lable
    }()
    //MARK: - Life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .black
        view.addSubview(logoImage)
        view.addSubview(overlayView)
        view.addSubview(lable)
        view.addSubview(logoImageView)
        view.addSubview(signInButton)

        signInButton.addTarget(self, action: #selector(didTappedSignInButton), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        overlayView.frame = view.bounds
        logoImage.frame = view.bounds
        logoImageView.frame = CGRect(x: (view.width-120)/2, y: (view.height-250)/2, width: 120, height: 120)
        lable.frame = CGRect(x: 30, y: logoImageView.bottom+15, width: view.width-60, height: 150)
        signInButton.frame = CGRect(x: 20, y: view.height - 70 - view.safeAreaInsets.bottom, width: view.width - 40, height: 50)
    }
    //MARK: - Private func
    @objc private func didTappedSignInButton(){
        let vc = AuthViewController()
        // if completionHandler has a Value
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handelSignIn(success: success)
            }
        }
        // for fiest time sign in go to auth and sign in to Agree
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
