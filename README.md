# <p align="center">Pharo-NDArray</p>

<p align="center">
    <a href="https://github.com/code_report/jsource/issues" alt="contributions welcome">
        <img src="https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat" /></a>
    <a href="https://lbesson.mit-license.org/" alt="MIT license">
        <img src="https://img.shields.io/badge/License-MIT-blue.svg" /></a>    
    <a href="https://pharo.org/">
        <img src="https://img.shields.io/badge/Pharo%20Smalltalk-9.0-ff69b4.svg"/></a>
    <a href="https://github.com/codereport?tab=followers" alt="GitHub followers">
        <img src="https://img.shields.io/github/followers/codereport.svg?style=social&label=Follow" /></a>
    <a href="https://GitHub.com/codereport/Pharo-NDArray/stargazers/" alt="GitHub stars">
        <img src="https://img.shields.io/github/stars/codereport/Pharo-NDArray.svg?style=social&label=Star" /></a>
    <a href="https://twitter.com/code_report" alt="Twitter">
        <img src="https://img.shields.io/twitter/follow/code_report.svg?style=social&label=@code_report" /></a>
</p>

Package for multidimensional arrays and common array programming language algorithms.

## Example
```smalltalk
NDArray withAll: 9 iota "Step 1"
   :> reshape: #(3 3)   "Step 2"
   :> + 10              "Step 3"
   :> reduce: #+        "Step 4"
   :> asArray           "Step 5"
```
Each step of the above code creates the following:
```smalltalk
"Step 1:"
1 2 3 4 5 6 7 8 9

"Step 2"
1 2 3
4 5 6
7 8 9

"Step 3"
11 12 13
14 15 16
17 18 19

"Step 4"
36 45 54

"Step 5"
36 45 54 "Array (no longer NDArray)"
```
## API

### Adverbs

* `collect:`
* `outerProduct:with:`
* `reduce:`
* `reduceFirst:`
* `scan:`
* `windowed:reduce:`

### Verbs (Scalar Monadic)

* `abs`
* `ceiling`
* `exp`
* `factorial`
* `floor`
* `invFactorial`
* `not`
* `reciprocal`
* `roll`
* `sign`

### Verbs (Scalar Dyadic)

* `%`
* `*`
* `+`
* `-`
* `<`
* `<=`
* `>`
* `>=`
* `=` (to be removed)
* `eq:`
* `min:`
* `max:`

### Verbs (Monadic)

* `asString`
* `first`
* `ints`
* `invIota`
* `invWhere`
* `mix`
* `ravel`
* `reverse`
* `size`
* `split`
* `sum`
* `transpose`
* `unique`
* `where`

### Verbs (Dyadic)

* `filter:`
* `filterPred:`
* `matches:`
* `memberOf:`
* `notMatches:`
* `partition:`
* `reshape:`
* `rotate:`
* `take:`
* `without:`

### Trains

* `hook:with:`
* `fork:with:with:`
