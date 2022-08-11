//
//  ActionLableView.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 11/08/2022.
//

import UIKit

struct ActionLableViewModel {
    let title: String
    let actionTitle: String
}
protocol ActionLableViewDelegate: AnyObject {
    func ActionLableViewDidTapButton(_ actionView: ActionLableView)
}
class ActionLableView: UIView {
    weak var delegate: ActionLableViewDelegate?
    
    private let lable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        lable.numberOfLines = 0
        lable.textColor = .secondaryLabel
        return lable
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.link, for: .normal)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lable)
        addSubview(button)
        self.isHidden = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc func didTapButton(){
        delegate?.ActionLableViewDidTapButton(self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        lable.frame = CGRect(x: 0, y: 0, width: width, height: height-45)
        button.frame = CGRect(x: 0, y: height-40, width: width, height:40)
    }
    func config(with viewModel: ActionLableViewModel){
        self.lable.text = viewModel.title
        self.button.setTitle(viewModel.actionTitle, for: .normal)
    }
}
