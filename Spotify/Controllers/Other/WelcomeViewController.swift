//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/03/2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInBtn: UIButton = {
        let Button = UIButton()
        Button.backgroundColor = .white
        Button.setTitle("Sign In For Spotify", for: .normal)
        Button.setTitleColor(UIColor.black, for: .normal)
        
        return Button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInBtn)
        signInBtn.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInBtn.frame = CGRect(x: 30, y: view.height-100-view.safeAreaInsets.bottom, width: view.width-60, height: 50)
    }
    
    @objc func didTapSignIn(){
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
