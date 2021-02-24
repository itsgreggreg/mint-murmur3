# Murmur3

Murmur3 32 bit hash in [Mint](https://mint-lang.org).

This is not a cryptographically safe hash. It is just a quick, short, stable hash
for relatively short strings.

For any given seed and string the hash will always be the same.

## Installation

Add this to your application's `mint.json`:

```json
"dependencies": {
  "bitwise": {
    "repository": "https://github.com/itsgreggreg/mint-murmur3",
    "constraint": "0.1.0 <= v < 1.0.0"
  }
}
```

## Example Usage

This package adds a `Murmur3` module with the function `hash32`.

```mint
/* The first paramater is the seed, the second is the string to hash */
Murmur3.hash32(42, "Life, the Universe, and Everything.") == 458076548
```
