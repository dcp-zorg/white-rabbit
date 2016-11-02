module Trans (transform) where
-- Why would you even read it

import qualified Data.Map as Map
import AST

-- & [$ $ $] where & is meta
malloc :: Int -> [Bind] -> [Bind]
malloc _ [] = []
malloc addr ((Bind (A name _ _) xs):bs) =
  (Bind (A name addr (length xs)) xs) : malloc (addr + length xs + 1) bs

inject :: Ast -> Ast
inject (Ast (Data bonds, Text calls)) =
  Ast (Data $ allocations , Text $ label allocations calls) where
  allocations = malloc 0 bonds

labels :: [Bind] -> Map.Map String Int
labels = Map.fromList . map (\(Bind (A name pos _) _) -> (name, pos))

label :: [Bind] -> [Call] -> [Call]
label bs =
  map (\(Call act (A name _ _)) -> Call act (A name (place name) 0))
  where
    place name = case Map.lookup name (labels bs) of
      -- Niche
      Nothing -> error $ name ++ "'s binding is absent"
      Just x -> x

-- Not implemented
checkDim :: Ast -> Ast
checkDim = id

checkAtoms :: Ast -> Ast
checkAtoms = id

check :: Ast -> Ast
check = checkDim . checkAtoms

transform :: Ast -> Ast
transform = inject . check
