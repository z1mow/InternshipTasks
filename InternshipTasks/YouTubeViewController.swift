//
//  YouTubeViewController.swift
//  InternshipTasks
//
//  Created by Şakir Yılmaz ÖĞÜT on 25.02.2025.
//

import UIKit

class YouTubeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var videos: [YouTubeVideo] = []
    private let apiKey = "AIzaSyBFoBCne7LHqA-Z4vl5Rn8iB9egqoFkBXw"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private func searchYouTubeVideos(query: String) {
        let baseURL = "https://www.googleapis.com/youtube/v3/search"
        let parameters = ["part": "snippet",
                          "q": query,
                          "key": apiKey,
                          "maxResults": "20", // search result olarak dönen video sayısı
                          "type": "video"
        ]
        
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [ weak self ] data, response, error in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(YouTubeSearchResponse.self, from: data)
                
                
                let videos = response.items.map { item -> YouTubeVideo in
                    if item.id.videoId == nil {
                        return .init(videoId: "", title: item.snippet.title, channelTitle: "", thumbnailURL: item.snippet.thumbnails.medium.url, description: item.snippet.description)
                    }
                    return YouTubeVideo(
                        videoId: item.id.videoId ?? "",
                        title: item.snippet.title,
                        channelTitle: item.snippet.channelTitle,
                        thumbnailURL: item.snippet.thumbnails.medium.url,
                        description: item.snippet.description
                    )
                }
                
                DispatchQueue.main.async {
                    self?.videos = videos
                    self?.tableView.reloadData()
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YouTubeCell", for: indexPath)
        let video = videos[indexPath.row]
        
        if let imageView = cell.viewWithTag(1) as? UIImageView,
            let titleLabel = cell.viewWithTag(2) as? UILabel,
            let channelLabel = cell.viewWithTag(3) as? UILabel {
            
            titleLabel.text = video.title
            channelLabel.text = video.channelTitle
            
            if let url = URL(string: video.thumbnailURL) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }
                    
                    
                }.resume()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let playerVC = storyboard.instantiateViewController(withIdentifier: "YouTubeVideoPlayerViewController") as? YouTubeVideoPlayerViewController {
            playerVC.video = video
            playerVC.modalPresentationStyle = .fullScreen
            present(playerVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            searchYouTubeVideos(query: searchText)
        }
        searchBar.resignFirstResponder()
    }

}
