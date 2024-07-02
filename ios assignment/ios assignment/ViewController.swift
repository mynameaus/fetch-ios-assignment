import UIKit

class ViewController: UIViewController {
    private var meals: [Meal] = []
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Desserts"
        setupTableView()
        fetchMeals()
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    private func fetchMeals() {
        Task {
            do {
                meals = try await NetworkingService.shared.fetchDesserts()
                meals.sort { $0.strMeal < $1.strMeal }
                tableView.reloadData()
            } catch {
                showError(error)
            }
        }
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "MealCell")
        let meal = meals[indexPath.row]
        cell.textLabel?.text = meal.strMeal
        if let thumb = meal.strMealThumb, let url = URL(string: thumb) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: data)
                        cell.setNeedsLayout()
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mealID = meals[indexPath.row].idMeal
        let detailVC = DetailViewController(mealID: mealID)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
