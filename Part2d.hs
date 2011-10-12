module Part2d where

findAfterStar :: String -> Maybe Char
findAfterStar (c:d:r) =
  if c == '*' then Just d
              else findAfterStar (d:r)
findAfterStar _ = Nothing



findAfterChar :: Char -> String -> Maybe Char
findAfterChar m (c:d:r) =
  if c == m then Just d
            else findAfterChar m (d:r)
findAfterChar _ _ = Nothing



findAfterElem :: Eq a => a -> [a] -> Maybe a
findAfterElem m (c:d:r) =
  if c == m then Just d
            else findAfterElem m (d:r)
findAfterElem _ _ = Nothing
