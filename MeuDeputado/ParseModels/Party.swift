import Parse

final public class Party:
  PFObject,
  PFSubclassing
{

  @NSManaged internal var name: String
  @NSManaged internal var deputyCount: Int

  public static func parseClassName() -> String {
    "Party"
  }

  override init() {
    super.init()
  }

  init(
    name: String,
    deputyCount: Int
  ) {
    super.init()
    self.name = name
    self.deputyCount = deputyCount
  }

}
