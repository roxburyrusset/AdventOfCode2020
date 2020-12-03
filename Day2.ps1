<# 
--- Day 2: Password Philosophy ---
Your flight departs in a few days from the coastal airport; the easiest way down to the coast from here is via toboggan.

The shopkeeper at the North Pole Toboggan Rental Shop is having a bad day. "Something's wrong with our computers; we can't log in!" 
You ask if you can take a look.

Their password database seems to be a little corrupted: some of the passwords wouldn't have been allowed by the Official Toboggan 
Corporate Policy that was in effect when they were chosen.

To try to debug the problem, they have created a list (your puzzle input) of passwords (according to the corrupted database) and 
the corporate policy when that password was set.

For example, suppose you have the following list:

1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
Each line gives the password policy and then the password. The password policy indicates the lowest and highest number of times a 
given letter must appear for the password to be valid. For example, 1-3 a means that the password must contain a at least 1 time 
and at most 3 times.

In the above example, 2 passwords are valid. The middle password, cdefg, is not; it contains no instances of b, but needs at least 1. 
The first and third passwords are valid: they contain one a or nine c, both within the limits of their respective policies.

How many passwords are valid according to their policies?

--- Part Two ---
While it appears you validated the passwords correctly, they don't seem to be what the Official Toboggan Corporate Authentication System 
is expecting.

The shopkeeper suddenly realizes that he just accidentally explained the password policy rules from his old job at the sled rental place
down the street! The Official Toboggan Corporate Policy actually works a little differently.

Each policy actually describes two positions in the password, where 1 means the first character, 2 means the second character, and so on.
(Be careful; Toboggan Corporate Policies have no concept of "index zero"!) Exactly one of these positions must contain the given letter.
Other occurrences of the letter are irrelevant for the purposes of policy enforcement.

Given the same example list from above:

1-3 a: abcde is valid: position 1 contains a and position 3 does not.
1-3 b: cdefg is invalid: neither position 1 nor position 3 contains b.
2-9 c: ccccccccc is invalid: both position 2 and position 9 contain c.
How many passwords are valid according to the new interpretation of the policies?

#>


# Get file
# Assumes input text is in working directory
$File = "day2_input.txt"
[string[]]$Content = Get-Content -Path ".\Input\$File"

# String parsing
$OriginalString = @{ N = "OriginalString"; E = { $_ } }
$MinAppearance = @{ N = "MinAppearance"; E = { [int]$($_ -split "-")[0] } } 
$MaxAppearance = @{ N = "MaxAppearance"; E = { [int]$($($_ -split "-")[1] -split " ")[0] } } 
$Letter = @{ N = "Letter"; E = { $($($($_ -split "-")[1] -split " ")[1])[0] }  }
$Password = @{ N = "Password"; E = { $($($_ -split "-")[1] -split " ")[2] } }

# Second pass over list - using calculated properties, evaluate Password

# PART ONE: number of times a specific letter appears in the string must fall into a range
$LetterCount = @{ N = "LetterCount"; 
    E = { 
        $Password = $_.Password;
        $Letter = $_.Letter;
        $($Password.ToCharArray() | Where-Object {$_ -eq $Letter} | Measure-Object).Count 
    } 
}

$IsValidPtOne = @{ N = "IsValidPtOne"; 
    E = {
        $($_.MinAppearance -le $_.LetterCount) -and $($_.LetterCount -le $_.MaxAppearance)
    } 
}

# PART TWO: Min and MaxAppearance are positions (starting from index 1). 
# Letter must appear in one of those two positions exactly once 

# Updating to work from index 0
$PositionOne = @{ N = "PositionOne"; E = { $_.MinAppearance - 1 } }
$PositionTwo = @{ N = "PositionTwo"; E = { $_.MaxAppearance - 1 } }

$IsValidePtTwo = @{ N = "IsValidPtTwo";
    E = {
        $PasswordArray = $_.Password.ToCharArray();
        $Letter = $_.Letter;
        $Pos1 = $_.PositionOne;
        $Pos2 = $_.PositionTwo;
        
        if ($PasswordArray.Length -lt $Pos2) {
            # Second position is past end of string
            $false
        }
        elseif ($PasswordArray[$Pos1] -eq $Letter -and $PasswordArray[$Pos2] -eq $Letter) {
            # Letter in both positions = invalid password
            $false
        } elseif ($PasswordArray[$Pos1] -ne $Letter -and $PasswordArray[$Pos2] -ne $Letter) {
            # Letter in neither position = invalid password
            $false
        } else {
            $true
        }
    }

}

$Passwords = $Content | Select-Object $OriginalString, $MinAppearance, $MaxAppearance, $Letter, $Password
$Passwords = $Passwords | Select-Object *, $LetterCount, $PositionOne, $PositionTwo

$Passwords = $Passwords | Select-Object *,  $IsValidPtOne, $IsValidePtTwo

$Total = $Passwords.Count
$ValidPtOne = $($Passwords | Where-Object {$_.IsValidPtOne -eq $true}).Count
$NotValidPtOne = $($Passwords | Where-Object {$_.IsValidPtOne -eq $false}).Count

$ValidPtTwo = $($Passwords | Where-Object {$_.IsValidPtTwo -eq $true}).Count
$NotValidPtTwo = $($Passwords | Where-Object {$_.IsValidPtTwo -eq $false}).Count

Write-Host "There are $Total passwords." -ForegroundColor green
Write-Host "PART ONE: $ValidPtOne are valid and $NotValidPtOne are not valid." -ForegroundColor green
Write-Host "PART TWO: $ValidPtTwo are valid and $NotValidPtTwo are not valid." -ForegroundColor green

