//
//  LibraryPlaylistViewController.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 10/08/2022.
//

import UIKit

class LibraryPlaylistViewController: UIViewController{
    
    var playlists = [Playlist]()
    private let noPlaylistView = ActionLableView()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero , style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifer)
        tableView.isHidden = true
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setUpNoPlaylist()
        fetchData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistView.center = view.center
        tableView.frame = view.bounds
    }
    
    
    //MARK: - private func
    
    func setUpNoPlaylist(){
        noPlaylistView.config(with: ActionLableViewModel(title: "you dont have any playlist yet.", actionTitle: "Create"))
        noPlaylistView.delegate = self
        view.addSubview(noPlaylistView)
    }
    func fetchData(){
        ApiCaller.shared.getCurrentUserPlaylist { result in
            DispatchQueue.main.async {
                switch result {
                case.success(let playlists):
                    self.playlists = playlists
                    self.updateUI()
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    func updateUI(){
        if self.playlists.isEmpty {
            // show lable
            noPlaylistView.isHidden = false
            tableView.isHidden = true
        }else{
            // show table of playlists
            tableView.reloadData()
            noPlaylistView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    public func showCreatePlaylistAlert(){
        // show creation ui
        let alert = UIAlertController(title: "New playlist", message: "Enter playlist name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlist..."
        }
        alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first , let text = field.text , !text.trimmingCharacters(in: .whitespaces).isEmpty else{
                return
            }
            print(text)
            ApiCaller.shared.createPlaylist(with: text) { [weak self] success in
                if success {
                    // refrech playlists
                    self?.fetchData()
                }else{
                    print("failed to create playlist")
                }
            }
        }))
        present(alert, animated: true)
        
    }
}
extension LibraryPlaylistViewController: ActionLableViewDelegate{
    func ActionLableViewDidTapButton(_ actionView: ActionLableView) {
        showCreatePlaylistAlert()
    }
}
extension LibraryPlaylistViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifer, for: indexPath)as! SearchResultSubtitleTableViewCell
        let playlist = playlists[indexPath.row]
        cell.config(with: SearchResultSubTitleTableViewCellViewModel(title: playlist.name, subTitle: playlist.owner.display_name, imageUrl: URL(string: playlist.images.first?.url ?? "")))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
