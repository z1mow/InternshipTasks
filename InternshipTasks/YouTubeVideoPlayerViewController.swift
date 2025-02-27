//
//  YouTubeVideoPlayerViewController.swift
//  InternshipTasks
//
//  Created by Şakir Yılmaz ÖĞÜT on 25.02.2025.
//

import UIKit
import WebKit

class YouTubeVideoPlayerViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    var video: YouTubeVideo!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let video = video {
            titleLabel.text = video.title
            channelLabel.text = video.channelTitle
            descriptionTextView.text = video.description
            
            loadYouTubeVideo(videoId: video.videoId)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private func loadYouTubeVideo(videoId: String) {
        let embedHTML = """
            <html>
            <body style="margin:0">
            <iframe width="100%" height="100%" src="https://www.youtube.com/embed/\(videoId)?playsinline=1" frameborder="0" allowfullscreen></iframe>
            </body>
            </html>
            """
        
        webView.loadHTMLString(embedHTML, baseURL: nil)
    }

}
