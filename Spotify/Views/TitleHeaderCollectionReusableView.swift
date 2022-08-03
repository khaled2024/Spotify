//
//  TitleHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 03/08/2022.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identfier = "TitleHeaderCollectionReusableView"
    private let titleLable: UILabel = {
       
        let lable = UILabel()
        lable.textColor = .label
        lable.numberOfLines = 1
        lable.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return lable
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLable.frame = CGRect(x: 20, y: 10, width: width - 40, height: height)
    }
    func config(title: String){
        self.titleLable.text = title
    }
    
}
