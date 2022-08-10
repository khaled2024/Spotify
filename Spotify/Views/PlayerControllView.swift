//
//  PlayerControllView.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 06/08/2022.

import Foundation
import UIKit
//MARK: - protocol
protocol PlayerControllViewDelegate: AnyObject{
    func playerControllViewDidTapPlayPauseButton(_ playerControllerView: PlayerControllView)
    func playerControllViewDidTapForwardButton(_ playerControllerView: PlayerControllView)
    func playerControllViewDidTapBackwardsButton(_ playerControllerView: PlayerControllView)
    func playerControllViewSlideVolume(_ playerControllerView: PlayerControllView, didSlideSlider value: Float)
}
struct PlayerControllViewModel {
    let title: String?
    let subTitle: String?
}

final class PlayerControllView: UIView{
    weak var delegate: PlayerControllViewDelegate?
    private var isPlaying = true
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    //MARK: - vars & outlets
    private let titleLable: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 21, weight: .semibold)
        lable.text = "----"
        lable.textColor = .label
        return lable
    }()
    private let subTitleLable: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 18, weight: .regular)
        lable.text = "--------------- -------- ----------------"
        lable.numberOfLines = 0
        lable.textColor = .label
        return lable
    }()
    private let backBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = .label
        btn.setImage(UIImage(systemName: "backward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
        return btn
    }()
    private let forwardBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = .label
        btn.setImage(UIImage(systemName: "forward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
        return btn
    }()
    private let pauseBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = .label
        btn.setImage(UIImage(systemName: "pause.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
        return btn
    }()
    //MARK: - lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(backBtn)
        addSubview(forwardBtn)
        addSubview(pauseBtn)
        addSubview(volumeSlider)
        addSubview(titleLable)
        addSubview(subTitleLable)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
        clipsToBounds = true
        
        pauseBtn.addTarget(self, action: #selector(didTapPause), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        forwardBtn.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
    }
    
    @objc func didSlideSlider(_ slider: UISlider ){
        let value = slider.value
        delegate?.playerControllViewSlideVolume(self, didSlideSlider: value)
    }
    @objc func didTapPause(){
        self.isPlaying = !isPlaying
        delegate?.playerControllViewDidTapPlayPauseButton(self)
        
        // update the icon
        let pause = UIImage(systemName: "pause.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        let play = UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        pauseBtn.setImage(isPlaying ? pause : play, for: .normal)
        
    }
    @objc func didTapBack(){
        delegate?.playerControllViewDidTapBackwardsButton(self)
    }
    @objc func didTapForward(){
        delegate?.playerControllViewDidTapForwardButton(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLable.frame = CGRect(x: 5, y: 0, width: width-10, height: 50)
        subTitleLable.frame = CGRect(x: 5, y: titleLable.bottom+10, width: width-10, height: 50)
        volumeSlider.frame = CGRect(x: 10, y: subTitleLable.bottom + 20, width: width-20, height: 44)
        let btnSize: CGFloat = 60
        pauseBtn.frame = CGRect(x: (width-btnSize) / 2, y: volumeSlider.bottom + 30, width: btnSize, height: btnSize)
        backBtn.frame = CGRect(x:pauseBtn.left-80-btnSize, y: pauseBtn.top, width: btnSize, height: btnSize)
        forwardBtn.frame = CGRect(x:pauseBtn.right+80, y: pauseBtn.top, width: btnSize, height: btnSize)
        
    }
    //MARK: - private functions
    func config(with viewModel: PlayerControllViewModel){
        self.titleLable.text = viewModel.title
        self.subTitleLable.text = viewModel.subTitle
    }
}
