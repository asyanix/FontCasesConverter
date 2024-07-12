// Задача 2

import Foundation

struct FontCases
{
    let input: String

    init(input: String)
    {
        self.input = input
    }
    
    enum TypesFontCases: String
    {
        case camelCase = "camelCase"
        case pascalCase = "PascalCase"
        case snakeCase = "snake_case"
        case kebabCase = "kebab-case"
        case screamingSnakeCase = "SCREAMING_SNAKE_CASE"
        case trainCase = "Train-Case"
        case dotCase = "dot.case"
        case pathCase = "path/case"
    }

    typealias Properties = (isSeparator: Character?, isUpperCase: Bool, isLowerCase: Bool?, isBothCase: Bool, isFirstLetterCapitalized: Bool?, isLetterSeparatorCapitalized: Bool)
    
    private let fontCasesProperties: [TypesFontCases: Properties] =
    [
      .screamingSnakeCase: (isSeparator: "_", isUpperCase: true, isLowerCase: false, isBothCase: false, isFirstLetterCapitalized: true, isLetterSeparatorCapitalized: true),
      .camelCase: (isSeparator: nil, isUpperCase: false, isLowerCase: false, isBothCase: false, isFirstLetterCapitalized: false, isLetterSeparatorCapitalized: false),
      .pascalCase: (isSeparator: nil, isUpperCase: false, isLowerCase: false, isBothCase: false, isFirstLetterCapitalized: true, isLetterSeparatorCapitalized: false),
      .snakeCase: (isSeparator: "_", isUpperCase: false, isLowerCase: nil, isBothCase: true, isFirstLetterCapitalized: nil, isLetterSeparatorCapitalized: false),
      .kebabCase: (isSeparator: "-", isUpperCase: false, isLowerCase: true, isBothCase: false, isFirstLetterCapitalized: false, isLetterSeparatorCapitalized: false),
      .dotCase: (isSeparator: ".", isUpperCase: false, isLowerCase: true, isBothCase: false, isFirstLetterCapitalized: false, isLetterSeparatorCapitalized: false),
      .pathCase: (isSeparator: "/", isUpperCase: false, isLowerCase: true, isBothCase: false, isFirstLetterCapitalized: false, isLetterSeparatorCapitalized: false),
      .trainCase: (isSeparator: "-", isUpperCase: false, isLowerCase: false, isBothCase: false, isFirstLetterCapitalized: true, isLetterSeparatorCapitalized: true)
    ] // Характеристика каждого case
      
    private func identifyProperties(_ input: String) throws -> Properties
    {
        guard !input.isEmpty && !input.contains(" ") && input.last!.isLetter else
        {
            throw FontCasesError.unknownCaseType
        }
        
        do
        {
            let separatorInput = try findSeparator(in: input)
            let isUpperCaseInput = input.uppercased() == input
            var isLowerCaseInput: Bool? = input.lowercased() == input
            let isBothCaseInput = separatorInput == "_" && isUpperCaseInput == false
            var isFirstLetterCapitalized: Bool? = input.first!.isUppercase
            let isLetterSeparatorCapitalized = letterSeparator(separatorInput, input) // для train-case
            if isBothCaseInput {isLowerCaseInput = nil; isFirstLetterCapitalized = nil} // для snake-case
            return (isSeparator: separatorInput, isUpperCase: isUpperCaseInput, isLowerCase: isLowerCaseInput, isBothCase: isBothCaseInput, isFirstLetterCapitalized: isFirstLetterCapitalized, isLetterSeparatorCapitalized: isLetterSeparatorCapitalized)
        }
    } // Определяем для входной строки свойства

    private func letterSeparator(_ separator: Character?, _ input: String) -> Bool
    {
        guard separator != nil else
        {
            return false
        }
        for (ind, char) in input.enumerated()
        {
            if char == separator
            {
                let nextCharacterIndex = input.index(input.startIndex, offsetBy: ind + 1)
                guard input[nextCharacterIndex].isUppercase else
                {
                    return false
                }
            }
        }
        return true
    } // Все ли буквы после разделителей заглавные
    
    private func findSeparator(in input: String) throws -> Character? {
        var separatorCharacters = Set<Character>()
        for (ind, char) in input.enumerated()
        {
            if !char.isLetter
            {
                guard ind != 0 else
                {
                    throw FontCasesError.unknownCaseType
                }
                separatorCharacters.insert(char)
                if separatorCharacters.count > 1
                {
                    throw FontCasesError.unknownCaseType
                }
                let previousIndex = input.index(input.startIndex, offsetBy: ind - 1)
                guard input[previousIndex].isLetter else
                {
                    throw FontCasesError.unknownCaseType
                }
            }
        }
        return separatorCharacters.first
    } // Находим разделитель для строки, он должен быть 1 для целой строки

    func defineType() throws -> TypesFontCases {
        let inputProperties = try identifyProperties(input)
        
        for (caseType, caseProperties) in fontCasesProperties {
            if caseProperties == inputProperties {
                return caseType
            }
        }
        throw FontCasesError.unknownCaseType
    } // Определяем тип case
    
    private func parseString() throws -> [String]
    {
        let typeCase = try defineType()
        var pattern = ""
        switch typeCase 
        {
        case .camelCase, .pascalCase: pattern = "([a-z])([A-Z])"
        case .snakeCase, .screamingSnakeCase: pattern = "\\_"
        case .kebabCase, .trainCase: pattern = "\\-"
        case .dotCase: pattern = "\\."
        case .pathCase: pattern = "\\/"
        }
        
        let modifiedString = input.replacingOccurrences(of: pattern, with: "$1 $2", options: .regularExpression)
        let words = modifiedString.split(separator: " ").map { String($0).lowercased() }
        return words
    } // Разбиваем строку на части
    
    func convertCaseString(_ inputCase: String) throws -> String
    {
        let parseInputString = try parseString()
        var resultString = ""
        switch inputCase
        {
        case TypesFontCases.camelCase.rawValue:
            var capitalizedParseString = parseInputString.map{ $0.capitalized }
            capitalizedParseString[0] = capitalizedParseString[0].lowercased()
            resultString = capitalizedParseString.joined()
        case TypesFontCases.pascalCase.rawValue:
            let capitalizedParseString = parseInputString.map{ $0.capitalized }
            resultString = capitalizedParseString.joined()
        case TypesFontCases.snakeCase.rawValue:
            resultString = parseInputString.joined(separator: "_")
        case TypesFontCases.kebabCase.rawValue:
            resultString = parseInputString.joined(separator: "-")
        case TypesFontCases.screamingSnakeCase.rawValue:
            let capitalizedParseString = parseInputString.map{ $0.uppercased() }
            resultString = capitalizedParseString.joined(separator: "_")
        case TypesFontCases.trainCase.rawValue:
            let capitalizedParseString = parseInputString.map{ $0.capitalized }
            resultString = capitalizedParseString.joined(separator: "-")
        case TypesFontCases.dotCase.rawValue:
            resultString = parseInputString.joined(separator: ".")
        case TypesFontCases.pathCase.rawValue:
            resultString = parseInputString.joined(separator: "/")
        default:
            throw FontCasesError.invalidUserCase
        }
        
        return resultString
    } // Конвертируем из одного case в другой
}

enum FontCasesError: Error 
{
    case unknownCaseType
    case invalidUserCase
}

let inputString = "incetro/internship/example"
let inputCase = "Train-Case"

do 
{
    let fontCase = FontCases(input: inputString)
    let result = try fontCase.convertCaseString(inputCase)
    print("From \"\(inputString)\" to \"\(result)\" with case: \(inputCase)")
}
catch FontCasesError.invalidUserCase
{
    print("Error: The entered case is invalid. Please check your input and try again.")
}
catch FontCasesError.unknownCaseType
{
    print("Error: Сase type could not be determined.")
}
