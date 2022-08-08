//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 06/08/2022.
//

import Foundation
import UIKit
import AVFoundation

//MARK: - protocol
protocol playerDataSource: AnyObject{
    var songName: String?{get}
    var subTitleName: String?{get}
    var imageURL: URL?{get}
    
}
//MARK: - class beginning
final class PlaybackPresenter{
    //MARK: - vars & outlets
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    static let shared = PlaybackPresenter()
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    var currentTrack: AudioTrack?{
        if let track = track , tracks.isEmpty {
            return track
        }else if let player = self.playerQueue, !tracks.isEmpty{
            let item = player.currentItem
            let items = player.items()
            guard let index = items.firstIndex(where: {$0 == item}) else{
                return nil
            }
            return tracks[index]
        }
        return nil
    }
    
    //MARK: - private functions
    // for single track & song
    func startPlayback(from viewController: UIViewController , track: AudioTrack){
        let vc = PlayerViewController()
        vc.title = track.name
        self.track = track
        self.tracks = []
        vc.dataSource = self
        vc.delegate = self
        //player
        guard let url = URL(string: track.preview_url ?? "")else{return}
        player = AVPlayer(url: url)
        player?.volume = 0.0
        viewController.present(UINavigationController(rootViewController: vc), animated: true) {
            self.player?.play()
        }
    }
    // for playlist
    func startPlayback(from viewController: UIViewController , tracks: [AudioTrack]){
        let vc = PlayerViewController()
        self.tracks = tracks
        self.track = nil
        vc.delegate = self
        vc.dataSource = self
        let items: [AVPlayerItem] = tracks.compactMap { track in
            guard let url = URL(string: track.preview_url ?? "") else{
                return nil
            }
           return AVPlayerItem(url: url)
            
        }
        self.playerQueue = AVQueuePlayer(items: items)
        self.playerQueue?.volume = 0
        self.playerQueue?.play()
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}
//MARK: - playerDataSource delegate
extension PlaybackPresenter: playerDataSource{
    var songName: String? {
        currentTrack?.name
    }
    var subTitleName: String? {
        currentTrack?.artists.first?.name
    }
    var imageURL: URL? {
        return  URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}
//MARK: - PlayerViewControllerDelegate
extension PlaybackPresenter: PlayerViewControllerDelegate{
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }else if player.timeControlStatus == .paused {
                player.play()
            }
        }else if let player = playerQueue{
            if player.timeControlStatus == .playing {
                player.pause()
            }else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    func didTapForward() {
        if tracks.isEmpty{
            player?.pause()
            player?.play()
        }else if let firstItem = playerQueue?.items().first{
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            playerQueue?.volume = 0
        }
    }

    func didTapBackward() {
        if tracks.isEmpty{
            player?.pause()
        }else{
            // next track
        }
    }
    
}
