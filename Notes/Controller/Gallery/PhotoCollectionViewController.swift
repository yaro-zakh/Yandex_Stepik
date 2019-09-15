//
//  PhotoCollectionViewController.swift
//  Notes
//
//  Created by Yaroslav Zakharchuk on 7/21/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

class PhotoCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [UIImageView]()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        initImage()
        setupCollectionLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    fileprivate func initImage() {
        let imageName = ["photo1", "photo2", "photo3", "photo4", "photo5"]
        for item in imageName {
            let image = UIImage(named: item)
            let imageView = UIImageView(image: image)
            images.append(imageView)
        }
    }
    
    fileprivate func setupCollectionLayout() {
        let itemSize = UIScreen.main.bounds.width / 3 - 3
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        collectionView.collectionViewLayout = layout
    }
    
    @IBAction func addFrotoFromGallery(_ sender: UIBarButtonItem) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}

extension PhotoCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.image = images[indexPath.item].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FullViewPhotoViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? FullViewPhotoViewController, segue.identifier == "FullViewPhotoViewController",
            let selectedCellPaths = collectionView.indexPathsForSelectedItems,
            let cellIndex = selectedCellPaths.first {
            controller.images = images
            controller.selectedIndex = cellIndex.item
        }
    }
}

extension PhotoCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            images.append(UIImageView(image: pickedImage))
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
