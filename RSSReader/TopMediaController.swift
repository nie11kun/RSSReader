//
//  ViewController.swift
//  RSSReader
//
//  Created by Marco Nie on 19/05/2017.
//  Copyright © 2017 Marco Nie. All rights reserved.
//

import UIKit

class TopMediaController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBInspectable var feedURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let request = URLRequest(url: URL(string: feedURL)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: { response, data, error in
                if let jsonData = data,
                    let feed = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? NSDictionary,
                    let title = feed.value(forKeyPath: "feed.entry.im:name.label") as? String,
                    let artist = feed.value(forKeyPath: "feed.entry.im:artist.label") as? String,
                    let imageURLs = feed.value(forKeyPath: "feed.entry.im:image") as? [NSDictionary] {
                        if let imageURL = imageURLs.last,
                            let imageURLString = imageURL.value(forKey: "label") as? String {
                                self.loadImageFromURL(url: URL(string: imageURLString)!)
                    }
                    self.titleLabel.text = title
                    self.titleLabel.isHidden = false
                    self.artistLabel.text = artist
                    self.artistLabel.isHidden = false
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadImageFromURL(url: URL) {
        let request = URLRequest(url: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {
        response, data, error in
            if let imageData = data {
                self.imageView.image = UIImage(data: imageData)
            }
        })
    }

}

