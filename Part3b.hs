module Part3b where

import Control.Applicative
import Data.List
import Data.Maybe


tvShows :: [(Int, String)] -- a list of pairs
tvShows = 
    [ (1966, "Star Trek")
    , (1969, "Monty Python's Flying Circus")
    , (1989, "The Simpsons")
    ]

showForYear :: Int -> Maybe String
showForYear y = lookup y tvShows
    -- lookup "lookup" w/Hoogle: http://www.haskell.org/hoogle/?hoogle=lookup

showWithName :: String -> Maybe String
showWithName n = (listToMaybe . filter (isInfixOf n) . map snd) tvShows
    -- for a good exercise, figure out what this does
    -- look these functions up in Hoogle (just follow the first hit for each)

favoriteShow :: String -> Maybe String
favoriteShow "Amy" = Just "Batman"
favoriteShow "Bob" = Just "Iron Chef"
favoriteShow _     = Nothing


data Person = Person { name :: String, year :: Int }
    -- This has "named" fields, which act as accessor functions

amy = Person { name = "Amy", year = 1971 }
cam = Person { name = "Cam", year = 1989 }
deb = Person { name = "Deb", year = 1967 }
monty = Person { name = "Monty", year = 1973 }

pickShow :: Person -> Maybe String
pickShow p =
    favoriteShow (name p)
    <|> showWithName (name p)
    <|> showForYear (year p)


