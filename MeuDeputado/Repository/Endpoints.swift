import Foundation

enum Endpoint {
	var imageURL: URL? {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "meudeputados3-dev.s3.amazonaws.com"
		components.path = "/public"
		return components.url
	}
	
	case image(id: String)
	// https://meudeputados3-dev.s3.amazonaws.com/public/213762.jpg
	func makeURL() -> URL? {
		switch self {
			case .image(let id):
				return imageURL?.appendingPathComponent(id).appendingPathExtension("jpg")
		}
	}
}
