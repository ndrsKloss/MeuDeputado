import Parse

final public class ExpenseType:
	PFObject,
	PFSubclassing {
	
	@NSManaged internal var detail: String
	@NSManaged internal var name: String
	
	public static func parseClassName() -> String {
		"ExpenseType"
	}
	
	override init() {
		super.init()
	}
	
	init(
		detail: String,
		name: String
	) {
		super.init()
		self.detail = detail
		self.name = name
	}
}
