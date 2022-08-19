//
//  NetworkManager.swift
//  RandomDogImages
//
//  Created by ALEKSEY SUSLOV on 19.08.2022.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let stringURL = "https://dog.ceo/api/breeds/image/random/3"
    
    private func fetchDogURLStrings(_ complition: @escaping (_ dogImageURLStrings: [String]) -> ()) {
        
        guard let url = URL(string: stringURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let safeData = data else { return }
            
            do {
                let dogURLImages = try JSONDecoder().decode(DogURLImages.self, from: safeData)
                complition(dogURLImages.message)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    func fetchImages(complition: @escaping (_ dogImages: [UIImage]) -> ()) {
        
        self.fetchDogURLStrings() { dogImageURLStrings in
            var dogImages = [UIImage]()
            
            DispatchQueue.global().async {
                for dogImageURLString in dogImageURLStrings {
                    guard let dogImageURL = URL(string: dogImageURLString) else { return }
                    guard let dogImageData = try? Data(contentsOf: dogImageURL) else { return }
                    guard let dogImage = UIImage(data: dogImageData) else { return }
                    dogImages.append(dogImage)
                }
                DispatchQueue.main.async {
                    complition(dogImages)
                }
            }
        
        }
        
    }
    
    
}
