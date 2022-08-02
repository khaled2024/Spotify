//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import UIKit

class PlaylistViewController: UIViewController {
    private let playlist: Playlist
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        ApiCaller.shared.getPlaylistDetails(for: playlist) { result in
            switch result{
            case .success(let model):
                print(model)
            case.failure(let error):
                print(error)
            }
        }
        
    }

}
