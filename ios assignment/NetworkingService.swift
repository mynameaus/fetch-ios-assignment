import Foundation

struct API {
    static let baseURL = "https://www.themealdb.com/api/json/v1/1/"
    static let desserts = baseURL + "filter.php?c=Dessert"
    static let mealDetails = baseURL + "lookup.php?i="
}

struct Meal: Decodable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String?
}

struct MealResponse: Decodable {
    let meals: [Meal]
}

struct MealDetailResponse: Decodable {
    let meals: [MealDetail]
}

class NetworkingService {
    static let shared = NetworkingService()
    
    private init() {}
    
    func fetchDesserts() async throws -> [Meal] {
        guard let url = URL(string: API.desserts) else {
            throw URLError(.badURL)
        }
        
        let (data, urlResponse) = try await URLSession.shared.data(from: url)
        guard let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let mealResponse = try JSONDecoder().decode(MealResponse.self, from: data)
        return mealResponse.meals
    }
    
    func fetchMealDetails(mealID: String) async throws -> MealDetail {
        let urlString = API.mealDetails + mealID
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, urlResponse) = try await URLSession.shared.data(from: url)
        guard let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let mealDetailResponse = try JSONDecoder().decode(MealDetailResponse.self, from: data)
        guard let mealDetail = mealDetailResponse.meals.first else {
            throw URLError(.dataNotAllowed)
        }
        return mealDetail
    }
}
