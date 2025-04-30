//
//  CartoonCharacters.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import UIKit

protocol CartoonCharactersDisplayLogic: AnyObject {
    func displayCharacters(viewModel: CartoonCharacters.Fetch.ViewModel)
}

final class CartoonCharactersViewController: UIViewController {
    private let paginator = Paginator()
    
    var interactor: CartoonCharactersBusinessLogic?
    var router: CartoonCharactersRoutingLogic?

    private let tableView = UITableView()
    private var characters: [CartoonCharacters.Fetch.ViewModel.DisplayCharacter] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupUI()
        fetchCharacters()
    }

    private func setup() {
        let viewController = self
        let interactor = CartoonCharactersInteractor()
        let presenter = CartoonCharactersPresenter()
        let router = CartoonCharactersRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        
        router.viewController = viewController
    }

    private func setupUI() {
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

    private func fetchCharacters() {
        interactor?.fetchCharacters(request: CartoonCharacters.Fetch.Request())
    }
}

// MARK: - CartoonCharactersDisplayLogic
extension CartoonCharactersViewController: CartoonCharactersDisplayLogic {
    func displayCharacters(viewModel: CartoonCharacters.Fetch.ViewModel) {
        characters += viewModel.characters
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension CartoonCharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let character = characters[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = character.name
        
        if let url = character.imageURL {
            // MARK: Only for test
            // TODO: - ADd Kingfisher
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imageView?.image = image
                        cell.setNeedsLayout()
                    }
                }
            }
        }
        
        return cell
    }
}

extension CartoonCharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        paginator.loadIfNeeded(currentIndex: indexPath.row,
                               totalCount: characters.count) { [weak self] page, done in
            self?.interactor?.loadCharacters(page: page, completion: { hasMore in
                done(hasMore)
            })
        }
    }
}
