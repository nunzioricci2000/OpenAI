import Foundation

@available(macOS 13.0, *)
public struct OpenAI {
    static let API_URL = URL(string: "https://api.openai.com/")!
    private let token: String
    
    public init(token: String) {
        self.token = token
    }
    
    func perform<Request: AIRequest>(_ request: Request) async throws -> Request.Response {
        var urlRequest = URLRequest(url: Self.API_URL.appending(path: Request.path))
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \( token )", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = Request.method
        urlRequest.httpBody = try JSONEncoder().encode(request)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let response: Request.Response
        do {
            response = try JSONDecoder().decode(Request.Response.self, from: data)
        } catch {
            throw OpenAIError(data)
        }
        return response
    }
}

struct OpenAIError: Error, Decodable {
    let error: Error
    
    var description: String {
        return error.message
    }
    
    init(_ data: Data) {
        do {
            self = try JSONDecoder().decode(Self.self, from: data)
        } catch {
            fatalError("Data retrived from the server: \n \(String(data: data, encoding: .utf8)!)")
        }
    }
    
    struct Error: Decodable {
        let message: String
        let type: String
    }
}

