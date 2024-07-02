import UIKit

class DetailViewController: UIViewController {
    private var mealID: String
    private var mealDetail: MealDetail?
    private var textView: UITextView!

    init(mealID: String) {
        self.mealID = mealID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Meal Details"
        setupTextView()
        fetchMealDetails()
    }

    private func setupTextView() {
        textView = UITextView(frame: view.bounds)
        textView.isEditable = false
        view.addSubview(textView)
    }

    private func fetchMealDetails() {
        Task {
            do {
                mealDetail = try await NetworkingService.shared.fetchMealDetails(mealID: mealID)
                updateUI()
            } catch {
                showError(error)
            }
        }
    }

    private func updateUI() {
        guard let mealDetail = mealDetail else { return }
        
        var ingredients: [String] = []
        let ingredientProperties = [
            mealDetail.strIngredient1, mealDetail.strIngredient2, mealDetail.strIngredient3, mealDetail.strIngredient4,
            mealDetail.strIngredient5, mealDetail.strIngredient6, mealDetail.strIngredient7, mealDetail.strIngredient8,
            mealDetail.strIngredient9, mealDetail.strIngredient10, mealDetail.strIngredient11, mealDetail.strIngredient12,
            mealDetail.strIngredient13, mealDetail.strIngredient14, mealDetail.strIngredient15, mealDetail.strIngredient16,
            mealDetail.strIngredient17, mealDetail.strIngredient18, mealDetail.strIngredient19, mealDetail.strIngredient20
        ]
        
        let measureProperties = [
            mealDetail.strMeasure1, mealDetail.strMeasure2, mealDetail.strMeasure3, mealDetail.strMeasure4,
            mealDetail.strMeasure5, mealDetail.strMeasure6, mealDetail.strMeasure7, mealDetail.strMeasure8,
            mealDetail.strMeasure9, mealDetail.strMeasure10, mealDetail.strMeasure11, mealDetail.strMeasure12,
            mealDetail.strMeasure13, mealDetail.strMeasure14, mealDetail.strMeasure15, mealDetail.strMeasure16,
            mealDetail.strMeasure17, mealDetail.strMeasure18, mealDetail.strMeasure19, mealDetail.strMeasure20
        ]
        
        for (ingredient, measure) in zip(ingredientProperties, measureProperties) {
            if let ingredient = ingredient, !ingredient.isEmpty,
               let measure = measure, !measure.isEmpty {
                ingredients.append("\(measure) \(ingredient)")
            }
        }
        
        textView.text = """
        \(mealDetail.strMeal)
        
        \(mealDetail.strInstructions)
        
        Ingredients:
        \(ingredients.joined(separator: "\n"))
        """
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
