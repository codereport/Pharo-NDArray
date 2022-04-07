# <p align="center">Pharo-NDArray</p>

<p align="center">
    <a href="https://github.com/code_report/jsource/issues" alt="contributions welcome">
        <img src="https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat" /></a>
    <a href="https://lbesson.mit-license.org/" alt="MIT license">
        <img src="https://img.shields.io/badge/License-MIT-blue.svg" /></a>    
    <a href="https://pharo.org/">
        <img src="https://img.shields.io/badge/Pharo%20Smalltalk-10.0-ff69b4.svg"/></a>
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
* `triangleProduct:`
* `triangleProduct2:`
* `upperProduct:`
* `upperProduct2:`
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
* `/`
* `+`
* `-`
* `**`
* `<`
* `<=`
* `>`
* `>=`
* `=` (to be removed)
* `eq:`
* `min:`
* `max:`

### Verbs (Monadic)

* `all`
* `any`
* `asString`
* `first`
* `enlist`
* `indices`
* `ints`
* `invIota`
* `invWhere`
* `isEmpty`
* `last`
* `max`
* `maxs`
* `min`
* `mins`
* `mix`
* `negated`
* `ravel`
* `reverse`
* `size`
* `sort`
* `split`
* `sum`
* `sums`
* `transpose`
* `unique`
* `where`

### Verbs (Dyadic)

* `drop:`
* `filter:`
* `filterPred:`
* `gather:`
* `intersection:`
* `matches:`
* `memberOf:`
* `notMatches:`
* `partition:`
* `reshape:`
* `rotate:`
* `take:`
* `without:`

### Trains / Combinators

| | Smalltalk| Bird | Combinator | 
|:-:|:-:|:-:|:-:|
| ✔️| `and:with:atop:`|     blackbird | B1|
| ✔️| `and:with:backHook:`|||
| |`and:with:fork:and:`| golden eagle ||
| ✔️| `and:with:hook:`     |dove | D|
| ✔️ |`and:with:over:`     |psi | Psi
| |`dupWith:`           |warbler | W|
| |`dupWith:atop:`|||
| ✔️| `dupWith:backHook:`|
| |`dupWith:fork:and:`  |phoenix | S'|
| ✔️| `dupWith:hook:`      |starling | S|
| |`dupWith:over:`|
| |`flip:with:`         |cardinal | C|
| ✔️| `with:atop:` |bluebird | B|

✔️ means it has a symbol spelling below ⬇️


### Combinators (on Symbol / Block)

|Binary Symbol|M/D|Combinator| Bird| APL Name | BQN Name| J / I* Name |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|`<->`|Dyadic| D & _ | Dove & ___ | ___ & beside |before & after|hook & backHook*|
|`<*>`|Monadic|S & _ | Starling & ___ | | before & after | hook & backHook* |
|`<\|>`|Dyadic| B1 & Psi| Blackbird & Psi | atop & over | atop & over |atop & over |
