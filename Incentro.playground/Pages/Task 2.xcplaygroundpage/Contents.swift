// Задача 2

import RegexBuilder
import Foundation

enum TypesFontCases: String
{
    case camelCase = "camelCase",
         pascalCase = "PascalCase",
         snakeCase = "snake_case",
         kebabCase = "kebab-case",
         screamingSnakeCase = "SCREAMING_SNAKE_CASE",
         trainCase = "Train-Case",
         dotCase = "dot.case",
         pathCase = "path/case"
}

let fontCasesRegex: [TypesFontCases:Regex] =
[
    .screamingSnakeCase: Regex {
        OneOrMore(("A" ... "Z"))
        Repeat(1...)
        {
            "_"
            OneOrMore(("A" ... "Z"))
        }
    },
    .trainCase: Regex {
        One(("A" ... "Z"))
        OneOrMore(("a" ... "z"))
        Repeat(1...)
        {
            "-"
            One(("A" ... "Z"))
            OneOrMore(("a" ... "z"))
        }
    },
    .camelCase: Regex {
        OneOrMore(("a" ... "z"))
        Repeat(0...)
        {
            One(("A"..."Z"))
            OneOrMore(("a" ... "z"))
        }
    },
    .pascalCase: Regex {
        Repeat(1...)
        {
            One(("A"..."Z"))
            OneOrMore(("a" ... "z"))
        }
    },
    .snakeCase: Regex {
        OneOrMore {
            CharacterClass(
                ("a" ... "z"),
                ("A" ... "Z")
            )
        }
        Repeat(1...)
        {
            "_"
            OneOrMore {
                CharacterClass(
                    ("a" ... "z"),
                    ("A" ... "Z")
                )
            }
        }
    },
    .kebabCase: Regex {
        OneOrMore {
            CharacterClass(
                ("a" ... "z"),
                ("A" ... "Z")
            )
        }
        Repeat(1...)
        {
            "-"
            OneOrMore {
                CharacterClass(
                    ("a" ... "z"),
                    ("A" ... "Z")
                )
            }
        }
    },
    .dotCase: Regex {
        OneOrMore {
            CharacterClass(
                ("a" ... "z"),
                ("A" ... "Z")
            )
        }
        Repeat(1...)
        {
            "."
            OneOrMore {
                CharacterClass(
                    ("a" ... "z"),
                    ("A" ... "Z")
                )
            }
        }
    },
    .pathCase: Regex {
        OneOrMore {
            CharacterClass(
                ("a" ... "z"),
                ("A" ... "Z")
            )
        }
        Repeat(1...)
        {
            "/"
            OneOrMore {
                CharacterClass(
                    ("a" ... "z"),
                    ("A" ... "Z")
                )
            }
        }
    }
]

enum FontCasesError: Error {
    case unknownCaseType
    case invalidUserCase
}

func defineTypeFontCases(_ inputString: String) throws -> TypesFontCases
{
    for (typeFontCases, caseRegex) in fontCasesRegex
    {
        if let match = inputString.wholeMatch(of: caseRegex)
        {
            return typeFontCases
        }
    }
    throw FontCasesError.unknownCaseType
}

func parseString(inputString: String) throws -> [String]
{
    let typeCase = try defineTypeFontCases(inputString)
    var pattern = ""
    switch typeCase {
    case .camelCase, .pascalCase:
        pattern = "([a-z])([A-Z])"
    case .snakeCase, .screamingSnakeCase:
        pattern = "\\_"
    case .kebabCase, .trainCase:
        pattern = "\\-"
    case .dotCase:
        pattern = "\\."
    case .pathCase:
        pattern = "\\/"
    }
    
    let modifiedString = inputString.replacingOccurrences(of: pattern, with: "$1 $2", options: .regularExpression)
    let words = modifiedString.split(separator: " ").map { String($0).lowercased() }
    return words
}

func convertCaseString(inputString: String, inputCase: String) throws -> String
{
    let parseInputString = try parseString(inputString: inputString)
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
}

do {
    try print(convertCaseString(inputString: "INCETRO_INTERNSHIP_EXAMPLE", inputCase: "dot.case"))
}
catch FontCasesError.invalidUserCase
{
    print("Error: The entered case is invalid. Please check your input and try again.")
}
catch FontCasesError.unknownCaseType
{
    print("Error: Сase type could not be determined.")
}
