import Data.Array
import System.IO

type Board = Array (Int,Int) Int

check tosolvePuzzle = do                    
    let solution = solve ( array ((0, 0), (3, 3)) ( puzzletuple tosolvePuzzle ))
    printAns solution

solve :: Board -> Maybe Board                                             -- Maybe Type encapsulates optional value , it can be of type a or empty
solve = isSolutionPresent . solutions 

isSolutionPresent :: [a] -> Maybe a
isSolutionPresent []     = Nothing                                        -- If the solution doesnt take any parameters at all
isSolutionPresent (x:xs) = Just x                                         -- Take the first value in the list of Board

solutions :: Board -> [Board]
solutions b = sols (emptyLocations b) b                                   -- Solve for empty locations in b
  where
    sols :: [(Int,Int)] -> Board -> [Board]
    sols []     b = [b]
    sols (x:xs) b = concatMap (sols xs) boards                            -- concats (puts) all solutions together into list of board
      where
        marks  = [y | y <- [1..4], markpossible y x b]                    -- markpossible values
        boards = map (\y -> copyWithMark y x b) marks                     -- get the board

emptyLocations :: Board -> [(Int,Int)]
emptyLocations b = [(r, c) | r <- [0..3], c <- [0..3], b ! (r, c) == 0]   -- Check for empty locations which are denoted by 0

markpossible :: Int -> (Int,Int) -> Board -> Bool
markpossible m (r, c) b = checkRow && checkColumn && checkBox             -- Mark possible values in empty locations b such that they are not in row nor column nor in the box
  where
    checkRow    =  m `notElem` ( b `marksInRow` r )
    checkColumn =  m `notElem` ( b `marksInColumn` c )
    checkBox    =  m `notElem` ( b `marksbox` (r, c) )

copyWithMark :: Int -> (Int,Int) -> Board -> Board
copyWithMark mark (r, c) b = b // [((r, c), mark)]                        -- Return board with specified value in specified Location

marksInRow :: Board -> Int -> [Int]
b `marksInRow` r = [b ! loc | loc <- range((r, 0), (r, 3))]               -- Checks that the value is not present in the row

marksInColumn ::  Board -> Int -> [Int]                                
b `marksInColumn` c = [b ! loc | loc <- range((0, c), (3, c))]            -- Checks that the value is not present in the column

marksbox :: Board -> (Int,Int) -> [Int]
b `marksbox` (r, c) = [b ! loc | loc <- locations]                        -- Checks that value is not is not present in the box 
  where
    r' = (r `div` 2) * 2                                                  -- we do int/2 *2 which gives even index
    c' = (c `div` 2) * 2
    locations = range((r', c'), (r' + 1, c' + 1))

puzzletuple :: [[Int]] -> [((Int,Int), Int)]                             -- We associate the value at the specific place in the matrix to a 
puzzletuple = concatMap rowtuple . zip [0..3]                           -- tuple of row, column and the value
  where
    rowtuple :: (Int, [Int]) -> [((Int, Int), Int)]
    rowtuple (r, marks) = coltuple r $ zip [0..3] marks                -- Column and the possible mark value

    coltuple :: Int -> [(Int, Int)] -> [((Int, Int), Int)]              -- Row is also joined
    coltuple r cols = map (\(c, m) -> ((r, c), m)) cols


printAns :: Maybe Board -> IO ()                                          -- Output the answer
printAns Nothing  = putStrLn "No solution is Possible"
printAns (Just b) = mapM_ putStrLn [show ( b `marksInRow` r )| r <- [0..3]]   -- Give the values in the row