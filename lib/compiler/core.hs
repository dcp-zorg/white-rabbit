module Main where

--import Data.ByteString.Lazy as BL
--import Data.Binary.Put
import GHC.Conc
import System.IO
import System.Environment

--import Text.ParserCombinators.Parsec
import Text.Parsec
import Text.Parsec.String
import Control.Monad
import Control.Applicative hiding ((<|>), optional)

--parseExpr :: Parser Val
--parseExpr = parseAtom <|> parseNumber

data Atom = A String Int deriving Show
data Op = Load | Bust | Add | Mul deriving Show

data Ins = Ins Op Atom
data Bind = Bind Atom [Int] deriving Show

data Ast = Ast [Section]
data Section = Data [Bind] | Text [Ins]

int :: Parser Int
int = liftM read $ many1 digit

atom :: Parser Atom
atom = do
  symbol <- many1 letter
  return $ A symbol 0

bind :: Parser Bind
bind = do
  a <- atom
  spaces
  xs <- char '[' *> int `sepBy1` spaces <* char ']'

  return $ Bind a xs

parseFile :: Parser Ast
parseFile = do
  return $ Ast [Data [Bind (A "xs" 0) [1, 2, 3]]]

transform :: Ast -> String
transform _ = "got you"

main :: IO ()
main = do
  (source:file:o:_) <- getArgs
  putStrLn ("% it's already on fire ( " ++ o ++ " ) %")
  result <- parseFromFile parseFile source
  case result of
    Left err -> error $ "malformed file " ++ show err
    Right ast -> writeFile file $ transform ast

  putStrLn "that's all folks"
