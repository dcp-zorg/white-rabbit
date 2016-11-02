{-# LANGUAGE OverloadedStrings #-}
module AST where

data Atom = A String Int Int
data Action = Load | Bust | Add | Mul deriving (Show, Eq, Ord)

data Call = Call Action Atom
data Bind = Bind Atom [Int]

data Ast = Ast (Section, Section)
data Section = Data [Bind] | Text [Call]

instance Show Call where
  show (Call act atom) = show act ++ " " ++ show atom

instance Show Atom where
  show (A name pos meta) =
    "<" ++ name ++ " &" ++ show meta ++ " @" ++ show pos ++ ">"

instance Show Bind where
  show (Bind atom xs) = show atom ++ " = " ++ show xs

instance Show Ast where
  show (Ast (d, t)) = show d ++ "\n" ++  show t

instance Show Section where
  show (Data bonds) = "Data\n" ++ unclash bonds
  show (Text calls) = "Text\n" ++ unclash calls

unclash :: (Show a) => [a] -> String
unclash [] = ""
unclash (x:xs) = (show x ++ "\n") ++ unclash xs
