import UIKit

class DayTableViewCell: TableViewCell {
    
    let resultLabel: DayTableViewCellLabel
    let scoreLabel: DayTableViewCellLabel
    
    let stackView: StackView
    
    init() {
        resultLabel = DayTableViewCellLabel()
        scoreLabel = DayTableViewCellLabel()
        
        stackView = StackView(arrangedSubviews: [resultLabel,scoreLabel], axis: .vertical, spacing: 5, distribution: .fillEqually)
        
        super.init(style: .default, reuseIdentifier: "cell")
        
        contentView.addSubview(stackView)
        setupConstraints()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        resultLabel = DayTableViewCellLabel()
        scoreLabel = DayTableViewCellLabel()
        
        stackView = StackView(arrangedSubviews: [resultLabel,scoreLabel], axis: .vertical, spacing: 5, distribution: .fillEqually)
        
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(stackView)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor))
        constraints.append(stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor))
        constraints.append(stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension DayTableViewCell: ConfigurableCell {
    func configure(for object: GameResult) {
        resultLabel.text = Lets.resultString(for: object)
        scoreLabel.text = Lets.scoreString(for: object)
    }
}
