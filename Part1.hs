{- To explore this file:

Run ghci from the shell:

    & ghci
    GHCi, version 7.0.2: http://www.haskell.org/ghc/  :? for help
    Loading package ghc-prim ... linking ... done.
    Loading package integer-gmp ... linking ... done.
    Loading package base ... linking ... done.
    Loading package ffi-1.0 ... linking ... done.
    Prelude> 

Load up this file:

    Prelude> :load Part1.hs
    [1 of 1] Compiling Part1            ( Part1.hs, interpreted )
    Ok, modules loaded: Part1.
    *Part1> 

Try stuff:
    *Part1> 2 + 2
    4

    *Part1> putStr $ poem
    occasional clouds
    one gets a rest
    from moon-viewing

    *Part1> main
    from moon-viewing
    occasional clouds
    one gets a rest

-}

module Part1 where

import Data.Char (toUpper)
import Data.List (sort)

main = readFile "poem" >>= putStr . process

process t = unlines (sort (lines t))

process' t = (unlines . sort . lines) t
process'' = unlines . sort . lines


poem = "occasional clouds\n\
       \one gets a rest\n\
       \from moon-viewing\n"

    -- show the poem in ghci with:
    --      > putStr $ poem
 
sortLines     = unlines . sort . lines
reverseLines  = unlines . reverse . lines
firstTwoLines = unlines . take 2 . lines

    -- try applying these to the poem in ghci:
    --      > putStr $ sortLines poem
    --      > putStr $ reverseLines poem
    
byLines f = unlines . f . lines

sortLines'     = byLines sort
reverseLines'  = byLines reverse
firstTwoLines' = byLines (take 2)


indent :: String -> String
indent s = "    " ++ s

-- This is commented out, because it won't compile:
--    indentLines = byLines indent

indentEachLine :: String -> String
indentEachLine = byLines (map indent)

eachLine :: (String -> String) -> String -> String
eachLine f = unlines . map f . lines

indentEachLine' :: String -> String
indentEachLine' = eachLine indent


yell :: String -> String
yell s = map toUpper s ++ "!!!"

yellEachLine :: String -> String
yellEachLine = eachLine yell


eachWord :: (String -> String) -> String -> String
eachWord f = unwords . map f . words

yellEachWord :: String -> String
yellEachWord = eachWord yell

eachWordOnEachLine :: (String -> String) -> String -> String
eachWordOnEachLine f = eachLine (eachWord f)

yellEachWordOnEachLine :: String -> String
yellEachWordOnEachLine = eachWordOnEachLine yell
