import Parse

let getAllDeputiesInMandateQuery: PFQuery<PFObject>? = {
	// Always 500~600 deputies
	$0?.limit = 600
	$0?.addAscendingOrder(NSExpression(forKeyPath: \Deputy.name).keyPath)
	// Last valid update: 1603983600
	$0?.whereKey(NSExpression(forKeyPath: \Deputy.updatedAt).keyPath, greaterThan: Date(timeIntervalSince1970: 1603983600))
	return $0
}(Deputy.query())

let getAllParties: PFQuery<PFObject>? = {
	$0?.addDescendingOrder(NSExpression(forKeyPath: \Party.deputyCount).keyPath)
	$0?.whereKey(NSExpression(forKeyPath: \Party.deputyCount).keyPath, greaterThan: 0)
	return $0
}(Party.query())

/*func getPartyExpenses(
	year: NSNumber,
	party: Party
) -> PFQuery<PFObject>? {
	
	let query = PFQuery(className: "PartyExpense")
	query.limit = 500
	//let query = PartyExpenses.query()
	query.whereKey(NSExpression(forKeyPath: \PartyExpenses.party).keyPath, equalTo: party)
	query.whereKey(NSExpression(forKeyPath: \PartyExpenses.year).keyPath, equalTo: year)
	return query
}*/

/*
getPartyExpenses(year: 2020, party: PFObject(withoutDataWithClassName: "Party", objectId: "RCfsinpuW0") as! Party)?
	.findObjectsInBackground(block: { (expenses, error) in
		print(error)
		print(expenses)
})
*/
