module Main where

import Data.List
import qualified Data.Map as Map

import System.Environment

vanEck = 0 : go [] vanEck
    where
        go prev (x:xs) =
            case findIndex (== x) prev of
                Nothing -> 0 : go (x:prev) xs
                Just i -> (i + 1) : go (x:prev) xs

runSearch xs = runSearch' 0 0 Map.empty xs
    where
        runSearch' _ termN _ [] = putStrLn $ "\rRan out of terms at term " ++ show termN ++ ", stopping search."
        runSearch' i termN m (x:xs) =
            let newMap = Map.insertWith const x termN m in
            case Map.lookup i m of
                Nothing -> do
                    putStr $ "\rSearching for " ++ show i ++ ", term " ++ show termN
                    runSearch' i (termN + 1) newMap xs
                Just v -> do
                    putStrLn $ "\rFound " ++ show i ++ ", term " ++ show v ++ "                         "
                    runSearch' (i + 1) (termN + 1) newMap xs

findAll values xs = findAll' values xs 0
    where
        findAll' _ [] _ = pure (-1) -- This will never happen with an infinite sequences

        findAll' [] _ i = pure i
        findAll' values (x:xs) i = do
            let l = length values
            if l < 20 then
                putStrLn $ "Term " ++ show i ++ ", missing (" ++ show l ++ "): " ++ show values
            else
                putStrLn $ "Term " ++ show i ++ ", missing (" ++ show l ++ ")"
            findAll' (filter (/= x) values) xs (i + 1)


main = do
    args <- getArgs

    case args of
        ["search"] -> runSearch vanEck
        ["search", fname] -> runSearch =<< (map read . lines <$> readFile fname)
        ["seq"] -> mapM_ print vanEck
        ["uniq", "seq"] -> mapM_ print $ nub vanEck
        [nStr] -> print =<< findAll [1..read nStr] vanEck
        [fname, nStr] -> print =<< findAll [1..read nStr] =<< (map read . lines <$> readFile fname)
        _ -> putStrLn "Usage: VanEck SEARCH_BOUND"

