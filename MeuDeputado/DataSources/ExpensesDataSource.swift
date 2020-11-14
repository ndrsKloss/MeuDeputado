import RxDataSources

func expensesDataSource() -> RxTableViewSectionedReloadDataSource<ExpensesSectionModel>{
    RxTableViewSectionedReloadDataSource<ExpensesSectionModel>(configureCell: configureCell)
}

private func configureCell(
    dataSource: TableViewSectionedDataSource<ExpensesSectionModel>,
    tableView: UITableView,
    indexPath: IndexPath,
    item: ExpensesSectionModel.Item
) -> UITableViewCell {
    switch dataSource[indexPath] {
        
        case .total(let viewModel):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TotalExpensesTableViewCell.self),
                for: indexPath
            )
            
            if let cell = cell as? TotalExpensesTableViewCell {
                cell.configure(withViewModel: viewModel)
                return cell
            }
            return cell
        
        case .type(viewModel: let viewModel):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TypeExpensesTableViewCell.self),
                for: indexPath
            )
            
            if let cell = cell as? TypeExpensesTableViewCell {
                cell.configure(withViewModel: viewModel)
                return cell
            }
            return cell
    }
}
