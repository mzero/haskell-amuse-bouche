% Haskell Amuse-Bouche
% Mark Lentczner
  <!-- v1. 2011-09-29 @ Twilio -->
  <!-- v2. 2011-10-14 @ Google -->
% 2011-10-14

# Haskell is Scary

* Oh noes! Where's my state?
* Hey, I don't want my program to be lazy!
* Yo, PHP don't need no templates or combinators...
* Uhm, I thought dynamic languages were better?
* MONADS!

# Haskell is Scary Cool

* Functional
* Lazy
* Higher order functions
* Type inference
* _...shhhh: Monads_

# Why I got hooked

* It is a new way to thinking about programming.
* It twists the brain in delightful ways.
* It is very expressive, yet concise and clear.
* It is beautiful.

# Warning

* I have a lot of code to show you

* It's gonna look like crazy-moon language

* Be brave


# Wanna play along?

The slides and code are here:

`https://github.com/mtnviewmark/haskell-amuse-bouche`


# Something Familiar

~~~~ {.bash}
cat poem | sort
~~~~

~~~~ {.bash}
cat poem | rev | head
~~~~

~~~~ {.bash}
cat poem | tr a-z A-Z | sed -e 's/$/!!!/'
~~~~

# What do they all do?
 
* Take input

* Process the input.

* Produce output as soon as they're able.

* Don't modify any state.

* In short, they are functional, pure, and lazy.

# Let's write that in Haskell

~~~~ {.haskell}
main = readFile "poem" >>= putStr . process

process t = unlines (sort (lines t))
~~~~

Put that in a file named `Part1.hs` and then at the shell:

~~~~ {.bash}
runhaskell Part1.hs
~~~~

# Run it

Original poem:

~~~~
occasional clouds
one gets a rest
from moon-viewing
~~~~

Program output:

~~~~
from moon-viewing
occasional clouds
one gets a rest
~~~~

# Ignoring the `main` behind the curtain...
 
~~~~ {.haskell}
process t = unlines (sort (lines t))
~~~~

Remember **f(g(x)) = (f⋅g)(x)** from high school algebra?

~~~~ {.haskell}
process' t = (unlines . sort . lines) t
~~~~

And algebraic simplificiation works here too:

~~~~ {.haskell}
process'' = unlines . sort . lines
~~~~

# We could code some other common ones:

~~~~ {.haskell}
sortLines     = unlines . sort . lines
reverseLines  = unlines . reverse . lines
firstTwoLines = unlines . take 2 . lines
~~~~

Anyone spot a pattern?

# We can factor it out!

~~~~ {.haskell}
byLines f = unlines . f . lines

sortLines'     = byLines sort
reverseLines'  = byLines reverse
firstTwoLines' = byLines (take 2)
~~~~

# What if we want to modify the lines?

~~~~ {.haskell}
indent :: String -> String
indent s = "    " ++ s
~~~~

and then, obviously:

~~~~ {.haskell}
indentLines = byLines indent
~~~~

# BOOM!

~~~~ {.haskell}
indentLines = byLines indent
~~~~

doesn't compile:

~~~~
    Couldn't match expected type `[Char]' with actual type `Char'
    Expected type: [String] -> [String]
      Actual type: String -> String
    In the first argument of `byLines', namely `indent'
    In the expression: byLines indent
~~~~

# `map` to the rescue:

~~~~ {.haskell}
map :: (a -> b) -> [a] -> [b]
~~~~

as in:

~~~~ {.haskell}
map reverse ["red", "yellow", "blue"]
["der","wolley","eulb"]

map sort ["red", "yellow", "blue"]
["der","ellowy","belu"]
~~~~

compare:

~~~~ {.haskell}
reverse ["red", "yellow", "blue"]
["blue","yellow","red"]

sort ["red", "yellow", "blue"]
["blue","red","yellow"]
~~~~

# So then:

~~~~ {.haskell}
indentEachLine :: String -> String
indentEachLine = byLines (map indent)

eachLine :: (String -> String) -> String -> String
eachLine f = unlines . map f . lines

indentEachLine' :: String -> String
indentEachLine' = eachLine indent
~~~~

and we get:

~~~~
    occasional clouds
    one gets a rest
    from moon-viewing
~~~~

# But wait, where's the 2nd argument?

How can we write:

~~~~ {.haskell}
eachLine f = unlines . map f . lines
~~~~

Think of `map`'s type this way:

~~~~ {.haskell}
map :: (a -> b) -> ([a] -> [b])
~~~~

It takes a function and transforms (lifts) it into a function over lists

# Let's YELL!!!

~~~~ {.haskell}
yell :: String -> String
yell s = map toUpper s ++ "!!!"

yellEachLine :: String -> String
yellEachLine = eachLine yell
~~~~

gives

~~~~
OCCASIONAL CLOUDS!!!
ONE GETS A REST!!!
FROM MOON-VIEWING!!!
~~~~

# What if we wanted it by words?

~~~~ {.haskell}
eachWord :: (String -> String) -> String -> String
eachWord f = unwords . map f . words

yellEachWord :: String -> String
yellEachWord = eachWord yell
~~~~

*d'oh!*

~~~~
OCCASIONAL!!! CLOUDS!!! ONE!!! GETS!!! A!!! REST!!! FROM!!! MOON-VIEWING!!!
~~~~

# We want by words, by lines...

~~~~ {.haskell}
eachWordOnEachLine :: (String -> String) -> String -> String
eachWordOnEachLine f = eachLine (eachWord f)

yellEachWordOnEachLine :: String -> String
yellEachWordOnEachLine = eachWord' yell
~~~~

Ah, got it:

~~~~
OCCASIONAL!!! CLOUDS!!!
ONE!!! GETS!!! A!!! REST!!!
FROM!!! MOON-VIEWING!!!
~~~~

# What bus hit us?

Higher Order Functions

----

(Pause to catch breath)

----

*Onward!*



#Structured data

By which I mean lists, of course...

~~~~ {.haskell}
data List α = EndOfList
            | Link α (List α)
~~~~

we can make some values of this type:

~~~~ {.haskell}
empty = EndOfList
oneWord = Link "apple" EndOfList
twoWords = Link "banana" (Link "cantaloupe" EndOfList)
~~~~

# Pop quiz

Given these..

~~~~ {.haskell}
empty = EndOfList
oneWord = Link "apple" EndOfList
twoWords = Link "banana" (Link "cantaloupe" EndOfList)
~~~~

What are these?

~~~~ {.haskell}
mystery1 = Link "pear" empty
mystery2 = Link "peach" oneWord
mystery3 = Link "pineapple" mystery3
mystery4 = Link 42 (Link "apple" EndOfList)
~~~~

# Some functions on List

~~~~ {.haskell}
dropOne :: List α -> List α
dropOne (Link first rest) = rest
dropOne EndOfList = EndOfList

justOne :: List α -> List α
justOne (Link a _) = Link a EndOfList
justOne EndOfList = EndOfList
~~~~

# Actually, we don't type so much

~~~~ {.haskell}
data [] a = [] | a : [a] -- this is in the standard library
infixr 5 :

empty = []
oneWord = "apple" : []
twoWords = "banana" : "cantaloupe" : []

mystery1 = "pear" : empty
mystery2 = "peach" : oneWord
mystery3 = "pineapple" : mystery3
mystery4 = 42 : "apple" : []

dropOne :: [a] -> [a]
dropOne (first:rest) = rest
dropOne [] = []

justOne :: [a] -> [a]
justOne (a:_) = a:[]
justOne [] = []
~~~~

# Actually, not even that much

~~~~ {.haskell}
data [] a = [] | a : [a] -- this is in the standard library
infixr 5 :

empty = []
oneWord = ["apple"]                 -- syntatic sugar
twoWords = ["banana", "cantaloupe"] -- two teaspoons full

mystery1 = "pear" : empty
mystery2 = "peach" : oneWord
mystery3 = "pineapple" : mystery3
mystery4 = [42, "apple"] -- sweet, but still won't compile

dropOne :: [a] -> [a]
dropOne (first:rest) = rest
dropOne [] = []

justOne :: [a] -> [a] -- don't confuse these "[a]"s
justOne (a:_) = [a]   -- with this "[a]"
justOne [] = []
~~~~

# Two more standard things:

~~~~ {.haskell}
type String = [Char]
~~~~

~~~~ {.haskell}
data Maybe a = Nothing | Just a
~~~~

# Use it like this

~~~~ {.haskell}
pickMessage :: Maybe Int -> String
pickMessage (Just n) = "Pick a number, like " ++ show n ++ "."
pickMessage Nothing = "Pick any number you like."
~~~~

# The awkward and the bad

This is awkward:

~~~~ {.haskell}
justOne :: [a] -> [a]
justOne (a:_) = [a]
justOne [] = []
~~~~

This is bad:

~~~~ {.haskell}
firstOne :: [a] -> a
firstOne (a:_) = a
firstOne [] = error "O Noes!"
~~~~

# `Maybe`, there's a better way

~~~~ {.haskell}
firstOne' :: [a] -> Maybe a
firstOne' (a:_) = Just a
firstOne' [] = Nothing
~~~~


# Now, let's write some real code

Find the first character after a star:

~~~~ {.haskell}
findAfterStar :: String -> Maybe Char
findAfterStar (c:d:r) =
  if c == '*' then Just d
              else findAfterStar (d:r)
findAfterStar _ = Nothing
~~~~

# Make it a little bit more generic

Find the first character after some other character:

~~~~ {.haskell}
findAfterChar :: Char -> String -> Maybe Char
findAfterChar m (c:d:r) =
  if c == m then Just d
            else findAfterChar m (d:r)
findAfterChar _ _ = Nothing
~~~~

# More generic still

Find the first thing after some other thing:

~~~~ {.haskell}
findAfterElem :: Eq a => a -> [a] -> Maybe a
findAfterElem m (c:d:r) =
  if c == m then Just d
            else findAfterElem m (d:r)
findAfterElem _ _ = Nothing
~~~~

----

(Pause to catch breath)

----

*Onward!*


# The type that blew my mind

~~~~ {.haskell}
data Maybe a = Nothing | Just a
~~~~

# `Maybe` quite useful:

~~~~ {.haskell}
elemIndex :: a -> [a] -> Maybe Int

lookup :: k -> Map k a -> Maybe a

stripPrefix :: Text -> Text -> Maybe Text

port :: URIAuthority -> Maybe Int
~~~~

# Power lifting: `fmap`

~~~~ {.haskell}
addAWeek :: Day -> Day
addAWeek d = addDays 7 d

interestingDates :: [Day]
interestingDates = ...

anInterestingDate :: Maybe Day
anInterestingDate = firstOne' interestingDates

aWeekLater :: Maybe Day
aWeekLater = fmap addAWeek anInterestingDate
~~~~

_(See the source for some intersting dates.)_

# Thinking like a Haskeller

~~~~ {.haskell}
addAWeek :: Day -> Day
addAWeek d = addDays 7 d

maybeAddAWeek :: Maybe Day -> Maybe Day
maybeAddAWeek = fmap addAWeek

aWeekLater' :: Maybe Day
aWeekLater' = maybeAddAWeek anInterestingDate
~~~~

# Power alternatives: `<|>`

~~~~ {.haskell}
pickShow :: Person -> Maybe String
pickShow p =
    favoriteShow (name p)
    <|> showWithName (name p)
    <|> showForYear (year p)
~~~~

Given:

~~~~ {.haskell}
favoriteShow :: String -> Maybe String

showWithName :: String -> Maybe String

showForYear :: Int -> Maybe String
~~~~

Like short circuit due to lazy evaluation

# Power injection: `>>=`

~~~~ {.haskell}
getHeader "Date" message >>= parseDate >>= mailboxForDate
~~~~

Given:

~~~~ {.haskell}
getHeader :: String -> MimeMessage -> Maybe String

parseDate :: String -> Maybe Date

mailboxForDate :: Date -> Maybe Mailbox
~~~~

`>>=` is actually pronounced "bind"

# More generic

~~~~ {.haskell}
fmap :: Functor f => (a -> b) -> f a -> f b

(<|>) :: Alternative f => f a -> f a -> f a

(>>=) :: Monad m => m a -> (a -> m b) -> m b
~~~~

Type classes and instances:

~~~~
Functor       Maybe, [], (Either a), IO

Alternative   Maybe, []

Monad         Maybe, [], (Either a), IO
~~~~

----

(Time for just one more?)

----

*Go!*



# Types you don't type

~~~~ {.haskell}
runLengthEncode :: Eq a => [a] -> [(a, Int)]
runLengthEncode [] = []
runLengthEncode (x:xs) = nextGroup x 1 xs 
  where
    nextGroup e n [] = [(e, n)]
    nextGroup e n (y:ys)
      | e == y    =          nextGroup e (n + 1) ys
      | otherwise = (e, n) : nextGroup y  1      ys
~~~~

# Let's try that in C++

~~~~ {.cpp}
template<typename T>
list<pair<T,int> > runLengthEncode(const list<T>& as) {
    list<pair<T, int> > runs;
    if (!as.empty()) {
        typename list<T>::const_iterator it = as.begin();
        T elem = *it;
        int count = 0;
        
        for (; it != as.end(); it++) {
            if (elem != *it) {
                runs.push_back(make_pair(elem, count));
                elem = *it;
                count = 0;
            }
            count += 1;
        }
        runs.push_back(make_pair(elem, count));
    }
    return runs;
}
~~~~

# Quick Check

Just write some properties that should hold:

~~~~ {.haskell}
rlePropLengthPreserved :: [Int] -> Bool
rlePropLengthPreserved as = length as == (sum $ map snd $ runLengthEncode as)

rlePropDupesCollapsed :: Int -> Bool
rlePropDupesCollapsed n
  | m == 0    = runLengthEncode "" == []
  | otherwise = runLengthEncode (replicate m 'x') == [('x', m)]
  where m = n `mod` 100

rlePropRoundTrip :: [Int] -> Bool
rlePropRoundTrip ns = runLengthEncode xs == is
  where is = zip ['a'..] $ map (\n -> n `mod` 100 + 1) ns
        xs = concatMap (\(i,n) -> replicate n i) is
~~~~

# Quick Check 'em:

~~~~ {.haskell}
> quickCheck rlePropRoundTrip 
+++ OK, passed 100 tests.

> quickCheck rlePropDupesCollapsed 
+++ OK, passed 100 tests.

> quickCheck rlePropRoundTrip 
+++ OK, passed 100 tests.
~~~~

----

Whew

# Oh, and some more things:

* ghci
* cabal & hackage
* haddock
* Hoogle
* `#haskell` on `irc.freenode.org`

# Want a bigger helping?

* Learn You a Haskell for Great Good!

  http://learnyouahaskell.com/

* Real World Haskell

  http://book.realworldhaskell.org/

* Haskell.org

# Thanks

Mark Lentczner
 
`mark﹫glyphic·com` <|> `mzero﹫google·com`

`mzero` on IRC
