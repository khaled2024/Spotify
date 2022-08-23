//
//  ViewController.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import UIKit

class LibraryViewController: UIViewController {
    
    //MARK: - vars & outlets
    private let playlistsVC = LibraryPlaylistViewController()
    private let AlbumsVC = LibraryAlbumViewController()
    private let toggleView = LibraryToggleView()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Library"
        view.backgroundColor = .systemBackground
        scrollView.delegate = self
        view.addSubview(scrollView)
        view.addSubview(toggleView)
        scrollView.contentSize = CGSize(width: view.width*2, height: scrollView.height)
        addChildren()
        toggleView.delegate = self
        updateBarButton()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 55, width: view.width, height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 55)
        toggleView.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: 200, height: 55)
    }
    //MARK: - private func
    func updateBarButton(){
        switch toggleView.state{
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        case.album:
            navigationItem.rightBarButtonItem = nil
        }
    }
    private func addChildren(){
        addChild(playlistsVC)
        scrollView.addSubview(playlistsVC.view)
        playlistsVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playlistsVC.didMove(toParent: self)
        
        addChild(AlbumsVC)
        scrollView.addSubview(AlbumsVC.view)
        AlbumsVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        AlbumsVC.didMove(toParent: self)
    }
    @objc func didTapAdd(){
        playlistsVC.showCreatePlaylistAlert()
    }
}
extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.width-100){
            toggleView.update(for: .album)
            updateBarButton()
        }else{
            toggleView.update(for: .playlist)
            updateBarButton()
        }
    }
}
extension LibraryViewController: LibraryToggleViewDelegate{
    func LibraryToggleViewDidTapPlaylist(_ toggleview: LibraryToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
        updateBarButton()
    }
    func LibraryToggleViewDidTapAlbum(_ toggleview: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
        updateBarButton()
    }
}
