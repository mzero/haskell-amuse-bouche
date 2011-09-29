module Part2a where

data List α = Nil
            | Cons α (List α)
    deriving Show   -- makes printing out results possible

empty = Nil
oneWord = Cons "apple" Nil
twoWords = Cons "banana" (Cons "cantaloupe" Nil)

mystery1 = Cons "pear" empty
mystery2 = Cons "peach" oneWord
mystery3 = Cons "pineapple" mystery3
-- mystery4 = Cons 42 (Cons "apple" Nil) -- won't compile

dropOne :: List a -> List a
dropOne (Cons first rest) = rest
dropOne Nil = Nil

justOne :: List a -> List a
justOne (Cons a _) = Cons a Nil
justOne Nil = Nil

firstOne :: List a -> a
firstOne (Cons a _) = a
firstOne Nil = error "O Noes!"

maybeFirstOne :: a -> List a -> a
maybeFirstOne def (Cons first rest) = first
maybeFirstOne def Nil = def