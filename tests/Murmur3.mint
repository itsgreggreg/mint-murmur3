suite "Murmur3" {
  test "zero empty" {
    Murmur3.hash32(0, "") == 0
  }

  test "one empty" {
    Murmur3.hash32(1, "") == 1364076727
  }

  test "from docs" {
    Murmur3.hash32(1234, "Turn me into a hash") == 4138100590
  }

  test "the meaning of life" {
    Murmur3.hash32(42, "Life, the Universe, and Everything. There is an answer. But, I'll have to think about it.") == 150807855
  }

  test "negative seeds" {
    Murmur3.hash32(-42, "Life, the Universe, and Everything. There is an answer. But, I'll have to think about it.") == 2194656369
  }

  test "greek small letter pi" {
    Murmur3.hash32(2538058380, "ππππππππ") == 1592760651
  }

  test "cactus" {
    Murmur3.hash32(42, "🌵") == 1394327741
  }

  test "readme" {
    Murmur3.hash32(42, "Life, the Universe, and Everything.") == 458076548
  }
}
