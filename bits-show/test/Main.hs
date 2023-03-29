import Test.Hspec

import Bits.Show
import Data.Int
import Data.Word

main = hspec $ do
  describe "showFiniteBits" $ do
    it "Word8"  $ showFiniteBits @Word8    2  `shouldBe` "00000010"
    it "Int8+"  $ showFiniteBits @Int8     2  `shouldBe` "00000010"
    it "Int8-"  $ showFiniteBits @Int8   (-2) `shouldBe` "11111110"
    it "Word16" $ showFiniteBits @Word16   2  `shouldBe` "0000000000000010"
    it "Int16+" $ showFiniteBits @Int16    2  `shouldBe` "0000000000000010"
    it "Int16-" $ showFiniteBits @Int16  (-2) `shouldBe` "1111111111111110"
    it "Word32" $ showFiniteBits @Word32   2  `shouldBe` "00000000000000000000000000000010"
    it "Int32+" $ showFiniteBits @Int32    2  `shouldBe` "00000000000000000000000000000010"
    it "Int32-" $ showFiniteBits @Int32  (-2) `shouldBe` "11111111111111111111111111111110"
    it "Word64" $ showFiniteBits @Word64   2  `shouldBe` "0000000000000000000000000000000000000000000000000000000000000010"
    it "Int64+" $ showFiniteBits @Int64    2  `shouldBe` "0000000000000000000000000000000000000000000000000000000000000010"
    it "Int64-" $ showFiniteBits @Int64  (-2) `shouldBe` "1111111111111111111111111111111111111111111111111111111111111110"
