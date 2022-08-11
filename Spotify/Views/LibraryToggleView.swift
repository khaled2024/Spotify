//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 10/08/2022.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
    func LibraryToggleViewDidTapPlaylist(_ toggleview: LibraryToggleView)
    func LibraryToggleViewDidTapAlbum(_ toggleview: LibraryToggleView)
}

class LibraryToggleView: UIView {
    enum State {
        case playlist
        case album
    }
     var state: State = .playlist
    weak var delegate: LibraryToggleViewDelegate?
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
        
    }()
    private let albumButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
        
    }()
    private let indecatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    //MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistButton)
        addSubview(albumButton)
        addSubview(indecatorView)
        playlistButton.addTarget(self, action: #selector(didTapPlaylist), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(didTapAlbum), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistButton.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        albumButton.frame = CGRect(x: playlistButton.right, y: 0, width: 100, height: 44)
        layOutIndecator()
        
    }
    
    //MARK: - functions
    func layOutIndecator(){
        switch state {
        case .playlist:
            indecatorView.frame = CGRect(x: 0, y: playlistButton.bottom, width: 100, height: 2)
        case .album:
            indecatorView.frame = CGRect(x: 100, y: playlistButton.bottom, width: 100, height: 2)
        }
    }
    @objc func didTapPlaylist(){
        state = .playlist
        UIView.animate(withDuration: 0.2) {
            self.layOutIndecator()
        }
        delegate?.LibraryToggleViewDidTapPlaylist(self)
    }
    @objc func didTapAlbum(){
        state = .album
        UIView.animate(withDuration: 0.2) {
            self.layOutIndecator()
        }
        delegate?.LibraryToggleViewDidTapAlbum(self)
    }
    func update(for state: State){
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layOutIndecator()
        }
    }
}
