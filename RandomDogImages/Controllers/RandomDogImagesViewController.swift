//
//  RandomDogImagesViewController.swift
//  RandomDogImages
//
//  Created by ALEKSEY SUSLOV on 19.08.2022.
//

import UIKit

class RandomDogImagesViewController: UIViewController {
    
    @IBOutlet var dogCollectionView: UICollectionView!
    
    private var acivityIndicator = UIActivityIndicatorView()
    
    var dogImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogCollectionView.dataSource = self
        dogCollectionView.delegate = self
        
        refreshButtonPressed()
        setUpActivityIndicator()
    }
    
    @IBAction func refreshButtonPressed() {
        acivityIndicator.startAnimating()
        
        NetworkManager.shared.fetchImages { dogImages in
            DispatchQueue.main.async {
                self.dogImages = dogImages
                self.dogCollectionView.reloadData()
                
                if self.acivityIndicator.isAnimating {
                    self.acivityIndicator.stopAnimating()
                }
            }
        }
    }
    
    private func setUpActivityIndicator() {
        acivityIndicator.style = .medium
        acivityIndicator.hidesWhenStopped = true

        let acivityIndicatorBarItem = UIBarButtonItem(customView: acivityIndicator)
        navigationItem.setRightBarButton(acivityIndicatorBarItem, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension RandomDogImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dogCollectionView.dequeueReusableCell(withReuseIdentifier: "DogImageCell", for: indexPath) as! DogImageCollectionViewCell
        
        cell.dogImage.image = dogImages[indexPath.item]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RandomDogImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 48
        let dogImage = dogImages[indexPath.item]
        let height = (width * dogImage.size.height) / dogImage.size.width

        return CGSize(width: width, height: height)
    }
}
