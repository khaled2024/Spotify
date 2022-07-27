//
//  AuthViewController.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import UIKit
import WebKit
class AuthViewController: UIViewController{
    
    //MARK: - Outlets & vars
    //webView
    private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let pref = WKWebpagePreferences()
        pref.allowsContentJavaScript = true
        config.defaultWebpagePreferences = pref
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    public var completionHandler: ((Bool)-> Void)?
    
    //MARK: - lifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        guard let url = AuthManager.shared.signInURL else {return}
        webView.load(URLRequest(url: url))
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
}
//MARK: - WKNavigationDelegate
extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else{
            return
        }
        // Exchange the code for access token
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code"})?.value else{
            return
        }
        print("Code: \(code)")
    }
}
