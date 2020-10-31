import Parse

final public class Deputy:
	PFObject,
	PFSubclassing {
	
	@NSManaged internal var deputyId: NSNumber
	@NSManaged internal var name: String
	@NSManaged internal var realName: String
	@NSManaged internal var email: String
	@NSManaged internal var party: String
	@NSManaged internal var uf: String
	@NSManaged internal var ownership: NSNumber
	
	public static func parseClassName() -> String {
		"Deputy"
	}
	
	override init() {
		super.init()
	}
	
	init(
		deputyId: NSNumber,
		name: String,
		realName: String,
		email: String,
		party: String,
		uf: String,
		ownership: NSNumber
	) {
		super.init()
		self.deputyId = deputyId
		self.name = name
		self.realName = realName
		self.email = email
		self.party = party
		self.uf = uf
		self.ownership = ownership
	}
	
}
