import Combine
import UIKit
import SDWebImage

class PokemonDetailViewController: UIViewController {
    private enum Constants {
        static let cellReusableIdentifier = "detailCell"
    }
    
    @IBOutlet weak var pokemonDetailImage: UIImageView!
    @IBOutlet weak var pokemonDetailName: UILabel!
    @IBOutlet weak var pokemonDetailList: UITableView!
    @IBOutlet weak var goBackButton: UIButton!
    
    private var viewModel = PokemonDetailViewModel()
    private var bag = Set<AnyCancellable>()
    
    var selectedPokemon: Pokemon? {
        didSet {
            viewModel.selectedPokemon = selectedPokemon
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonDetailList.delegate = self
        pokemonDetailList.dataSource = self
        
        pokemonDetailName.text = viewModel.getPokemonName()
        
        if let imageUrl = viewModel.getPokemonImageUrl() {
            pokemonDetailImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        }
        
        getData()
        addBinders()
    }
    
    private func addBinders() {
        viewModel.$errorMessage.sink { [weak self] message in
            guard let message = message else {
                return
            }
            
            DispatchQueue.main.async {
                self?.showErrorAlert(message: message)
            }
        }.store(in: &bag)
        
        viewModel.$abilityDetails.sink { [weak self] details in
            DispatchQueue.main.async {
                self?.pokemonDetailList.reloadData()
            }
        }.store(in: &bag)
    }
    
    @IBAction func goToMain(_ sender: Any) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func getData() {
        viewModel.getAbilityDetails { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.pokemonDetailList.reloadData()
                }
            case .failure:
                break
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension PokemonDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.abilityDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReusableIdentifier, for: indexPath) as! DetailCell
        cell.configure(abilityDetails: viewModel.abilityDetails[indexPath.row])
        return cell
    }
}
