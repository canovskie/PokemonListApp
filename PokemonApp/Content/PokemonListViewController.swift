import UIKit

class PokemonListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = PokemonListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
    }
    
    private func fetchData() {
        viewModel.fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorAlert(message: error.localizedDescription)
                }
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

extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPokemons
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as! PokemonListCell
        let pokemon = viewModel.getPokemon(at: indexPath.row)
        cell.configure(with: pokemon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPokemonDetail", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPokemonDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let pokemonDetailViewController = segue.destination as? PokemonDetailViewController {
                    let pokemon = viewModel.getPokemon(at: indexPath.row)
                    pokemonDetailViewController.selectedPokemon = pokemon
                }
            }
        }
    }
}
