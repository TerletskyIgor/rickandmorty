//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//
import UIKit

protocol CharacterDetailDisplayLogic: AnyObject {
    func displayCharacter(character: Character)
}

class CharacterDetailViewController: UIViewController {
    var interactor: CharacterDetailBusinessLogic?
    
    private let nameLabel = CharacterDetailViewController.makeLabel(fontSize: 22, weight: .bold)
    private let speciesLabel = CharacterDetailViewController.makeLabel(fontSize: 18, weight: .regular)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statusIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 12).isActive = true
        view.heightAnchor.constraint(equalToConstant: 12).isActive = true
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = CharacterDetailViewController.makeLabel(fontSize: 18, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var statusStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [statusIndicator, statusLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, statusStack, speciesLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private static func makeLabel(fontSize: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: fontSize, weight: weight)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupLayout()
        interactor?.loadCharacter()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(infoStack)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: Constants.topPadding),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageWidth),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),

            infoStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.topPadding),
            infoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leftPadding),
            infoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.rightPadding),
            infoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.bottomPadding)
        ])
    }
    
    private func configure(character: Character) {
        nameLabel.text = character.name
        speciesLabel.text = "Species: \(character.species)"
        statusLabel.text = character.status.rawValue
        
        switch character.status {
        case .alive:
            statusIndicator.backgroundColor = .systemGreen
        case .dead:
            statusIndicator.backgroundColor = .systemRed
        case .unknown:
            statusIndicator.backgroundColor = .systemGray
        }
        
        if let url = URL(string: character.imageURL) {
            imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        }
    }
    
    private struct Constants {
        static let imageWidth: CGFloat = 200
        static let imageHeight: CGFloat = 200
        
        static let topPadding: CGFloat = 8
        static let leftPadding: CGFloat = 8
        static let rightPadding: CGFloat = 8
        static let bottomPadding: CGFloat = 8
    }
}

// MARK: - CharacterDetailDisplayLogic
extension CharacterDetailViewController: CharacterDetailDisplayLogic {
    func displayCharacter(character: Character) {
        configure(character: character)
    }
}
