//
//  PlayerViewController.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import UIKit
import SDWebImage
protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapBackward()
    func didTapForward()
    func didSlideSlider(_ value: Float)
}
class PlayerViewController: UIViewController {
    //MARK: - vars & outlet
    weak var dataSource: playerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blue
        return imageView
    }()
    private let controllerView = PlayerControllView()
    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationItem()
        view.addSubview(imageView)
        view.addSubview(controllerView)
        controllerView.delegate = self
        configure()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controllerView.frame = CGRect(x: 10, y: imageView.bottom+10, width: view.width - 20, height: view.height-imageView.height-view.safeAreaInsets.bottom-view.safeAreaInsets.top-15)
    }
    func configure(){
        self.imageView.sd_setImage(with: dataSource?.imageURL)
        controllerView.config(with: PlayerControllViewModel(title: dataSource?.songName, subTitle: dataSource?.subTitleName))
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
//MARK: - PlayerControllViewDelegate
extension PlayerViewController:  PlayerControllViewDelegate{
    func playerControllViewSlideVolume(_ playerControllerView: PlayerControllView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    func playerControllViewDidTapPlayPauseButton(_ playerControllerView: PlayerControllView) {
        delegate?.didTapPlayPause()
    }
    
    func playerControllViewDidTapForwardButton(_ playerControllerView: PlayerControllView) {
        delegate?.didTapForward()
    }
    
    func playerControllViewDidTapBackwardsButton(_ playerControllerView: PlayerControllView) {
        delegate?.didTapBackward()
    }
    
}
