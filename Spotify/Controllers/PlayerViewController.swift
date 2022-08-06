//
//  PlayerViewController.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import UIKit

class PlayerViewController: UIViewController {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blue
        return imageView
    }()
    private let controllerView = PlayerControllView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationItem()
        view.addSubview(imageView)
        view.addSubview(controllerView)
        controllerView.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controllerView.frame = CGRect(x: 10, y: imageView.bottom+10, width: view.width - 20, height: view.height-imageView.height-view.safeAreaInsets.bottom-view.safeAreaInsets.top-15)
    }
    func configureNavigationItem(){
        navigationItem.largeTitleDisplayMode  = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTappedBtn))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTappedBtn))
    }
    @objc func closeTappedBtn(){
        dismiss(animated: true,completion: nil)
    }
    
    @objc func shareTappedBtn(){
        // action
    }
    
}
extension PlayerViewController:  PlayerControllViewDelegate{
    func playerControllViewDidTapPlayPauseButton(_ playerControllerView: PlayerControllView) {
        //
    }
    
    func playerControllViewDidTapForwardButton(_ playerControllerView: PlayerControllView) {
        //
    }
    
    func playerControllViewDidTapBackwardsButton(_ playerControllerView: PlayerControllView) {
        //
    }
    
    
    
}
