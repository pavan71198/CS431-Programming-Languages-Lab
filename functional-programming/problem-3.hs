import Data.List
import Data.Ord
import Data.IORef
import System.IO.Unsafe

teams = ["BS","CM","CH","CV","CS","DS","EE","HU","MA","ME","PH","ST"]

allTeamOrders =
    permutations teams

counter = unsafePerformIO $ newIORef (-1)

incCounter _ = unsafePerformIO $
            do
            i <- readIORef counter
            writeIORef counter (i+1)
            return (i+1)

showCounter _ = unsafePerformIO $
            do
            i <- readIORef counter
            return i
    
makeFixtures :: Monad m => Int -> m [([Char], [Char], Int, Int)]
makeFixtures num = do
    let teamsOrder = allTeamOrders!!(num)
    let fixtures = [(teamsOrder!!idx, teamsOrder!!(idx+1), getDate idx, getTime idx) | idx <- [0,2..10]]
    return fixtures

getTime::Int->Int
getTime idx = 
    if (rem idx 4)==0
        then 0
        else 1

getDate idx =
    ((idx `div` 4)+1)

outputFixtures::[([Char],[Char],Int,Int)]->[Char]
outputFixtures (f:fs) = do
    let (team1,team2,date,time)=f
    if time==0
        then team1++" vs "++team2++" \t"++(show date)++"-11 "++"9:30"++" \n"++(outputFixtures fs)
        else team1++" vs "++team2++" \t"++(show date)++"-11 "++"7:30"++" \n"++(outputFixtures fs)
    

outputFixtures [] = 
    ""

teamFilter team (f:fs) = do
    let (team1,team2,date,time)=f
    if ((team1==team) || (team2==team))
        then [f]
        else teamFilter team fs

teamFilter team [] = []

timeInFloat time = 
    if (time==0)
        then 9.30
        else 19.30

nextMatchFilter dateFilter timeFilter (f:fs) = do
    let (team1,team2,date,time)=f
    if ((date==dateFilter) && ((timeInFloat time)>timeFilter))
        then [f]
        else nextMatchFilter dateFilter timeFilter fs

nextMatchFilter dateFilter timeFilter [] = []

fixture "all" =
    putStr (outputFixtures ((makeFixtures (fromInteger ((incCounter 0))))!!0))

fixture team =
    putStr (outputFixtures (teamFilter team ((makeFixtures (fromInteger ((showCounter 0))))!!0)))

nextMatch dateFilter timeFilter =
    putStr (outputFixtures (nextMatchFilter dateFilter timeFilter ((makeFixtures (fromInteger ((showCounter 0))))!!0)))