//
//  ViewController.swift
//  iTunes Podcasts
//
//  Created by Eric Dolecki on 7/19/19.
//  Copyright © 2019 Eric Dolecki. All rights reserved.
//

import UIKit


struct Root: Codable {
    let results: [Podcast]
}

struct Podcast: Codable {
    var artistName: String
    var collectionName: String
    var artworkUrl600: String
    // feedUrl will bring back XML of all the podcast content for a podcast.
    // Not implemented.
    var feedUrl: String?
    var country: String
    var primaryGenreName: String
    var contentAdvisoryRating: String?
    var releaseDate: String
    var collectionId: Int
    var trackCount: Int
    
    enum CodingKeys: String, CodingKey {
        case artistName = "artistName"
        case collectionName = "collectionName"
        case artworkUrl600 = "artworkUrl600"
        case feedUrl = "feedUrl"
        case country = "country"
        case primaryGenreName = "primaryGenreName"
        case contentAdvisoryRating = "contentAdvisoryRating"
        case releaseDate = "releaseDate"
        case collectionId = "collectionId"
        case trackCount = "trackCount"
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var myTableView: UITableView!
    var podcasts:[Podcast] = [Podcast]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        largeImage.layer.shadowColor = UIColor.black.cgColor
        largeImage.layer.shadowOffset = CGSize(width: 0, height: 4)
        largeImage.layer.shadowRadius = 10.0
        largeImage.layer.shadowOpacity = 0.4
        largeImage.layer.masksToBounds = false
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        let term = "Sundell".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        loadItunesPodcasts(searchTerm: term!)
        
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            let term = "Swift".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            self.loadItunesPodcasts(searchTerm: term!)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0, execute: {
            let term = "Steve Jobs".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            self.loadItunesPodcasts(searchTerm: term!)
        })
        */
    }

    func loadItunesPodcasts(searchTerm: String)
    {
        let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&media=podcast&entity=podcast")
        do {
            let contents = try String(contentsOf: url!)
            
            //print(contents)
            
            let data = contents.data(using: String.Encoding.utf8)
            let decoder = JSONDecoder()
            let root = try decoder.decode(Root.self, from: data!)
            
            //print(root)
            
            let base = root.results[0]
            let imageURL = URL(string: base.artworkUrl600)
            podcastImageView.load(url: imageURL!)
            
            podcasts.removeAll()
            for podcast in root.results {
                podcasts.append(podcast)
            }
            myTableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! PodcastTableViewCell
        cell.authorLabel.text = podcasts[indexPath.row].artistName
        cell.nameLabel.text = podcasts[indexPath.row].collectionName
        cell.myImageView.load(url: URL(string: podcasts[indexPath.row].artworkUrl600)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
