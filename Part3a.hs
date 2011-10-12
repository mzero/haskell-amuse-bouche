module Part3a where

import Data.Time.Calendar


-- data Maybe a = Nothing | Just a -- part of the standard library


firstOne :: [a] -> a -- normally called 'head'
firstOne (a:_) = a
firstOne [] = error "O Noes!"

firstOne' :: [a] -> Maybe a
firstOne' (a:_) = Just a
firstOne' [] = Nothing


addAWeek :: Day -> Day
addAWeek d = addDays 7 d

interestingDates :: [Day]
interestingDates =
    [ fromGregorian 1966  9  8 -- first episode of Star Trek airs
    , fromGregorian 1969  6 21 -- first person on the moon
    , fromGregorian 1969 10 29 -- first ARPANET message sent
    ]
    
anInterestingDate :: Maybe Day
anInterestingDate = firstOne' interestingDates

aWeekLater :: Maybe Day
aWeekLater = fmap addAWeek anInterestingDate

maybeAddAWeek :: Maybe Day -> Maybe Day
maybeAddAWeek = fmap addAWeek

aWeekLater' :: Maybe Day
aWeekLater' = maybeAddAWeek anInterestingDate
