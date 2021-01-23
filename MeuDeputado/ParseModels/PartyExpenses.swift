import Parse

final public class PartyExpense:
  PFObject,
  PFSubclassing
{

  @NSManaged internal var month: NSNumber
  @NSManaged internal var year: NSNumber
  @NSManaged internal var value: NSNumber
  @NSManaged internal var party: Party
  @NSManaged internal var expenseType: ExpenseType

  public static func parseClassName() -> String {
    "PartyExpense"
  }

  override init() {
    super.init()
  }

  init(
    month: NSNumber,
    year: NSNumber,
    value: NSNumber,
    party: Party,
    expenseType: ExpenseType
  ) {
    super.init()
    self.month = month
    self.year = year
    self.value = value
    self.party = party
    self.expenseType = expenseType
  }

}
