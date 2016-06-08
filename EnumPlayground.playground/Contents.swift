import UIKit

// you can use Integer, Floating Point, String, Boolean (also protocols
enum LoanStatus: String {
    case None, Offer, Accepted
    
    //enums are sets and unordered so this is a trick to get an array that you can enumerate
    static var allValues = [None, Offer, Accepted]
}

func ==(lhs: ViewModel.Section.Item, rhs: ViewModel.Section.Item) -> Bool {
    switch (lhs, rhs) {
    case let (.AccountBalance(balance1, showBalance1), .AccountBalance(balance2, showBalance2))
        where balance1 == balance2 && showBalance1 == showBalance2:
        return true
    case (.SmartAccountBalance, .SmartAccountBalance),
         (.LoanOffer, .LoanOffer),
         (.LoanBalance, .LoanBalance),
         (.AccountClosed, .AccountClosed),
         (.AccountUpdate, .AccountUpdate):
        return true
    default: return false
    }
}

class ViewModel {
    //This was made so I could test out the idea of using enums to
    // represent the section to item structure we were using in HomeViewModel
    //Enums are good for doing heirachical structures apparently
    
    enum Section {
        enum Item:Equatable {
            case AccountBalance(balance:String?, showBalance:Bool)
            case SmartAccountBalance
            case LoanOffer
            case LoanBalance
            case AccountClosed
            case AccountUpdate
            
            func printItem() {
                switch self {
                    //you can use pattern matching to print associated values
                case let AccountBalance(balance, showBalance):
                    print("AccountBalance \(balance) \(showBalance)\n")
                default:
                    print("\(self)\n")
                    
                }
            }
        }
        case Account([Item])
        case SmartAccount([Item])
        case CardSection([Item])
        case Footer([Item])
        
        func printCells() {
            switch self {
            case let .Account(items):
                for item in items {item.printItem()}
            case let .SmartAccount(items):
                print("  \(items)")
                for item in items {item.printItem()}
            case let .CardSection(items):
                for item in items {item.printItem()}
            case let .Footer(items):
                for item in items {item.printItem()}
            }

        }
        
        //Switches in functions to return different output
        func cellIdentifier() -> String {
            switch self {
            case .Account: return "AccountCellId"
            case .SmartAccount: return "SmartAccountCellId"
            case .CardSection: return "CardCellId"
            case .Footer: return "FooterCellId"
            }
        }
        
        static var allValues = [Account([]), SmartAccount([]), CardSection([]), Footer([])]
    }
    var active: Bool
    var loanStatus: LoanStatus
    
    var sections = [Section]()
    init(active:Bool, loanStatus: LoanStatus) {
        self.active = active
        self.loanStatus = loanStatus
        
        if active {
            sections.append(.Account([.AccountBalance(balance:"100",showBalance:true)]))
            sections.append(.SmartAccount([.SmartAccountBalance]))
            switch loanStatus {
                case .Offer:
                    sections.append(.CardSection([.LoanOffer]))
                case .Accepted:
                    sections.append(.CardSection([.LoanBalance]))
                default:
                    sections.append(.CardSection([]))
            }
            sections.append(.Footer([.AccountUpdate]))
        } else {
            sections.append(.Account([.AccountBalance(balance:"",showBalance:false)]))
            sections.append(.SmartAccount([]))
            sections.append(.CardSection([]))
            sections.append(.Footer([.AccountClosed]))
        }
    }
    
    func printSections() {
        print("Printing sections for account with status: \(active) and loanStatus: \(loanStatus)")
        print("***************************************************")
        for section in self.sections {
            print("\(section) : \(section.cellIdentifier())")
            section.printCells()
        }
        print("***************************************************\n\n")
        
    }
}

//Adding an allValues array allows iteration if you need it
for status in LoanStatus.allValues {
    print(status)
}
for status in ViewModel.Section.allValues {
    print(status)
}
for (index, status) in LoanStatus.allValues.enumerate() {
    print("\(index) \(status)")
}

//Comparison

//You can do this Because they are String types
print(LoanStatus.Accepted == LoanStatus.Offer)
print(LoanStatus.Accepted == LoanStatus.Accepted)

//You can't do this because they are not equatable
let first = ViewModel.Section.CardSection([.LoanOffer])
let second = ViewModel.Section.CardSection([.LoanBalance])
//print(first == second)

//These work because I implemented equatable
let item1 = ViewModel.Section.Item.AccountBalance(balance: "100", showBalance: false)
let item2 = ViewModel.Section.Item.AccountBalance(balance: nil, showBalance: false)
print(ViewModel.Section.Item.AccountClosed == ViewModel.Section.Item.AccountUpdate)
print(ViewModel.Section.Item.AccountClosed == ViewModel.Section.Item.AccountClosed)
print(item1 == item2)



ViewModel(active: true, loanStatus: .Accepted).printSections()
//ViewModel(active: true, loanStatus: .None).printSections()
//ViewModel(active: true, loanStatus: .Offer).printSections()
//ViewModel(active: false, loanStatus: .Accepted).printSections()
