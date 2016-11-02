module Main where

import qualified Data.Map as Map
import System.IO
import System.Environment

import Text.Parsec
import Text.Parsec.String
import Control.Monad
import Control.Applicative hiding ((<|>), optional)

import Data.Word
import Data.Bits
import Data.Char
import Text.Printf

import Parse (parseAsm)
import AST
import Trans (transform)

hexAction :: Map.Map Action String
hexAction =
  Map.fromList $ zip [Load, Add, Mul, Bust] $ map show [1..]

trim :: String -> String
trim "" = ""
trim s@(x:xs)
  | isSpace x = trim xs
  | otherwise = s

p :: Int -> String
p n = trim $ printf "%4x" n

unwrap :: Maybe a -> a
unwrap Nothing = error "kernel panic!"
unwrap (Just x) = x

concats :: [String] -> String
concats = foldl (++) ""

hexData :: [Int] -> String
hexData = foldl (\acc x -> acc ++ (p x) ++ "\n") ""

extractData :: Section -> String
extractData (Data xs) =
  foldl (\acc (Bind (A _ _ meta) ns) ->
           -- & [$ $ $]
           acc ++ show meta ++ "\n" ++ hexData ns) "" xs

extractText :: Section -> String
extractText (Text xs) =
  foldl (\acc (Call act (A _ addr _)) ->
           concat [acc, unwrap $ Map.lookup act hexAction, p addr, "\n"]) "" xs

compile :: Ast -> (String, String)
compile (Ast (d, t)) = (extractData d, extractText t)

parseF' :: String -> IO ()
parseF' source = do
  ast <- parseFromFile parseAsm source
  let newAst = either (\_ -> Ast (Data [], Text [])) id ast in
    putStrLn $ show $ transform newAst

parseF :: String -> (String, String) -> IO ()
parseF source out = parseFromFile parseAsm source >>= \ast -> case ast of
  Left err -> error $ show err
  Right a -> writeF out $ (compile . transform) a

writeF :: (String, String) -> (String, String) -> IO ()
writeF (dataFile, textFile) (d, t) = do
  writeFile dataFile d
  writeFile textFile t

main :: IO ()
main = do
  (source:_) <- getArgs

  parseF source ("data.asm", "text.asm")
