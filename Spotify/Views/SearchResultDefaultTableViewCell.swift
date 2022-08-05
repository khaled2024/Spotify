//
//  SearchResultDefaultTableViewCell.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 05/08/2022.
//

import UIKit
import SDWebImage


class SearchResultDefaultTableViewCell: UITableViewCell {
    
    static let identifer = "SearchResultDefaultTableViewCell"
    private let lable:UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 1
        return lable
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(lable)
        contentView.addSubview(iconImageView)
        contentView.layer.masksToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        lable.text = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = contentView.height - 10
        iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
        iconImageView.layer.cornerRadius = imageSize / 2
        iconImageView.layer.masksToBounds = true

        lable.frame = CGRect(x: iconImageView.right + 10, y: 0, width: contentView.width-iconImageView.right-15, height: contentView.height)
    }
    func config(with viewModel: SearchResultDefaultTableViewCellViewModel){
        lable.text = viewModel.title
        iconImageView.sd_setImage(with: viewModel.image)
    }
    
    
}
