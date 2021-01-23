import Parse

let getAllDeputiesInMandateQuery: PFQuery<PFObject>? = {
  // Always 500~600 deputies
  $0?.limit = 600
  $0?.addAscendingOrder(NSExpression(forKeyPath: \Deputy.name).keyPath)
  // Last valid update: 1603983600
  $0?.whereKey(
    NSExpression(forKeyPath: \Deputy.updatedAt).keyPath,
    greaterThan: Date(timeIntervalSince1970: 1_603_983_600))
  return $0
}(Deputy.query())

let getAllParties: PFQuery<PFObject>? = {
  $0?.addDescendingOrder(NSExpression(forKeyPath: \Party.deputyCount).keyPath)
  $0?.whereKey(NSExpression(forKeyPath: \Party.deputyCount).keyPath, greaterThan: 0)
  return $0
}(Party.query())

func getDeputyExpenses(
  year: NSNumber,
  objectId id: String?
) -> PFQuery<PFObject>? {
  let query = DeputyExpense.query()
  let deputy = PFObject(withoutDataWithClassName: Deputy.parseClassName(), objectId: id)
  query?.includeKey(NSExpression(forKeyPath: \DeputyExpense.type).keyPath)
  //18 (+ 1 for safety) expense types * 12 months
  query?.limit = 228
  query?.whereKey(NSExpression(forKeyPath: \DeputyExpense.deputy).keyPath, equalTo: deputy)
  query?.whereKey(NSExpression(forKeyPath: \DeputyExpense.year).keyPath, equalTo: year)
  return query
}

func getPartyExpenses(
  year: NSNumber,
  objectId id: String?
) -> PFQuery<PFObject>? {
  let query = PartyExpense.query()
  let party = PFObject(withoutDataWithClassName: Party.parseClassName(), objectId: id)
  query?.includeKey(NSExpression(forKeyPath: \PartyExpense.expenseType).keyPath)
  //18 (+ 1 for safety) expense types * 12 months
  query?.limit = 228
  query?.whereKey(NSExpression(forKeyPath: \PartyExpense.party).keyPath, equalTo: party)
  query?.whereKey(NSExpression(forKeyPath: \PartyExpense.year).keyPath, equalTo: year)
  return query
}
