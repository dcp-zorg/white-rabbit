module AST where

data Atom = A String Int deriving Show
data Action = Load | Bust | Add | Mul deriving (Show, Eq, Ord)

data Ins = Ins Action Atom deriving Show
data Bind = Bind Atom [Int] deriving Show

data Ast = Ast (Section, Section) deriving Show
data Section = Data [Bind] | Text [Ins] deriving Show
