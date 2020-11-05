struct MainContent {
	enum Kind {
		case deputy, party
	}
	
	let id: String?
	let title: String
	let information: String
	let model: Kind
	let imageId: String?
	
	init(
		id: String?,
		title: String,
		information: String,
		represents model: Kind,
		imageId: String? = nil
	) {
		self.id = id
		self.title = title
		self.information = information
		self.model = model
		self.imageId = imageId
	}
}
