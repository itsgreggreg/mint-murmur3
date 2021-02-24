module Murmur3 {
  /*
  Takes a seed and a string and produces a 32 bit hash.

  Given the same seed and string, it will always produce the same hash.

  ```mint
  Murmur3.hash32(1234, "Turn me into a hash") == 4138100590
  ```
  */
  fun hash32 (seed : Number, str : String) : Number {
    str
    |> Murmur3.Private.stringCodepointReduce(init, Murmur3.Private.hashFold)
    |> Murmur3.Private.finalize()
  } where {
    init =
      {
        shift = 0,
        seed = seed,
        hash = 0,
        charsProcessed = 0
      }
  }
}

/* Private data structure for computing a 32bit hash */
record Murmur3.Private.HashData {
  shift : Number,
  seed : Number,
  hash : Number,
  charsProcessed : Number
}

/*
Private internals of Murmur3, do not use these.

The public interface is in the `Murmur3` module.
*/
module Murmur3.Private {
  const C1 = 3432918353

  const C2 = 461845907

  /* 32-bit multiplication */
  fun multiplyBy (b : Number, a : Number) : Number {
    w + z
  } where {
    w =
      Bitwise.and(a, 65535) * b

    x =
      Bitwise.zeroFillRightShift(16, a) * b

    y =
      Bitwise.and((x), 65535)

    z =
      Bitwise.leftShift(16, y)
  }

  /*
   Given a 32bit int and an int representing a number of bit positions,
  returns the 32bit int rotated left by that number of positions.
  rotlBy : Int -> Int -> Int
  */
  fun rotlBy (b : Number, a : Number) : Number {
    Bitwise.or(
      (Bitwise.leftShift(b, a)),
      (Bitwise.zeroFillRightShift((32 - b), a)))
  }

  /* handles each char of the input string */
  fun hashFold (data : Murmur3.Private.HashData, char : Number) : Murmur3.Private.HashData {
    case (data.shift) {
      24 =>
        {
          shift = 0,
          seed = mix(data.seed, res),
          hash = 0,
          charsProcessed = data.charsProcessed + 1
        }

      =>
        {
          shift = data.shift + 8,
          seed = data.seed,
          hash = res,
          charsProcessed = data.charsProcessed + 1
        }
    }
  } where {
    res =
      char
      |> Bitwise.and(255)
      |> Bitwise.leftShift(data.shift)
      |> Bitwise.or(data.hash)
  }

  fun mix (h1 : Number, k1 : Number) : Number {
    res + 3864292196
  } where {
    res =
      k1
      |> multiplyBy(C1)
      |> rotlBy(15)
      |> multiplyBy(C2)
      |> Bitwise.xor(h1)
      |> rotlBy(13)
      |> multiplyBy(5)
  }

  fun finalize (data : Murmur3.Private.HashData) : Number {
    Bitwise.xor(h2, Bitwise.zeroFillRightShift(16, h2))
    |> Bitwise.zeroFillRightShift(0)
  } where {
    acc =
      if (data.hash == 0) {
        data.seed
      } else {
        data.hash
        |> multiplyBy(C1)
        |> rotlBy(15)
        |> multiplyBy(C2)
        |> Bitwise.xor(data.seed)
      }

    h0 =
      Bitwise.xor(acc, data.charsProcessed)

    h1 =
      Bitwise.xor(h0, Bitwise.zeroFillRightShift(16, h0))
      |> multiplyBy(2246822507)

    h2 =
      Bitwise.xor(h1, (Bitwise.zeroFillRightShift(13, h1)))
      |> multiplyBy(3266489909)
  }

  /*
  reduce over 32 bit codepoints of a string. handles joining surrogate pairs
   into a single codepoint
  */
  fun stringCodepointReduce (start : a, fn : Function(a, Number, a), str : String) : a {
    res[1]
  } where {
    res =
      String.split("", str)
      |> Array.reduce(
        {0, start},
        (acc : Tuple(Number, b), s : String) : Tuple(Number, b) {
          if (acc[0] == 0) {
            case (isSurrogatePair(s)) {
              {bool, num} =>
                if (bool) {
                  {num, acc[1]}
                } else {
                  {0, fn(acc[1], num)}
                }
            }
          } else {
            {0, fn(acc[1], joinSurrogatePair(acc[0], s))}
          }
        })
  }

  /* combines 16 bit surrogate pairs into a 32 bit integer */
  fun joinSurrogatePair (l : Number, r : String) : Number {
    (l - a) * b + c - d + e
  } where {
    a =
      (`0xD800` as Number)

    b =
      (`0x400` as Number)

    c =
      (`#{r}.charCodeAt(0)` as Number)

    d =
      (`0xDC00` as Number)

    e =
      (`0x10000` as Number)
  }

  /* determines if a character is the start of a 16 bit surrogate pair */
  fun isSurrogatePair (c : String) : Tuple(Bool, Number) {
    if ((`0xD800` as Number) <= code && code <= (`0xDBFF` as Number)) {
      {true, code}
    } else {
      {false, code}
    }
  } where {
    code =
      `#{c}.charCodeAt(0)` as Number
  }
}
