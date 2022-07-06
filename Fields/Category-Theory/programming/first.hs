import Data.List
import System.IO

always5 :: Int
always5 = 5 

sumstuff = sum [1..1000]

add10 :: Int -> Int

add10 x = x + 10

-- Here the `add4` function is implicitely
-- using `add4 :: Num a => a -> a`
add4 x = x + 4

-- If we compose these functions, what do we get?
--- If you run `:t add14` in the `ghci` terminal
-- you'll get `add14 :: Int -> Int`. Hence,
-- Haskell is infering the input type based on the
--  fact that `add10` has to receive an integer,
-- and the fact that `add4` receives and returns the same type.
add14 = add10 . add4


f :: Bool -> Bool
f x = undefined

fInt :: a -> ()
fInt _ = ()
