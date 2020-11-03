struct MainContent {
	let id: String?
	let title: String
	let information: String
	let imageId: String?
	
	init(
		id: String?,
		title: String,
		information: String,
		imageId: String? = nil
	) {
		self.id = id
		self.title = title
		self.information = information
		self.imageId = imageId
	}
}
