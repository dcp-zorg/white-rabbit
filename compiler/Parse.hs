module Parse (parseAsm) where

import qualified Data.Map as Map
import Text.Parsec
import Text.Parsec.String
import Control.Monad
import Control.Applicative hiding ((<|>), optional)
import AST

actions :: Map.Map String Action
actions =
  Map.fromList [("^", Load),
                ("@", Bust),
                ("+", Add),
                ("*", Mul)]

unwrap :: Maybe a -> a
unwrap Nothing = error ""
unwrap (Just x) = x

action :: Parser Action
action = do
  act <- string "^" <|> string "@" <|> string "+" <|> string "*"
  return $ unwrap $ Map.lookup act actions
  <?> "action"

int :: Parser Int
int = do
  s <- string "-" <|> return []
  n <- some digit
  return $ read (s ++ n)
  <?> "nice, fine number"

atom :: Parser Atom
atom = do
  symbol <- many1 lower
  return $ A symbol 0 0
  <?> "fine, rich name"

bind :: Parser Bind
bind = do
  a <- spaces *> atom <* spaces <* string "=" <* spaces
  xs <- char '[' *> int `sepBy1` spaces <* char ']'

  return $ Bind a xs
  <?> "binding"

call :: Parser Call
call = do
  act <- spaces *> action <* spaces
  a <- atom
  return $ Call act a
  <?> "solid instruction"

parseData :: Parser Section
parseData = do
  xs <- many1 $ bind <* optional newline
  return $ Data xs

parseText :: Parser Section
parseText = do
  xs <- many1 $ call <* optional newline
  return $ Text xs

parseAsm :: Parser Ast
parseAsm = do
  string "Let" <* newline
  d <- parseData
  string "In" <* newline
  t <- parseText
  eof
  return $ Ast (d, t)
