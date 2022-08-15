Class {
	#name : #PharoNDArrayTest,
	#superclass : #TestCase,
	#traits : 'ComposeSyntax',
	#classTraits : 'ComposeSyntax classTrait',
	#category : #'Pharo-NDArray-Tests'
}

{ #category : #tests }
PharoNDArrayTest >> assert: actual equals: expected [
   expected isArray ifTrue: [ ^ super assert: actual asArray equals: expected ].
   expected isBoolean ifTrue: [ ^ super assert: actual asBoolean equals: expected ].
   expected isInteger ifTrue: [ ^ super assert: actual asInteger equals: expected ].
   expected class = NDArray ifTrue: [ 
	    "Note: all this code in the isNested block can be deleted when bug is fixed"
      expected isNested ifTrue: [ 
         actual isNested ifFalse: [ ^ self assert: false ].
         actual size = expected size ifFalse: [ ^ self assert: false ].
         ^ self assert: (actual data with: expected data collect: [ :a :b | a data = b data and: (a shape = b shape) ] 
             :> allSatisfy: #yourself) ].
      ^ self assert: (actual data = expected data and: (actual shape = expected shape)) ].
   ^ super assert: actual equals: expected
]

{ #category : #tests }
PharoNDArrayTest >> testAOC2021Day1 [
	| test |
	test := #(199 200 208 210 200 207 240 269 260 263).
   self assert: ((test asNDArray windowed: 2 reduce: #<) ints sum) equals: 7.
   self assert: (((test asNDArray windowed: 3 reduce: #+) windowed: 2 reduce: #<) ints sum) equals: 5

]

{ #category : #tests }
PharoNDArrayTest >> testAbsoluteValue [
   self assert: (NDArray withAll: #(1 -2 3)) abs equals: #(1 2 3).
   self assert: (NDArray withAll: #(#(-1 -2 -3) #(4 5 6))) abs ravel equals: 6 iota asNDArray.
   self assert: (NDArray withAll: #(#(1 2 3) #(-4 -5 -6))) abs equals: #(#(1 2 3) #(4 5 6)).
]

{ #category : #tests }
PharoNDArrayTest >> testAllAsBeforeBs [	
	| orScanEqualsId |
	orScanEqualsId := [ :s | s dupWith: [ :x | x scan: #or: ] fork: #matches: and: #yourself ].
   "Using blocks"
   self assert: ('aaabbb' asNDArray = $b) (orScanEqualsId).
   self deny: ('abab' asNDArray = $b) (orScanEqualsId).
   self assert: ('bbb' asNDArray = $b) (orScanEqualsId).
   "Not using blocks"
   self assert: (('aaabbb' asNDArray = $b) dupWith: [ :x | x scan: #or: ]	 fork: #matches: and: #yourself).
   self deny: (('abab' asNDArray = $b) dupWith: [ :x | x scan: #or: ] fork: #matches: and: #yourself).
   self assert: (('bbb' asNDArray = $b) dupWith: [ :x | x scan: #or: ] fork: #matches: and: #yourself).
   "Using after"
   self assert: (('aaabbb' asNDArray = $b) dupWith: #matches: <->	#or: scan). 
   
]

{ #category : #tests }
PharoNDArrayTest >> testAllAsBeforeBs2 [
	self assert: (('aaabbb' asNDArray = $b) dupWith: #matches: <->	#or: scan). 
   self assert: (('aaabbb' asNDArray = $b) dupWith: [ :x | x scan: #or: ]	 fork: #matches: and: #yourself).
	
	"	this is beside in APL, the question is do we want it to be instead after in BQN (aka we don't need selfie. would reult in 	"
   "self deny: (('abab' asNDArray = $b) fork: [ :x | x scan: #or: ] with: #matches: with: #yourself).
   self assert: (('bbb' asNDArray = $b) fork: [ :x | x scan: #or: ] with: #matches: with: #yourself).
   self assert: (orScanEqualsId value: ('aaabbb' asNDArray = $b)).
   self deny: (('abab' asNDArray = $b) fork: [ :x | x scan: #or: ] with: #matches: with: #yourself).
   self assert: (('bbb' asNDArray = $b) fork: [ :x | x scan: #or: ] with: #matches: with: #yourself)."

]

{ #category : #tests }
PharoNDArrayTest >> testAllEqual [
   | v u |
   v := #(1 2 3 4) asNDArray.
   u := #(1 1 1 1) asNDArray.
   self assert: (v eq: v first) all equals: false.
   self assert: v unique size = 1 equals: false.
   self assert: v max = v min equals: false.
   self assert: (v windowed: 2 reduce: #=) all equals: false.
   self assert: ((v rotate: 1) matches: v) equals: false.
   self assert: (u eq: u first) all equals: true.
   self assert: u unique size = 1 equals: true.
   self assert: u max = u min equals: true.
   self assert: (u dupWith: #max fork: #= and: #min) equals: true.
   self assert: (u windowed: 2 reduce: #=) all equals: true.
   self assert: ((u rotate: 1) matches: u) equals: true
]

{ #category : #tests }
PharoNDArrayTest >> testArraySign [
   self assert: (#(1 -1 2 -3) asNDArray sign reduce: #*) equals: 1.
   self assert: (#(1 -1 2 -3 -4) asNDArray sign reduce: #*) equals: -1.
   self assert: ((9 iota asNDArray - 5) sign reduce: #*) equals: 0
]

{ #category : #tests }
PharoNDArrayTest >> testCeiling [
   self assert: (NDArray withAll: #(1 -2.2 3.6)) ceiling equals: #(1 -2 4).
   self assert: (NDArray withAll: #(#(-1.1 -2 -3.6) #(4.4 5.5 6.7))) ceiling equals: #(#(-1 -2 -3) #(5 6 7)).
]

{ #category : #tests }
PharoNDArrayTest >> testCheckIfPangram [
	"Problem Link: https://leetcode.com/problems/check-if-the-sentence-is-pangram/	"
	| a b alpha |
	a := 'thequickbrownfoxjumpsoverthelazydog' asNDArray.
	b := 'leetcode' asNDArray.
	alpha := Character alphabet asNDArray.
	self assert: (alpha memberOf: a) all equals: 1.
	self assert: (alpha memberOf: b) all equals: 0
]

{ #category : #tests }
PharoNDArrayTest >> testCombinatorAtop [ 
	"The Blackbird"

   "Example #1: Test if two sequences are mutually exclusive"
   "Not using combinators"
   self deny: (#(1 2 3) intersection: #(2 3 4)) isEmpty.
   self assert: (#(1 2 3) intersection: #(4 5 6)) isEmpty.
	"Using combinators"
   self deny: #(1 2 3) (#isEmpty <|> #intersection:): #(2 3 4).
   self assert: #(1 2 3) (#isEmpty <|> #intersection:): #(4 5 6)

]

{ #category : #tests }
PharoNDArrayTest >> testCombinatorOver [
	"The Psi Bird"

   "Example #1: Test the difference in length of string"
   "Not using combinators"
   self assert: (('mouse' size) - ('cat' size)) equals: 2.
	"Using combinators"
   self assert: ('mouse' (#- <|> #size): 'cat') equals: 2.

	"Example #2: Test if strings are anagrams"
	"Not using combinators"
	self deny: (('horse' sorted) = ('cat' sorted)).
   self assert: (('horse' sorted) = ('shore' sorted)).
	"Using combinators"
   self deny: 'horse' (#= <|> #sorted): 'cat'.
   self assert: 'horse' (#= <|> #sorted): 'shore'

]

{ #category : #tests }
PharoNDArrayTest >> testContainsDuplicates [
   "Leetcode Problem 217 https://leetcode.com/problems/contains-duplicate/"
   | arr |
   arr := #(1 2 3 1) asNDArray.
   self assert: (arr dupWith: #unique fork: #notMatches: and: #yourself) equals: true.
   self assert: ((arr uniqueMask not eq: 1) reduce: #or:) equals: true.
   self assert: (arr dupWith: (#unique <-> #notMatches:)) equals: true.
   self assert: (arr dupWith: (#notMatches: <-> #unique)) equals: true.
]

{ #category : #tests }
PharoNDArrayTest >> testCountKDifference [
   "Problem Link: https://leetcode.com/problems/count-number-of-pairs-with-absolute-difference-k/"
   | a b c |
   a := #(1 2 2 1) asNDArray.
   b := #(1 3) asNDArray.
   c := #(3 2 1 5 4) asNDArray.

   self assert: ((a outerProduct: a with: #-) eq: 1) ravel sum equals: 4.
   self assert: ((b outerProduct: b with: #-) eq: 3) ravel sum equals: 0.
   self assert: ((c outerProduct: c with: #-) eq: 2) ravel sum equals: 3
]

{ #category : #tests }
PharoNDArrayTest >> testCountNegativeNumbers [
   "Problem Link: https://leetcode.com/problems/count-negative-numbers-in-a-sorted-matrix/"
   | a b c d |
   a := #(#(4 3 2 -1) #(3 2 1 -1) #(1 1 -1 -2) #(-1 -1 -2 -3)) asNDArray.
   b := #(#(3 2) #(1 0)) asNDArray.
   c := #(#(1 -1) #(-1 -1)) asNDArray.
   d := #(#(-1)) asNDArray.
   self assert: (a ravel < 0) sum equals: 8.
   self assert: (b ravel < 0) sum equals: 0.
   self assert: (c ravel < 0) sum equals: 3.
   self assert: (d ravel < 0) sum equals: 1
]

{ #category : #tests }
PharoNDArrayTest >> testDisjointSets [
   "Problem Link: https://theweeklychallenge.org/blog/perl-weekly-challenge-127/"
   | a b c d |
   a := #(4 6 7 8 9) asNDArray.
   b := #(1 2 5 3 4) asNDArray.
   c := #(0 2 4 6 8) asNDArray.
   d := #(1 3 5 7 9) asNDArray.

   self assert: (a intersection: b) isEmpty equals: false.
   self assert: (c intersection: d) isEmpty equals: true.
   self assert: (a and: b with: #isEmpty atop: #intersection:) equals: false.
   self assert: (c and: d with: #isEmpty atop: #intersection:) equals: true
]

{ #category : #tests }
PharoNDArrayTest >> testDivides [
   self assert: (NDArray withAll: #(1 2 3)) / 2  equals: {(1/2). 1. (3/2)}.
   self assert: (NDArray withAll: #(#(2 4 6) #(8 10 12))) / 2  equals: #(#(1 2 3) #(4 5 6)).
   self assert: (NDArray withAll: #(#(1 2 3) #(4 5 6))) / 1  equals: #(#(1 2 3) #(4 5 6))
]

{ #category : #tests }
PharoNDArrayTest >> testEquals [
   self assert: (NDArray withAll: #(1 2 3)) = 1 equals: #(1 0 0).
   self assert: 1 = (NDArray withAll: #(1 2 3)) equals: #(1 0 0).
   self assert: (NDArray withAll: #(#(1 2 3) #(1 2 3))) = 2 equals: #(#(0 1 0) #(0 1 0)).
   self assert: (NDArray withAll: #(#(1 2) #(4 5))) = 5 equals: #(#(0 0) #(0 1)).
   self assert: 'hello' asNDArray = $l equals: #(0 0 1 1 0).
   self assert: ('hello' asNDArray = $l) equals: #(0 0 1 1 0).
   self assert: true asInteger equals: 1.
   self assert: false asInteger equals: 0.
   self assert: ('()(())' asNDArray = $() equals: #(1 0 1 1 0 0).
   self assert: (2 = #(1 2 3) asNDArray) equals: #(0 1 0).
   self assert: (1 asNDArray = 3 iota asNDArray) equals: #(1 0 0)
   "self assert: (2 asNDArray = #(1 2 3)) ints equals: #(0 1 0)"
   "self assert: #(1 2 3) asNDArray = #(0 2 3) asNDArray equals: #(false true true)"
]

{ #category : #tests }
PharoNDArrayTest >> testExp [
   self assert: ((NDArray withAll: #(1 -2 3)) exp * 100) floor equals: #(271 13 2008).
]

{ #category : #tests }
PharoNDArrayTest >> testFactorial [
   self assert: (NDArray withAll: #(1 2 3)) factorial equals: #(1 2 6).
   self assert: (NDArray withAll: #(#(1 2 3) #(4 5 6))) factorial ravel equals: #(1 2 6 24 120 720).
   self assert: (NDArray withAll: #(#(1 2 3) #(4 5 6))) factorial equals: #(#(1 2 6) #(24 120 720)).
   self should: [ (NDArray withAll: #(#(1 2 3) #(-4 -5 -6))) factorial ] raise: DomainError
]

{ #category : #tests }
PharoNDArrayTest >> testFilter [
   | arr |
   self assert: (NDArray withAll: #(1 3)) equals: #(1 3).
   self assert: ((NDArray withAll: #(1 2 3)) filter: #(true false true)) equals: #(1 3).
   arr := #(1 2 3) asNDArray.
   self assert: (arr filter: arr % 2) equals: #(1 3)
]

{ #category : #tests }
PharoNDArrayTest >> testFinalPricesWithDiscount [
   "Problem Link: https://leetcode.com/problems/final-prices-with-a-special-discount-in-a-shop/"
   | a b c |
   a := #(8 4 6 2 3) asNDArray.
   b := #(1 2 3 4 5) asNDArray.
   c := #(10 1 1 6) asNDArray.
   self
      assert:
         a - (a gather: ((a upperProduct: #>=) collect: [ :e | 
                 ((e indices without: 0) , 0) first ]))
      equals: #(4 2 4 2 3).
   self
      assert:
         b - (b gather: ((b upperProduct: #>=) collect: [ :e | 
                 ((e indices without: 0) , 0) first ]))
      equals: b.
   self
      assert:
         c - (c gather: ((c upperProduct: #>=) collect: [ :e | 
                 ((e indices without: 0) , 0) first ]))
      equals: #(9 0 1 6)
]

{ #category : #tests }
PharoNDArrayTest >> testFinalValue [
   "Problem Link: https://leetcode.com/problems/final-value-of-variable-after-performing-operations/"
   | a b c |
   a := #('--x' 'x++' '++x') asNDArray.
   b := #('++x' 'x++' '++x') asNDArray.
   c := #('--x' 'x++' '++x' 'x--') asNDArray.

   self assert: (('+-' outerProduct: a with: #memberOf:) reduceFirst: #-) sum equals: 1.
   self assert: (('+-' outerProduct: b with: #memberOf:) reduceFirst: #-) sum equals: 3.
   self assert: (('+-' outerProduct: c with: #memberOf:) reduceFirst: #-) sum equals: 0
]

{ #category : #tests }
PharoNDArrayTest >> testFindDisappearedNumbers [
   "LeetCode Problem Link: https://leetcode.com/problems/find-all-numbers-disappeared-in-an-array/"
   self
      assert: (#(4 3 2 7 8 2 3 1) asNDArray dupWith: [ :e | 
             e size iota asNDArray ]
             fork: #memberOf:
             and: #yourself) not indices
      equals: #(5 6)
]

{ #category : #tests }
PharoNDArrayTest >> testFindGCD [
   "Leetcode Problem 255 https://leetcode.com/problems/find-greatest-common-divisor-of-array/"
   | findGCD |
   findGCD := [ :arr | arr asNDArray dupWith: [ :e | e reduce: #max: ] fork: [ :a :b | a gcd: b ] and: [ :e | e reduce: #min: ] ].
   self assert: #(2 5 6 7 10) (findGCD) equals: 2.
   self assert: #(3 5 6 7 8) (findGCD) equals: 1.
   self assert: #(3 3) (findGCD) equals: 3
]

{ #category : #tests }
PharoNDArrayTest >> testFindLucky [
   "LeetCode Problem: https://leetcode.com/problems/find-lucky-integer-in-an-array/"
   | a b c d e |
   a := #(2 2 3 4) asNDArray.
   b := #(1 2 2 3 3 3) asNDArray.
   c := #(2 2 2 3 3) asNDArray.
   d := #(5) asNDArray.
   e := #(7 7 7 7 7 7 7) asNDArray.
   self assert: ((a filter: ((a outerProduct: a with: #=) sum eq: a)) reduce: #max:) equals: 2.
   self assert: ((b filter: ((b outerProduct: b with: #=) sum eq: b)) reduce: #max:) equals: 3.
   self assert: ((c filter: ((c outerProduct: c with: #=) sum eq: c)), -1 reduce: #max:) equals: -1.
   self assert: ((d filter: ((d outerProduct: d with: #=) sum eq: d)), -1 reduce: #max:) equals: -1.
   self assert: ((e filter: ((e outerProduct: e with: #=) sum eq: e)) reduce: #max:) equals: 7
]

{ #category : #tests }
PharoNDArrayTest >> testFirst [
   self assert: (NDArray withAll: #(1 2 3)) first equals: 1.
   self assert: (NDArray withAll: #(#(1 2 3) #(1 2 3))) first equals: 1.
   self assert: (NDArray withAll: #(#(1 2) #(4 5))) first equals: 1
]

{ #category : #tests }
PharoNDArrayTest >> testFirstUniqueCharacher [
   | a b c d |
   a := #(1 3) asNDArray.
   self assert:
      (((a outerProduct: a with: #=) reduce: #+) eq: 1) indices first
      - 1
      equals: 0.
   b := #(1 3 1 3 2 5 5).
   self assert:
      (((b outerProduct: b with: #=) reduce: #+) eq: 1) indices first
      - 1
      equals: 4.
   c := #(1 3 2 5 2 5 4 1).
   self assert:
      (((c outerProduct: c with: #=) reduce: #+) eq: 1) indices first
      - 1
      equals: 1.
   d := #(1 3 2 5 2 5 4 1 3).
   self assert:
      (((d outerProduct: d with: #=) reduce: #+) eq: 1) indices first
      - 1
      equals: 6
]

{ #category : #tests }
PharoNDArrayTest >> testFloor [
   self assert: (NDArray withAll: #(1 -2.2 3.6)) floor equals: #(1 -3 3).
   self assert: (NDArray withAll: #(#(-1.1 -2 -3.6) #(4.4 5.5 6.7))) floor equals: #(#(-2 -2 -4) #(4 5 6)).
]

{ #category : #tests }
PharoNDArrayTest >> testFork [
   self assert: (#(1 2 3) asNDArray dupWith: #yourself fork: #= and: #first) equals: #(1 0 0).
   self assert: (#(1 2 3) asNDArray dupWith: #first fork: [ :a :b | b = a ] and: #yourself) equals: #(1 0 0)
   "                                                   ^^^^^^^^^^^^^^^^^ TODO: need to think about this"
]

{ #category : #tests }
PharoNDArrayTest >> testFourWords [
   | arr |
   arr := 'I love APL. It is my favorite' asNDArray.
   "this is technically wrong"
   self assert: (arr filter: (((arr eq: Character space) ints scan: #+) < 3)) asString equals: 'I love APL.'
]

{ #category : #tests }
PharoNDArrayTest >> testGreaterThan [
   self assert: ((NDArray withAll: #(1 2 3)) > 1) not equals: #(1 0 0).
   self assert: (1 > (NDArray withAll: #(1 2 3))) not equals: #(1 1 1).
   self assert: ((NDArray withAll: #(#(1 2 3) #(1 2 3))) > 2) not equals: #(#(1 1 0) #(1 1 0)).
   self assert: ((NDArray withAll: #(#(1 2) #(4 5))) > 5) not equals: #(#(1 1) #(1 1)).
   self assert: (2 < #(1 2 3) asNDArray) equals: #(0 0 1)
   "self assert: 1 asNDArray <= 3 iota asNDArray equals: #(1 0 0) TODO fixme"
]

{ #category : #tests }
PharoNDArrayTest >> testHook [
	self assert: (#(1 2 1) asNDArray dupWith: #= hook: #reverse) equals: true. "palindrome"
	self assert: (#(1 2 1) asNDArray dupWith: #= hook: #reverse) equals: 1 "palindrome"
]

{ #category : #tests }
PharoNDArrayTest >> testInverseFactorial [
   self assert: 720 invFactorial equals: 6.
   self assert: #(720 24 120) asNDArray invFactorial equals: #(6 4 5).
   self should: [ 343 invFactorial ] raise: DomainError.
   self should: [ #(1 2 343) asNDArray invIota ] raise: DomainError.
   self assert: 12 iota asNDArray factorial invFactorial equals: 12 iota asNDArray
]

{ #category : #tests }
PharoNDArrayTest >> testInverseIota [
   self assert: #(1 2 3) asNDArray invIota equals: 3.
   self should: [ #(2 3 4) asNDArray invIota ] raise: DomainError.
   self should: [ #(1 3 4) asNDArray invIota ] raise: DomainError.
   self assert: 100 iota asNDArray invIota equals: 100
]

{ #category : #tests }
PharoNDArrayTest >> testInverseWhere [
   self assert: #(1 3) asNDArray invWhere equals: #(1 0 1).
   self assert: (#(1 3) asNDArray invWhere take: 4) equals: #(1 0 1 0).
   "self assert: ((5 iota asNDArray * 2 - 1) inverseWhere take: 10) equals: 10 iota asNDArray % 2.
   self assert: (4 iota asNDArray partitionedEnclose: #(1 0 1 0) asNDArray) mix equals: #(#(1 2) #(3 4)) asNDArray"
]

{ #category : #tests }
PharoNDArrayTest >> testLessThanOrEqualTo [
   self assert: (NDArray withAll: #(1 2 3)) <= 1 equals: #(1 0 0).
   self assert: 1 <= (NDArray withAll: #(1 2 3)) equals: #(1 1 1).
   self assert: (NDArray withAll: #(#(1 2 3) #(1 2 3))) <= 2 equals: #(#(1 1 0) #(1 1 0)).
   self assert: (NDArray withAll: #(#(1 2) #(4 5))) <= 5 equals: #(#(1 1) #(1 1)).
   self assert: 2 <= #(1 2 3) asNDArray equals: #(0 1 1).
   self assert: 1 asNDArray <= 3 iota asNDArray equals: #(1 1 1)
]

{ #category : #tests }
PharoNDArrayTest >> testMatches [
   self assert: (1 asNDArray matches: 1).
   self deny: ((NDArray withAll: #(1 2 3)) matches: 1).
   self assert: ((NDArray withAll: #(1 2 3)) matches: #(1 2 3)).
   self assert: ((NDArray withAll: #(1 2 3)) matches: 3 iota asNDArray).
   self deny: ((NDArray withAll: #(#(1 2 3) #(1 2 3))) matches: #(1 2 3) asNDArray).
   self assert: ((NDArray withAll: #(#(1 2 3) #(1 2 3))) matches: (3 iota asNDArray reshape: #(2 3)))
]

{ #category : #tests }
PharoNDArrayTest >> testMax [
   self assert: ((NDArray withAll: #(1 2 3)) max: 2) equals: #(2 2 3).
   self assert: ((NDArray withAll: #(#(1 2 3) #(4 5 6))) max: 3) ravel equals: #(3 3 3 4 5 6).
   "self assert: (2 min: (NDArray withAll: #(1 2 3))) equals: #(1 2 2).
   self assert: 10 + ((NDArray withAll: #(#(1 2 3) #(4 5 6)))) ravel equals: (6 iota collect: 10 @@ #+).
   self assert: 10 + (NDArray withAll: #(#(1 2 3) #(4 5 6))) equals: #(#(11 12 13) #(14 15 16))"
]

{ #category : #tests }
PharoNDArrayTest >> testMaxConsecutiveOnes [
   | arr |
   arr := #(1 1 0 0 1 1 1 0 1 1 1 1 0 0 0) asNDArray.
   self assert: (((arr partition: arr) collect: [ :e | e reduce: #+ ]) reduce: #max:) equals: 4.

]

{ #category : #tests }
PharoNDArrayTest >> testMaxSubArray [
   "Leetcode Problem 53 https://leetcode.com/problems/maximum-subarray/"
   self assert: ((#(-2 1 -3 4 -1 2 1 -5 4) asNDArray scan: [ :a :b | a + b max: b ]) reduce: #max:) equals: 6.
   self assert: ((#(5 4 -1 7 8) asNDArray scan: [ :a :b | a + b max: b ]) reduce: #max:) equals: 23.
   self assert: ((#(1) asNDArray scan: [ :a :b | a + b max: b ]) reduce: #max:) equals: 1.
   self assert: ((#(-2) asNDArray scan: [ :a :b | a + b max: b ]) reduce: #max:) equals: -2
]

{ #category : #tests }
PharoNDArrayTest >> testMaxWealth [
   self assert: (((9 iota asNDArray reshape: #(3 3)) reduce: #+) reduce: #max:) equals: 24.
   self assert: (((10 asNDArray reshape: #(3 3)) reduce: #+) reduce: #max:) equals: 30.
   self assert: (((9 iota asNDArray reshape: #(3 3)) transpose reduce: #+) reduce: #max:) equals: 18
]

{ #category : #tests }
PharoNDArrayTest >> testMaximumDiffBetweenIncreasingElements [
   "Problem Link: https://leetcode.com/contest/weekly-contest-260/problems/maximum-difference-between-increasing-elements/"
   | a b c |
   a := #(7 1 5 4) asNDArray.
   b := #(1 5 2 10) asNDArray.
   c := #(9 5 3 2) asNDArray.

   self assert: (a triangleProduct: #-) enlist negated max equals: 4.
   self assert: (b triangleProduct: #-) enlist negated max equals: 9.
   self assert: (a dupWith: #- hook: #scan: @@ #min: :> without: 0 :> , -1 :> max) equals: 4.
   self assert: (b dupWith: #- hook: #scan: @@ #min: :> without: 0 :> , -1 :> max) equals: 9.
   self assert: (c dupWith: #- hook: #scan: @@ #min: :> without: 0 :> , -1 :> max) equals: -1.
   self assert: (a dupWith: #- hook: #mins :> without: 0 :> , -1 :> max) equals: 4.
   self assert: (b dupWith: #- hook: #mins :> without: 0 :> , -1 :> max) equals: 9.
   self assert: (c dupWith: #- hook: #mins :> without: 0 :> , -1 :> max) equals: -1
]

{ #category : #tests }
PharoNDArrayTest >> testMin [
   self assert: ((NDArray withAll: #(1 2 3)) min: 1) equals: #(1 1 1).
   self assert: ((NDArray withAll: #(#(1 2 3) #(4 5 6))) min: 3) ravel equals: #(1 2 3 3 3 3).
   "self assert: (2 min: (NDArray withAll: #(1 2 3))) equals: #(1 2 2).
   self assert: 10 + ((NDArray withAll: #(#(1 2 3) #(4 5 6)))) ravel equals: (6 iota collect: 10 @@ #+).
   self assert: 10 + (NDArray withAll: #(#(1 2 3) #(4 5 6))) equals: #(#(11 12 13) #(14 15 16))"
]

{ #category : #tests }
PharoNDArrayTest >> testMix [
   self assert: (4 iota asNDArray partition: #(1 0 1 0)) mix equals: #(#(1) #(3)) asNDArray.
   self assert: (4 iota asNDArray partition: #(1 1 0 1)) mix equals: #(#(1 2) #(4 0)) asNDArray
   "self assert: (4 iota asNDArray partitionedEnclose: #(1 0 1 0) asNDArray) mix equals: #(#(1 2) #(3 4)) asNDArray"
]

{ #category : #tests }
PharoNDArrayTest >> testModulus [
   self assert: (NDArray withAll: #(1 2 3)) % 2  equals: #(1 0 1).
   self assert: (NDArray withAll: #(#(1 2 3) #(4 5 6))) % 4  equals: #(#(1 2 3) #(0 1 2)).
   self assert: (NDArray withAll: #(#(1 2 3) #(4 5 6))) % 3  equals: #(#(1 2 0) #(1 2 0))
]

{ #category : #tests }
PharoNDArrayTest >> testMultipleVerbs [
   self assert: (#(1 0) outerProduct: #(1 0 1 1 0 0) with: #=
      :> ints 
      :> reduceFirst: #-
      :> scan: #+) equals: #(1 0 1 2 1 0).
   self assert: (#(1 0) outerProduct: #(1 0 1 1 0 0) with: #=
      :> ints 
      :> reduceFirst: #-
      :> scan: #+
      :> reduce: #max:) equals: 2.
   "self assert: ('()' outerProduct: '()(())' with: #=) ints equals: #(#(1 0 1 1 0 0) #(0 1 0 0 1 1))"
]

{ #category : #tests }
PharoNDArrayTest >> testNot [
   self assert: #(1 0 1 0 1) asNDArray not equals: #(0 1 0 1 0).
   self assert: #(true false true) asNDArray not equals: #(0 1 0).
   self should: [ #(1 2 3) asNDArray not ] raise: DomainError
   
]

{ #category : #tests }
PharoNDArrayTest >> testNotMatches [
   self deny: (1 asNDArray notMatches: 1).
   self assert: ((NDArray withAll: #(1 2 3)) notMatches:1).
   self deny: ((NDArray withAll: #(1 2 3)) notMatches: #(1 2 3)).
   self deny: ((NDArray withAll: #(1 2 3)) notMatches: 3 iota asNDArray).
   self assert: ((NDArray withAll: #(#(1 2 3) #(1 2 3))) notMatches: #(1 2 3) asNDArray).
   self deny: ((NDArray withAll: #(#(1 2 3) #(1 2 3))) notMatches: (3 iota asNDArray reshape: #(2 3)))
]

{ #category : #tests }
PharoNDArrayTest >> testNumberOfGoodPairs [
   "Problem Link: https://leetcode.com/problems/number-of-good-pairs/"
   self assert: (#(1 2 3 1 1 3) asNDArray triangleProduct: #=) asNDArray mix ravel sum equals: 4.
   self assert: (#(1 1 1 1) asNDArray triangleProduct: #=) asNDArray mix ravel sum equals: 6.
   self assert: (#(1 2 3) asNDArray triangleProduct: #=) asNDArray mix ravel sum equals: 0.
]

{ #category : #tests }
PharoNDArrayTest >> testOuterProduct [
   | arr |
   arr := 3 iota asNDArray.
   self assert: (#(1 0) outerProduct: #(1 0 1 1 0 0) with: #=) equals: #(#(1 0 1 1 0 0) #(0 1 0 0 1 1)).
   self assert: ((4 iota outerProduct: 4 iota with: #=) ints reduce: #+) equals: #(1 1 1 1).
   self assert: ('()' asNDArray outerProduct: '()(())' with: #=) equals: #(#(1 0 1 1 0 0) #(0 1 0 0 1 1)).
   self assert: (arr outerProduct: arr with: #=) equals: #(#(1 0 0) #(0 1 0) #(0 0 1)).
   self assert: (arr outerProduct: arr with: #<=) equals: #(#(1 1 1) #(0 1 1) #(0 0 1)).
   self assert: (arr outerProduct: arr with: #*) equals: #(#(1 2 3) #(2 4 6) #(3 6 9))
]

{ #category : #tests }
PharoNDArrayTest >> testOverCombinator [
   "Classic example is to test the difference in length of string"
	| a b |
	a := 'mouse'.
	b := 'cat'.
   self assert: (a and: b with: #- over: #size) equals: 2.
   self assert: (a (#- <|> #size): b) equals: 2.

]

{ #category : #tests }
PharoNDArrayTest >> testPartition [
   | result |
   result := {
                #(1 2) asNDArray.
                #(4 5) asNDArray} asNDArray.
   self assert: (#(1 2 3 4 5) asNDArray partition: #(1 1 0 1 1)) equals: result
]

{ #category : #tests }
PharoNDArrayTest >> testPlus [
   self assert: (NDArray withAll: #(1 2 3)) + 1 equals: #(2 3 4).
   self assert: ((NDArray withAll: #(#(1 2 3) #(4 5 6))) + 10) ravel equals: (6 iota collect: 10 @@ #+).
   self assert: (NDArray withAll: #(#(1 2 3) #(4 5 6))) + 10 equals: #(#(11 12 13) #(14 15 16)).
   self assert: 1 + (NDArray withAll: #(1 2 3)) equals: #(2 3 4).
   self assert: 10 + ((NDArray withAll: #(#(1 2 3) #(4 5 6)))) ravel equals: (6 iota collect: 10 @@ #+).
   self assert: 10 + (NDArray withAll: #(#(1 2 3) #(4 5 6))) equals: #(#(11 12 13) #(14 15 16))
]

{ #category : #tests }
PharoNDArrayTest >> testPower [
   self assert: (NDArray withAll: #(1 2 3)) ** 2  equals: #(1 4 9).
   self assert: (NDArray withAll: #(#(2 4 6) #(8 10 12))) ** 2  equals: #(#(4 16 36) #(64 100 144)).
   self assert: (NDArray withAll: #(#(1 2 3) #(4 5 6))) ** 3  equals: #(#(1 8 27) #(64 125 216))
]

{ #category : #tests }
PharoNDArrayTest >> testRank [
   self assert: #() rank equals: 1. 
   self assert: #(1 2 3) rank equals: 1.
   self assert: #(#(1 2 3) #(4 5 6)) rank equals: 2.
   self assert: #(#(#(1 2 3) #(4 5 6)) #(#(1 2 3) #(4 5 6))) rank equals: 3
]

{ #category : #tests }
PharoNDArrayTest >> testRansomNote [
   "Problem Link: https://leetcode.com/problems/ransom-note/"
   | a b c d e alphaFreq |
   a := 'a' asNDArray.
   b := 'b' asNDArray.
   c := 'aa' asNDArray.
   d := 'ab' asNDArray.
   e := 'aab' asNDArray.
   alphaFreq := [ :arr | (Character alphabet outerProduct: arr with: #=) sum ].

   self assert: ((a and: b with: #- over: alphaFreq) <= 0 reduce: #and:) equals: 0.
   self assert: ((c and: d with: #- over: alphaFreq) <= 0 reduce: #and:) equals: 0.
   self assert: ((c and: e with: #- over: alphaFreq) <= 0 reduce: #and:) equals: 1.
   self assert: ((a and: b with: #- over: alphaFreq) <= 0) all equals: 0.
   self assert: ((c and: d with: #- over: alphaFreq) <= 0) all equals: 0.
   self assert: ((c and: e with: #- over: alphaFreq) <= 0) all equals: 1
]

{ #category : #tests }
PharoNDArrayTest >> testRavel [
   self assert: (NDArray withAll: #(1 2 3)) ravel asArray equals: #(1 2 3).
   self assert: (NDArray withAll: #(#(1 2 3) #(4 5 6))) ravel asArray equals: 6 iota asArray.
   self assert: (NDArray withAll: #(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12)))) ravel asArray equals: 12 iota    asArray
]

{ #category : #tests }
PharoNDArrayTest >> testReciprocal [ 
   self assert: (NDArray withAll: #(1 -2 3)) reciprocal equals: {1. -1/2. 1/3}.
   self assert: (NDArray withAll: #(#(-1 -2 -3) #(4 5 6))) reciprocal ravel equals: {-1. -1/2. -1/3. 1/4. 1/5. 1/6}.
   self assert: (NDArray withAll: #(#(1 2 3) #(-4 -5 -6))) reciprocal equals: {{1. 1/2. 1/3}. {-1/4. -1/5. -1/6}}
]

{ #category : #tests }
PharoNDArrayTest >> testReduce [
   "self assert: ((NDArray withAll: #()) reduce: #+) asArray equals: 0."
   self assert: ((NDArray withAll: #(1 2 3)) reduce: #+) equals: 6.
   self assert: ((NDArray withAll: #(#(1 2 3) #(4 5 6))) reduce: #+) equals: #(6 15).
   self assert: ((NDArray withShape: #(2 2 3) with: 12 iota) reduce: #+) equals: #(#(6 15) #(24 33)).
   self assert: (5 iota asNDArray = 1 reduce: #and:) equals: false.
   self assert: (#(1) reshape: #(5) :> = 1 :> reduce: #and:) equals: true.
   self assert: (1 reshape: #(5) :> = 1 :> reduce: #and:) equals: true.
   self assert: ((5 iota asNDArray = 1) ints reduce: #+) equals: 1.
]

{ #category : #tests }
PharoNDArrayTest >> testReduceFirst [
   "self assert: (1 asNDArray reduceFirst: #+) equals: 1."
   self assert: (3 iota asNDArray reduceFirst: #+) equals: 6.
   self assert: (9 iota reshape: #(3 3) :> reduceFirst: #+) equals: #(12 15 18).
   self assert: (6 iota reshape: #(2 3) :> reduceFirst: #+) equals: #(5 7 9)
]

{ #category : #tests }
PharoNDArrayTest >> testReshape [
   self assert: ((NDArray withShape: #(2 3) with: #(42)) reshape: #(3)) equals: #(42 42 42).
   self assert: ((NDArray withShape: #(2) with: #(42)) reshape: #(3)) equals: #(42 42 42).
   self assert: ((NDArray withShape: #(2 2) with: #(42)) reshape: #(4)) equals: #(42 42 42 42)
]

{ #category : #tests }
PharoNDArrayTest >> testReverse [
   self assert: (NDArray withAll: #(1 2 3)) reverse equals: #(3 2 1).
   self assert: (NDArray withAll: #(#(1 2 3) #(1 2 3))) reverse equals: #(#(3 2 1) #(3 2 1)).
   self assert: (12 iota reshape: #(2 3) :> reverse) equals: #((3 2 1) (6 5 4)).
   self assert: #() asNDArray reverse equals: #()
]

{ #category : #tests }
PharoNDArrayTest >> testRoll [
   self assert: (NDArray withAll: #(1 1 1)) roll equals: #(1 1 1).
   self assert: ((NDArray withAll: #(#(1 2 3) #(4 5 6))) roll ravel sum <= 21).
   self should: [ (NDArray withAll: #(#(1 2 3) #(-4 -5 -6))) roll ] raise: DomainError
]

{ #category : #tests }
PharoNDArrayTest >> testRotate [
   self assert: ((NDArray withAll: #(1 2 3)) rotate: 1) equals: #(2 3 1).
   self assert: ((NDArray withAll: #(#(1 2 3) #(1 2 3))) rotate: 2) equals: #(#(3 1 2) #(3 1 2)).
   self assert: (12 iota reshape: #(2 3) :> rotate: 1) equals: #((2 3 1) (5 6 4))
]

{ #category : #tests }
PharoNDArrayTest >> testRotateArray [
   "Problem Link: https://leetcode.com/problems/rotate-array/"
   | a b c d |
   a := 7 iota asNDArray.
   b := 3.
   c := #(-1 -100 3 99).
   d := 2.
   self assert: (a rotate: a size - (b % a size)) equals: #(5 6 7 1 2 3 4).
   self assert: (c rotate: c size - (d % c size)) equals: #(3 99 -1 -100)	
]

{ #category : #tests }
PharoNDArrayTest >> testScan [
   "self assert: ((NDArray withAll: #()) reduce: #+) asArray equals: 0."
   self assert: ((NDArray withAll: #(1 2 3)) scan: #+) equals: #(1 3 6).
   self assert: ((NDArray withAll: #(1 1 1 1 1)) scan: #+) equals: #(1 2 3 4 5).
   self assert: ((NDArray withAll: #(#(1 2 3) #(4 5 6))) scan: #+) equals: #(#(1 3 6) #(4 9 15)).
   self assert: (5 iota asNDArray = 1 scan: #and:) ints equals: #(1 0 0 0 0).
   self assert: (#(1) reshape: #(5) :> = 1 :> scan: #or:) ints equals: #(1 1 1 1 1)
]

{ #category : #tests }
PharoNDArrayTest >> testShape [
   self assert: #() shape equals: #(0).
   self assert: #(1 2 3) shape equals: #(3).
   self should: [ #(1 #(2 3)) shape ] raise: JaggedArray. 
   self assert: #(#(1 2 3) #(4 5 6)) shape equals: #(2 3).
   self should: [ #(#(1 2 3) #(4 5)) shape ] raise: JaggedArray.
   self assert: #(#(#(1 2 3) #(4 5 6)) #(#(1 2 3) #(4 5 6))) shape equals: #(2 2 3).
   self should: [ #(#(#(1 2 3) #(4 5 6)) #(#(1 2 3) #(4 5))) shape ] raise: JaggedArray
]

{ #category : #tests }
PharoNDArrayTest >> testSort [
   self assert: #(3 4 2 5 1) asNDArray sort equals: #(1 2 3 4 5).
   self assert: 10 asNDArray sort equals: 10.
   self assert: #() asNDArray sort equals: #()
]

{ #category : #tests }
PharoNDArrayTest >> testSplit [
   self assert: (4 iota asNDArray partition: #(1 0 1 0)) equals: #(#(1) #(3)) asNDArray split.
   self assert: (4 iota asNDArray partition: #(1 1 0 1)) mix split equals: #(#(1 2) #(4 0)) asNDArray split
   "self assert: (4 iota asNDArray partitionedEnclose: #(1 0 1 0) asNDArray) mix equals: #(#(1 2) #(3 4)) asNDArray"
]

{ #category : #tests }
PharoNDArrayTest >> testSum [
   self assert: (NDArray withAll: #(1 2 3)) sum equals: 6.
   self assert: (NDArray withAll: #(#(1 2 3) #(4 5 6))) sum equals: #(6 15).
   self assert: (NDArray withShape: #(2 2 3) with: 12 iota) sum equals: #(#(6 15) #(24 33)).
   self assert: (5 iota asNDArray = 1) sum equals: 1.
]

{ #category : #tests }
PharoNDArrayTest >> testSumEvens [
   | vals |
   vals := #(42 1729 4104) asNDArray.
   self assert: (vals filter: (vals % 2 :> not) :> reduce: #+) equals: 4146.
   self assert: (vals filterPred: #even :> reduce: #+) equals: 4146.
   self assert: ((vals dupWith: [ :e | e ] fork: #filter: and: [ :e | e % 2 :> not ]) reduce: #+) equals: 4146.
   self assert: ((vals dupWith: #yourself fork: #filter: and: [ :e | e % 2 :> not ]) reduce: #+) equals: 4146
]

{ #category : #tests }
PharoNDArrayTest >> testTake [
   self assert: (10 iota asNDArray take: 5)
      equals: 5 iota asNDArray.
   self assert: ((10 iota asNDArray take: 5) take: 10)
      equals: #(1 2 3 4 5 0 0 0 0 0).
]

{ #category : #tests }
PharoNDArrayTest >> testThesis_3_4_1_monadic_scalar [
   | matrixA matrixB |
   matrixA := 9 iota reshape: #(3 3) :> - 5 .
   matrixB := matrixA abs.
   self assert: matrixA equals: #((-4 -3 -2) (-1 0 1) (2 3 4)).
   self assert: matrixB equals: #((4 3 2) (1 0 1) (2 3 4)).
   matrixB := matrixA sign.
   self assert: matrixB equals: #((-1 -1 -1) (-1 0 1) (1 1 1)).
   matrixA := 12 iota reshape: #(3 4) :> + 4 :> / 10.0.
   matrixB := matrixA ceiling.
   self assert: matrixB equals: #((1 1 1 1) (1 1 2 2) (2 2 2 2)).
   matrixA := 9 iota reshape: #(3 3) :> % 2.
   matrixB := matrixA not.
   self assert: matrixB equals: #((0 1 0) (1 0 1) (0 1 0)).
]

{ #category : #tests }
PharoNDArrayTest >> testThesis_3_4_2_dyadic_scalar [
   | scalar vector matrix |
   scalar := 10.
   vector := 3 iota asNDArray.
   matrix := 9 iota reshape: #(3 3).
   self assert: scalar + vector equals: #(11 12 13).
   self assert: vector + scalar equals: (#(11 12 13) :> + 0).
   self assert: scalar + matrix equals: (9 iota + 10 reshape: #(3 3)).
   self assert: vector + vector equals: 3 iota * 2.
   self should: [ matrix + vector ] raise: ShapeError.
   self assert: scalar * vector equals: 3 iota * 10.
   self assert: vector * scalar equals: 3 iota * 10.
   self assert: scalar * matrix equals: (9 iota * 10 reshape: #(3 3)).
   self assert: vector * vector equals: 3 iota * 3 iota.
   self should: [ matrix * vector ] raise: ShapeError
]

{ #category : #tests }
PharoNDArrayTest >> testThesis_3_4_3_monadic [
   | vector matrix vectorA vectorB cube |
   vector := 3 iota asNDArray.
   matrix := 9 iota reshape: #(3 3).
   self assert: vector reverse equals: (#(3 2 1) :> + 0).
   self assert: matrix reverse equals: #(#(3 2 1) #(6 5 4) #(9 8 7)).
   self assert: vector ravel equals: vector.
   self assert: matrix ravel equals: 9 iota asArray.
   vectorA := #(1 0 1 0 1).
   vectorB := #(0 1 0 1 0).
   self assert: vectorA indices equals: #(1 3 5).
   self assert: vectorB indices equals: #(2 4).
   vector := #(3 4 2 1 3 5 2 1 4 4 3) asNDArray.
   self assert: vector unique sort equals: #(1 2 3 4 5).
   matrix := 9 iota reshape: #(6 3).
   self assert: matrix unique equals: (9 iota reshape: #(3 3)).
   cube := 9 iota reshape: #(2 3 3).
   self assert: cube unique equals: (9 iota reshape: #(1 3 3)).
   vectorA := #(1 2 3 4 5) asNDArray.
   vectorB := #(1 2 2 3 3 3) asNDArray.
   self assert: vectorA uniqueMask equals: #(1 1 1 1 1).
   self assert: vectorB uniqueMask equals: #(1 1 0 1 0 0).
   self assert: matrix uniqueMask equals: #(1 1 1 0 0 0).
   self assert: cube uniqueMask equals: #(1 0).
]

{ #category : #tests }
PharoNDArrayTest >> testThesis_3_4_4_dyadic [
   | matrixA matrixB scalar vector |
   matrixA := 10 iota asNDArray + 10 reshape: #(5 2).
   matrixB := (20 iota asNDArray drop: 10) reshape: #(5 2).
   self assert: (matrixA matches: matrixB).
   self deny: (matrixA matches: matrixB transpose).
   scalar := 10.
   vector := #(1 2 3 4 5).
   self assert: (scalar take: 5) equals: #(10 10 10 10 10).
   self assert: (vector take: 3) equals: #(1 2 3).
   self assert: (vector take: 5) equals: #(1 2 3 4 5).
   self assert: (vector take: 10) equals: #(1 2 3 4 5 0 0 0 0 0).
   self assert: (vector rotate: 2) equals: #(3 4 5 1 2)
]

{ #category : #tests }
PharoNDArrayTest >> testThesis_3_4_5_adverbs [
   | vector matrix |
   vector := #(1 2 3 4 5) asNDArray.
   matrix := 9 iota reshape: #(3 3).
   self assert: (vector reduce: #+) equals: 15.
   self assert: (vector reduce: #*) equals: 120.
   self assert: (matrix reduce: #+) equals: #(6 15 24).
   self assert: (matrix reduce: #*) equals: #(6 120 504).
   self assert: (vector scan: #+) equals: #(1 3 6 10 15).
   self assert: (vector scan: #*) equals: #(1 2 6 24 120).
   self assert: (matrix scan: #+) equals: #(#(1 3 6) #(4 9 15) #(7 15 24)).
   self assert: (matrix scan: #*) equals: #(#(1 2 6) #(4 20 120) #(7 56 504)).
   self assert: (vector windowed: 2 reduce: #+) equals: #(3 5 7 9).
   self assert: (vector windowed: 2 reduce: #*) equals: #(2 6 12 20).
   self assert: (vector windowed: 3 reduce: #+) equals: #(6 9 12).
   self assert: (vector windowed: 3 reduce: #*) equals: #(6 24 60)
]

{ #category : #tests }
PharoNDArrayTest >> testThesis_3_5_1_ndarray_combinators [
   | vectorA vectorB vectorC cat horse shore matrixA matrixB |
   vectorA := 'tacocat' asNDArray.
   vectorB := 'tacodog' asNDArray.
   vectorC := #(1 2 3 4 5) asNDArray.
   self assert: (vectorA dupWith: #matches: hook: #reverse).
   self assert: (vectorA dupWith: #reverse backHook: #matches:).
   self deny: (vectorB dupWith: #matches: hook: #reverse).
   self deny: (vectorB dupWith: #reverse backHook: #matches:).
   self assert: (vectorC dupWith: #filter: hook: #% @@ 2) equals: #(1 3 5).
   self assert: (vectorC dupWith: #* @@ 2 backHook: #intersection:) equals: #(2 4).
   cat := 'cat' asNDArray.
   horse := 'horse' asNDArray.
   shore := 'shore' asNDArray.
   self assert: (horse and: cat with: #- over: #size) equals: 2.
   self deny: (horse and: cat with: #matches: over: #sort).
   self assert: (horse and: shore with: #matches: over: #sort).
   vectorA := #(1 2 3) asNDArray.
   vectorB := #(2 3 4) asNDArray.
   vectorC := #(4 5 6) asNDArray.
   self deny: (vectorA and: vectorB with: #isEmpty atop: #intersection:).
   self assert: (vectorA and: vectorC with: #isEmpty atop: #intersection:).
   matrixA := 12 iota reshape: #(3 4).
   matrixB := 9 iota reshape: #(3 3).
   self assert: (matrixA and: matrixB with: #reshape: hook: #shape) equals: matrixB.
]

{ #category : #tests }
PharoNDArrayTest >> testThesis_3_5_2_symbol_combinators [
   | vectorA vectorB vectorC cat horse shore matrixA matrixB vector matrix |
   vectorA := 'tacocat' asNDArray.
   vectorB := 'tacodog' asNDArray.
   vectorC := #(1 2 3 4 5) asNDArray.
   self assert: vectorA (#matches: <*> #reverse).
   self deny: vectorB (#matches: <*> #reverse).
   self assert: vectorC (#filter: <*> (#% @@ 2)) equals: #(1 3 5).
   self assert: vectorC (#* @@ 2 <*> #intersection:) equals: #(2 4).
   cat := 'cat' asNDArray.
   horse := 'horse' asNDArray.
   shore := 'shore' asNDArray.
   self assert: horse (#- <|> #size): cat equals: 2.
   self deny: horse (#matches: <|> #sort): cat.
   self assert: horse (#matches: <|> #sort): shore.
   vectorA := #(1 2 3) asNDArray.
   vectorB := #(2 3 4) asNDArray.
   vectorC := #(4 5 6) asNDArray.
   self deny: vectorA (#isEmpty <|> #intersection:): vectorB.
   self assert: vectorA (#isEmpty <|> #intersection:): vectorC.
   matrixA := 12 iota reshape: #(3 4).
   matrixB := 9 iota reshape: #(3 3).
   self assert: matrixA (#reshape: <-> #shape): matrixB equals: matrixB.
   vector := 6 iota asNDArray * 2 - 1.
   matrix := 12 iota reshape: #(3 4).
   self assert: matrix (#ravel <-> #without:): vector equals: #(2 4 6 8 10 12)
]

{ #category : #tests }
PharoNDArrayTest >> testThesis_3_5_example [
   | vector isPalindrome |
   vector := 'tacocat' asNDArray.
   self assert: (vector dupWith: #matches: hook: #reverse).
   self assert: (#matches: <*> #reverse value: vector).
   isPalindrome := #matches: <*> #reverse.
   self assert: (   isPalindrome value: vector)
]

{ #category : #tests }
PharoNDArrayTest >> testTimes [
   self assert: (NDArray withAll: #(1 2 3)) * 1 equals: #(1 2 3).
   self assert: ((NDArray withAll: #(#(1 2 3) #(4 5 6))) * 10) ravel equals: (6 iota collect: 10 @@ #*).
   self assert: (NDArray withAll: #(#(1 2 3) #(4 5 6))) * 10 equals: #(#(10 20 30) #(40 50 60)).
   self assert: 1 * (NDArray withAll: #(1 2 3)) equals: #(1 2 3).
   self assert: 10 * ((NDArray withAll: #(#(1 2 3) #(4 5 6)))) ravel equals: (6 iota collect: 10 @@ #*).
   self assert: 10 * (NDArray withAll: #(#(1 2 3) #(4 5 6))) equals: #(#(10 20 30) #(40 50 60))
]

{ #category : #tests }
PharoNDArrayTest >> testTranspose [
   self assert: 1 asNDArray transpose equals: 1.
   self assert: 3 iota asNDArray transpose equals: #(1 2 3).
   self assert: (9 iota reshape: #(3 3) :> transpose) equals: #(#(1 4 7) #(2 5 8) #(3 6 9)).
   self assert: (6 iota reshape: #(2 3) :> transpose :> reduce: #+) equals: #(5 7 9)
]

{ #category : #tests }
PharoNDArrayTest >> testUnique [
   "self assert: 3 asNDArray unique equals: 3."
   self assert: (3 iota reshape: #(9)) unique equals: #(1 2 3).
   self assert: (3 iota reshape: #(3 3)) unique equals: (3 iota reshape: #(1 3))
   "self assert: (9 iota reshape: #(3 3 3)) unique equals: (9 iota reshape: #(1 3 3))"
]

{ #category : #tests }
PharoNDArrayTest >> testUniqueMask [
   self assert: 3 asNDArray uniqueMask equals: 1.
   self assert: #(3 3 3) asNDArray uniqueMask equals: #(1 0 0).
   self assert: (3 iota reshape: #(9)) uniqueMask equals: #(1 1 1 0 0 0 0 0 0).
   self assert: (7 iota reshape: #(10 10)) uniqueMask equals: (10 iota asNDArray < 8) ints.
   self assert: (7 iota reshape: #(8 10)) uniqueMask equals: (8 iota asNDArray < 8) ints.
   self assert: (4 iota reshape: #(5 6 7)) uniqueMask equals: #(1 1 0 0 0)
]

{ #category : #tests }
PharoNDArrayTest >> testWhere [
   self assert: #(1 0 1 0) asNDArray indices equals: #(1 3).
   self assert: (4 iota asNDArray partition: #(1 1 0 1) asNDArray) mix equals: #(#(1 2) #(4 0)) asNDArray.
   self assert: (10 iota asNDArray % 2) indices equals: 5 iota asNDArray * 2 - 1
   "self assert: (4 iota asNDArray partitionedEnclose: #(1 0 1 0) asNDArray) mix equals: #(#(1 2) #(3 4)) asNDArray"
]

{ #category : #tests }
PharoNDArrayTest >> testWindowedReduce [
   | v |
   v := #(1 2 3 4) asNDArray.
   self assert: (v windowed: 1 reduce: #+) equals: v.
   self assert: (v windowed: 2 reduce: #+) equals: #(3 5 7).
   self assert: (v windowed: 3 reduce: #+) equals: #(6 9).

]

{ #category : #tests }
PharoNDArrayTest >> testWithShapeWith [
   self assert: (NDArray withShape: #(2 3) with: #(42)) equals: #(#(42 42 42) #(42 42 42)).
   self assert: (NDArray withShape: #(3) with: 10 iota) equals: #(1 2 3).
   self assert: (NDArray withShape: #(2 3) with: 6 iota) equals: #(#(1 2 3) #(4 5 6)).
   self assert: (NDArray withShape: #(2 2 3) with: 6 iota) equals: #(#(#(1 2 3) #(4 5 6)) #(#(1 2 3) #(4 5 6))).
   self assert: (NDArray withShape: #(6) with: 'cat') equals: #($c $a $t $c $a $t).
   self assert: (NDArray withShape: #(2 2) with: 'cat') equals: #(($c $a) ($t $c))
]

{ #category : #tests }
PharoNDArrayTest >> testWithout [
	self assert: (5 iota asNDArray without: 3 iota) equals: #(4 5).
	self assert: (10 asNDArray without: 42) equals: #(10).
	self assert: (#(1 2 3 4) asNDArray without: #(3 4 5)) equals: #(1 2).
	self assert: (#(1 3 4) asNDArray without: #(3 4 5)) equals: #(1).
	self assert: (#(1 3 4) asNDArray without: 4) equals: #(1 3)
]
