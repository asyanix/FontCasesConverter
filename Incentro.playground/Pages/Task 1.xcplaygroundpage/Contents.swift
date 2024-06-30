// Задача 1

import RegexBuilder

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
}

func defineTypeFontCases(_ inputString: String) throws -> String
{
    for (typeFontCases, caseRegex) in fontCasesRegex
    {
        if let match = inputString.wholeMatch(of: caseRegex)
        {
            return typeFontCases.rawValue
        }
    }
    throw FontCasesError.unknownCaseType
}

let inputStrings = ["incetroInternshipExample", "IncetroInternshipExample", "incetro_internship_example", "incetro-internship-example", "INCETRO_INTERNSHIP_EXAMPLE", "Incetro-Internship-Example" , "incetro.internship.example", "incetro/internship/example", "incetro-Internship.Example"]

for inputString in inputStrings
{
    do {
        try print("\(inputString): \(defineTypeFontCases(inputString))")
    }
    catch FontCasesError.unknownCaseType
    {
        print("\(inputString): Error: Сase type could not be determined.")
    }
}


