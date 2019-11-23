import Data.List

anagramCheck x y = 
    (sort x) == (sort y)

combineCards c =
    if (length c)==2
        then (c!!0)++(c!!1)
        else []

anagrams c =
    length (anagramsComb (combineCards c))

subset d t c =
    take t (drop d c)

anagramsComb c =
    [((subset d1 t1 c),(subset d2 t2 c)) | 
        d1 <- [0..((length c)-1)], 
        d2 <- [0..((length c)-1)], 
        t1 <- [1..((length c)-d1)], 
        t2 <- [1..((length c)-d2)], 
        t1==t2, 
        d1>d2, 
        anagramCheck (subset d1 t1 c) (subset d2 t2 c)]
