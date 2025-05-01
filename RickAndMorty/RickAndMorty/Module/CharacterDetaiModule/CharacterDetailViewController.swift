//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//
import UIKit

protocol CharacterDetailDisplayLogic: AnyObject {
    func displayCharacter(viewModel: CharacterDetail.ViewModel)
}

class CharacterDetailViewController: UIViewController, CharacterDetailDisplayLogic {
    
    var interactor: CharacterDetailBusinessLogic?
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        interactor?.loadCharacter(request: .init())
    }

    private func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center

        view.addSubview(imageView)
        view.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    func displayCharacter(viewModel: CharacterDetail.ViewModel) {
        nameLabel.text = viewModel.name
        if let url = URL(string: viewModel.imageURL) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
