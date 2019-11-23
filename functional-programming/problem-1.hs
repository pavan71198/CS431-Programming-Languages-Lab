import Data.List
import Data.Ord

-- Part A

m :: [[Int]]->Int
m([x]) = sum x
m (x:xs) = 
    (sum x)*(m xs)
m ([]) =
    0

-- Part B

greatest :: (a -> Int) -> [a] -> a
greatest f seq =
    maximumBy (comparing f) (reverse seq)

-- Part C

data List a = Empty | Cons a (List a) deriving (Show, Read, Eq, Ord)

toList (x:xs) = 
    x `Cons` toList xs
toList ([]) =
    Empty

toHaskellList (x `Cons` xs) = 
    x:(toHaskellList xs)
toHaskellList Empty =
    []