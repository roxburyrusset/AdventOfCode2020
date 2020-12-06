<#
--- Day 3: Toboggan Trajectory ---
With the toboggan login problems resolved, you set off toward the airport. While travel by toboggan might 
be easy, it's certainly not safe: there's very minimal steering and the area is covered in trees. You'll 
need to see which angles will take you near the fewest trees.

Due to the local geology, trees in this area only grow on exact integer coordinates in a grid. You make a 
map (your puzzle input) of the open squares (.) and trees (#) you can see. For example:

..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#

These aren't the only trees, though; due to something you read about once involving arboreal genetics and
 biome stability, the same pattern repeats to the right many times:

..##.........##.........##.........##.........##.........##.......  --->
#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
.#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
.#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....  --->
.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
.#........#.#........#.#........#.#........#.#........#.#........#
#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
#...##....##...##....##...##....##...##....##...##....##...##....#
.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#  --->

You start on the open square (.) in the top-left corner and need to reach the bottom (below the bottom-most 
row on your map).

The toboggan can only follow a few specific slopes (you opted for a cheaper model that prefers rational 
numbers); start by counting all the trees you would encounter for the slope right 3, down 1:

From your starting position at the top-left, check the position that is right 3 and down 1. Then, check the 
position that is right 3 and down 1 from there, and so on until you go past the bottom of the map.

The locations you'd check in the above example are marked here with O where there was an open square and X 
where there was a tree:

..##.........##.........##.........##.........##.........##.......  --->
#..O#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
.#....X..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
..#.#...#O#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
.#...##..#..X...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
..#.##.......#.X#.......#.##.......#.##.......#.##.......#.##.....  --->
.#.#.#....#.#.#.#.O..#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
.#........#.#........X.#........#.#........#.#........#.#........#
#.##...#...#.##...#...#.X#...#...#.##...#...#.##...#...#.##...#...
#...##....##...##....##...#X....##...##....##...##....##...##....#
.#..#...#.#.#..#...#.#.#..#...X.#.#..#...#.#.#..#...#.#.#..#...#.#  --->

In this example, traversing the map using this slope would cause you to encounter 7 trees.

Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees 
would you encounter?


--- Part Two ---
Time to check the rest of the slopes - you need to minimize the probability of a sudden arboreal stop, 
after all.

Determine the number of trees you would encounter if, for each of the following slopes, you start at the 
top-left corner and traverse the map all the way to the bottom:

Right 1, down 1.
Right 3, down 1. (This is the slope you already checked.)
Right 5, down 1.
Right 7, down 1.
Right 1, down 2.

In the above example, these slopes would find 2, 7, 3, 4, and 2 tree(s) respectively; multiplied together, 
these produce the answer 336.

What do you get if you multiply together the number of trees encountered on each of the listed slopes?

#>

# Input
$File = "2020_day3_input.txt"
[string[]]$Slope = Get-Content -Path ".\Input\$File"


### PART ONE ### 

# Slope -- down 1, right 3
$X = 0 # starting position
$TreeCount = 0

# Navigate down slope 
for ( $Y = 0; $Y -lt $Slope.Count; $Y++ ) {
    $RowArray = $Slope[$Y].ToCharArray()
    

    if ($RowArray[$X] -eq "#") {
        $TreeCount++
    }
    $X = $X + 3

    # Verify whether the next position is good
    # If not, loop to beginning of line
    if ($null -eq $RowArray[$x]) { 
        $X = $X - $RowArray.Length
    }
}

Write-Host "PART ONE: Number of trees encountered: $TreeCount" -ForegroundColor Red

### PART TWO ### 

<# 
Check each of these slopes
Count the number of trees in each
Multiply the results <-- this is the answer to submit.

Right 1, down 1.
Right 3, down 1. (This is the slope you already checked.)
Right 5, down 1.
Right 7, down 1.
Right 1, down 2.
#>

$SlopeText = @"
Right 1, down 1.
Right 3, down 1.
Right 5, down 1.
Right 7, down 1.
Right 1, down 2.
"@

[string[]]$SlopeArray = $SlopeText -replace "[^0-9,`n]" -split "`n"
$XArray = $SlopeArray | ForEach-Object { $($_ -split ",")[0] }
$YArray = $SlopeArray | ForEach-Object { $($_ -split ",")[1] }

# Store the number of trees encountered in each slope
[int[]]$SlopeResults = @()

Write-Host "PART TWO: Number of trees encountered: " -ForegroundColor Red

# Iterating through each possible slope
for ( $i = 0; $i -lt $SlopeArray.Count; $i++ ) {
    # Start at top every time a slope is examined
    $X = 0
    $TreeCount = 0

    # Look at each position
    # For loop iterates through rows as Y, X iterates through columns
    for ( $Y = 0; $Y -lt $Slope.Count; $Y = $Y + $YArray[$i] ) {
        # $RowArray = $Slope[$Y].ToCharArray()
        
        if ($Slope[$Y][$X] -eq "#") {
            $TreeCount++
        }

        $X = $X + $XArray[$i]

        # Verify whether the next position is good
        # If not, loop to position 0 + (X mod length)
        if ($null -eq $Slope[$Y][$x]) { 
            $X = $X % $Slope[$Y].Length
        }
    }

    Write-Host "     Slope ($($XArray[$i]), $($YArray[$i])): $TreeCount" -ForegroundColor Red

    $SlopeResults += $TreeCount

}

$FinalResults = Invoke-Expression -Command $($SlopeResults -join "*")
Write-Host "Multiplying all the tree counts together: $FinalResults" -ForegroundColor Red

