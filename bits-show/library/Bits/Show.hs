module Bits.Show where

import Data.Bits
import GHC.Exts

class FixedWidthIntegral

showFiniteBits :: (FiniteBits bits, IsString string) => bits -> string
showFiniteBits x =
  fromString
    (
      fmap (showBit . testBit x)
        (takeWhile (>= 0)
          (
            iterate
              (\i -> i - 1)
              (finiteBitSize x - 1)
          )
        )
    )

showBit :: Bool -> Char
showBit x = case x of
    True -> '1'
    False -> '0'
