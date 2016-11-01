module Main where

--import Data.ByteString.Lazy as BL
--import Data.Binary.Put
import qualified Data.Map as Map
import GHC.Conc
import System.IO
import System.Environment
import Text.Parsec
import Text.Parsec.String
import Control.Monad
import Control.Applicative hiding ((<|>), optional)

import Data.Word
import Data.Bits
{-# LANGUAGE XOverloadedStrings #-}
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

pb :: Int -> String
pb n = trim $ printf "%4x" n

unwrap :: Maybe a -> a
unwrap Nothing = error "kernel panic!"
unwrap (Just x) = x

concats :: [String] -> String
concats = foldl (++) ""

hexData :: [Int] -> String
hexData = foldl (\acc x -> acc ++ (pb x) ++ "\n") ""

extractData :: Section -> String
extractData (Data xs) =
  foldl (\acc (Bind _ ns) -> acc ++ hexData ns) "" xs

extractText :: Section -> String
extractText (Text xs) =
  foldl (\acc (Ins act (A _ n)) ->
           concat [acc, unwrap $ Map.lookup act hexAction, pb n, "\n"]) "" xs

compile :: Ast -> (String, String)
compile (Ast (d, t)) = (extractData d, extractText t)

parseF :: String -> IO ()
parseF source = do
  ast <- parseFromFile parseAsm source
  putStrLn $ show ast
  case ast of
    Left err -> error $ show err
    Right a -> writeF ("data.asm", "res.asm") $ compile (transform a)

writeF :: (String, String) -> (String, String) -> IO ()
writeF (df, tf) (d, t) = do
  writeFile df d
  writeFile tf t

main :: IO ()
main = do
  (source:file:o:_) <- getArgs
  putStrLn ("% it's already on fire ( " ++ o ++ " ) %")

  parseF source
  putStrLn "that's all folks"
