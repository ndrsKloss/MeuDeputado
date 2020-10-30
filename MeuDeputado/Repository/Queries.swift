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
	$0?.addAscendingOrder(NSExpression(forKeyPath: \Party.deputyCount).keyPath)
	$0?.whereKey(NSExpression(forKeyPath: \Party.deputyCount).keyPath, greaterThan: 0)
	return $0
}(Party.query())
