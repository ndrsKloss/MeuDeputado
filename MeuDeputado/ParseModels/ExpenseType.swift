import Parse

final public class ExpenseType:
  PFObject,
  PFSubclassing
{

  @NSManaged internal var detail: String
  @NSManaged internal var name: String
  @NSManaged internal var code: NSNumber

  public static func parseClassName() -> String {
    "ExpenseType"
  }

  override init() {
    super.init()
  }

  init(
    detail: String,
    name: String,
    code: NSNumber
  ) {
    super.init()
    self.detail = detail
    self.name = name
    self.code = code
  }
}
