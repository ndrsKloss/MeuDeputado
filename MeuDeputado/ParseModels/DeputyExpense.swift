import Parse

final public class DeputyExpense:
	PFObject,
	PFSubclassing {
	
	@NSManaged internal var month: NSNumber
	@NSManaged internal var year: NSNumber
	@NSManaged internal var value: NSNumber
	@NSManaged internal var deputy: Deputy
	@NSManaged internal var expenseType: ExpenseType
	
	public static func parseClassName() -> String {
		"DeputyExpense"
	}
	
	override init() {
		super.init()
	}
	
	init(
		month: NSNumber,
		year: NSNumber,
		value: NSNumber,
		deputy: Deputy,
		expenseType: ExpenseType
	) {
		super.init()
		self.month = month
		self.year = year
		self.value = value
		self.deputy = deputy
		self.expenseType = expenseType
	}
	
}
