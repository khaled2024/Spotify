//
//  ProfileViewController.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import UIKit
import SDWebImage
class ProfileViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    private var models = [String]()
    //MARK: - life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        self.fetchProfile()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    //MARK: - func
    private func fetchProfile(){
        ApiCaller.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Failed to get data \(error.localizedDescription)")
                    self?.failedToGetProfile()
                case .success(let model):
                    self?.updateUI(with: model)
                }
            }
        }
    }
    private func updateUI(with model: UserProfile){
        tableView.isHidden = false
        models.append("Full Name: \(model.display_name)")
        models.append("Email Address: \(model.email)")
        models.append("User ID: \(model.id)")
        models.append("PLan: \(model.product)")
        self.createTableHeader(with: "https://i.pinimg.com/474x/9d/d0/18/9dd018c0e21f871f6915a0be8de3f34e.jpg")
        tableView.reloadData()
    }
    private func failedToGetProfile(){
        let lable = UILabel(frame: .zero)
        lable.text = "Failed to load profile"
        lable.textColor = .secondaryLabel
        view.addSubview(lable)
        lable.sizeToFit()
        lable.center = view.center
    }
    private func createTableHeader(with string: String?){
        guard let urlString = string , let url = URL(string: urlString) else{
            return
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width / 1.5))
        let imageSize: CGFloat = headerView.height/1.5
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url, completed: nil)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize/2
        tableView.tableHeaderView = headerView
    }
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
}
