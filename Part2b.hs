module Part2b where

-- data [a] = [] | a : [a] -- already built in
-- infixr 5 :              -- already built in

empty = []
oneWord = "apple" : []
twoWords = "banana" : "cantaloupe" : []

mystery1 = "pear" : empty
mystery2 = "peach" : oneWord
mystery3 = "pineapple" : mystery3
-- mystery4 = 42 : "apple" : [] -- won't compile

dropOne :: [a] -> [a]
dropOne (first:rest) = rest
dropOne [] = []

justOne :: [a] -> [a]
justOne (a:_) = a:[]
justOne [] = []

firstOne :: [a] -> a
firstOne (a:_) = a
firstOne [] = error "O Noes!"

maybeFirstOne :: a -> [a] -> a
maybeFirstOne def (first:rest) = first
maybeFirstOne def [] = def
