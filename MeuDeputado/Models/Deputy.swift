import Parse

final class Deputy:
  PFObject,
PFSubclassing {
  
  @NSManaged internal var deputyId:   NSNumber
  @NSManaged internal var name:       String
  @NSManaged internal var realName:   String
  @NSManaged internal var email:      String
  @NSManaged internal var party:      String
  @NSManaged internal var uf:         String
  @NSManaged internal var ownership:  NSNumber?
  
  static func parseClassName() -> String {
    "Deputy"
  }
  
  override init() {
    super.init()
  }

}
