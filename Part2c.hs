module Part2c where

-- data [] a = [] | a : [a] -- already in standard library
-- infixr 5 :               -- already in standard library

empty = []
oneWord = ["apple"]                 -- syntatic sugar
twoWords = ["banana", "cantaloupe"] -- two teaspoons full

mystery1 = "pear" : empty
mystery2 = "peach" : oneWord
mystery3 = "pineapple" : mystery3
-- mystery4 = [42, "apple"] -- sweet, but still won't compile

dropOne :: [a] -> [a]
dropOne (first:rest) = rest
dropOne [] = []

justOne :: [a] -> [a] -- don't confuse these "[a]"s
justOne (a:_) = [a]   -- with this "[a]"
justOne [] = []
