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
      ^ super assert: (actual data = expected data and: actual shape = expected shape) ].
   ^ super assert: actual equals: expected
]

{ #category : #tests }
PharoNDArrayTest >> testAllEqual [
   | v u |
   v := #(1 2 3 4) asNDArray.
   u := #(1 1 1 1) asNDArray.
   self assert: ((v eq: (v first)) reduce: #and:) equals: false.
   self assert: ((v unique) size = 1) equals: false.
   self assert: ((v reduce: #max:) = (v reduce: #min:)) equals: false.
   self assert: ((v windowed: 2 reduce: #=) reduce: #and:) equals: false.
   self assert: ((v rotate: 1) matches: v) equals: false.
   self assert: ((u eq: (u first)) reduce: #and:) equals: true.
   self assert: ((u unique) size = 1) equals: true.
   self assert: ((u reduce: #max:) = (u reduce: #min:)) equals: true.
   self assert: ((u windowed: 2 reduce: #=) reduce: #and:) equals: true.
   self assert: ((u rotate: 1) matches: u) equals: true.
]

{ #category : #tests }
PharoNDArrayTest >> testArraySign [
   self assert: (#(1 -1 2 -3) asNDArray sign reduce: #*) equals: 1.
   self assert: (#(1 -1 2 -3 -4) asNDArray sign reduce: #*) equals: -1.
   self assert: ((9 iota asNDArray - 5) sign reduce: #*) equals: 0
]

{ #category : #tests }
PharoNDArrayTest >> testEquals [
   self assert: (NDArray withAll: #(1 2 3)) = 1 equals: #(true false false).
   self assert: 1 = (NDArray withAll: #(1 2 3)) equals: #(true false false).
   self assert: (NDArray withAll: #(#(1 2 3) #(1 2 3))) = 2 equals: #(#(false true false) #(false true false)).
   self assert: (NDArray withAll: #(#(1 2) #(4 5))) = 5 equals: #(#(false false) #(false true)).
   self assert: 'hello' asNDArray = $l equals: #(false false true true false).
   self assert: ('hello' asNDArray = $l) ints equals: #(0 0 1 1 0).
   self assert: true asInteger equals: 1.
   self assert: false asInteger equals: 0.
   self assert: ('()(())' asNDArray = $() ints equals: #(1 0 1 1 0 0).
   self assert: (2 = #(1 2 3) asNDArray) ints equals: #(0 1 0).
   self assert: (1 asNDArray = 3 iota asNDArray) ints equals: #(1 0 0)
   "self assert: (2 asNDArray = #(1 2 3)) ints equals: #(0 1 0)"
   "self assert: #(1 2 3) asNDArray = #(0 2 3) asNDArray equals: #(false true true)"
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
PharoNDArrayTest >> testFirst [
   self assert: (NDArray withAll: #(1 2 3)) first equals: 1.
   self assert: (NDArray withAll: #(#(1 2 3) #(1 2 3))) first equals: 1.
   self assert: (NDArray withAll: #(#(1 2) #(4 5))) first equals: 1
]

{ #category : #tests }
PharoNDArrayTest >> testFork [
   self assert: (#(1 2 3) asNDArray fork: #yourself with: #= with: #first) equals: #(true false false).
   self assert: (#(1 2 3) asNDArray fork: #first with: [ :a :b | b = a ] with: #yourself) equals: #(true false false)
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
PharoNDArrayTest >> testMatches [
   self assert: (1 asNDArray matches: 1).
   self deny: ((NDArray withAll: #(1 2 3)) matches: 1).
   self assert: ((NDArray withAll: #(1 2 3)) matches: #(1 2 3)).
   self assert: ((NDArray withAll: #(1 2 3)) matches: 3 iota asNDArray).
   self deny: ((NDArray withAll: #(#(1 2 3) #(1 2 3))) matches: #(1 2 3) asNDArray).
   self assert: ((NDArray withAll: #(#(1 2 3) #(1 2 3))) matches: (3 iota asNDArray reshape: #(2 3)))
]

{ #category : #tests }
PharoNDArrayTest >> testMaxConsecutiveOnes [
   | arr |
   arr := #(1 1 0 0 1 1 1 0 1 1 1 1 0 0 0) asNDArray.
   self assert: (((arr partition: arr) collect: [ :e | e reduce: #+ ]) reduce: #max:) equals: 4.

]

{ #category : #tests }
PharoNDArrayTest >> testMaxWealth [
   self assert: (((9 iota asNDArray reshape: #(3 3)) reduce: #+) reduce: #max:) equals: 24.
   self assert: (((10 asNDArray reshape: #(3 3)) reduce: #+) reduce: #max:) equals: 30.
   self assert: (((9 iota asNDArray reshape: #(3 3)) transpose reduce: #+) reduce: #max:) equals: 18
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
PharoNDArrayTest >> testOuterProduct [
   self assert: (#(1 0) outerProduct: #(1 0 1 1 0 0) with: #=) ints equals: #(#(1 0 1 1 0 0) #(0 1 0 0 1 1)).
   "self assert: (4 iota asNDArray = 4 iota) ints equals: #(1 1 1 1)."
   self assert: ((4 iota outerProduct: 4 iota with: #=) ints reduce: #+) equals: #(1 1 1 1).
   self assert: ('()' asNDArray outerProduct: '()(())' with: #=) ints equals: #(#(1 0 1 1 0 0) #(0 1 0 0 1 1)).
   "self assert: ('()' outerProduct: '()(())' with: #=) ints equals: #(#(1 0 1 1 0 0) #(0 1 0 0 1 1))"
]

{ #category : #tests }
PharoNDArrayTest >> testPartition [
   | result |
   result := {#(1 2) asNDArray. #(4 5) asNDArray} asNDArray.
   self assert: (#(1 2 3 4 5) asNDArray partition: #(1 1 0 1 1) asNDArray) equals: result.

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
PharoNDArrayTest >> testRank [
   self assert: #() rank equals: 1. 
   self assert: #(1 2 3) rank equals: 1.
   self assert: #(#(1 2 3) #(4 5 6)) rank equals: 2.
   self assert: #(#(#(1 2 3) #(4 5 6)) #(#(1 2 3) #(4 5 6))) rank equals: 3
]

{ #category : #tests }
PharoNDArrayTest >> testRavel [
   self assert: (NDArray withAll: #(1 2 3)) ravel asArray equals: #(1 2 3).
   self assert: (NDArray withAll: #(#(1 2 3) #(4 5 6))) ravel asArray equals: 6 iota asArray.
   self assert: (NDArray withAll: #(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12)))) ravel asArray equals: 12 iota    asArray
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
   self assert: (12 iota reshape: #(2 3) :> reverse) equals: #((3 2 1) (6 5 4))
]

{ #category : #tests }
PharoNDArrayTest >> testRotate [
   self assert: ((NDArray withAll: #(1 2 3)) rotate: 1) equals: #(2 3 1).
   self assert: ((NDArray withAll: #(#(1 2 3) #(1 2 3))) rotate: 2) equals: #(#(3 1 2) #(3 1 2)).
   self assert: (12 iota reshape: #(2 3) :> rotate: 1) equals: #((2 3 1) (5 6 4))
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
PharoNDArrayTest >> testSumEvens [
   | vals |
   vals := #(42 1729 4104) asNDArray.
   self assert: (vals filter: (vals % 2 :> not) :> reduce: #+) equals: 4146.
   self assert: (vals filterPred: #even :> reduce: #+) equals: 4146.
   self assert: ((vals fork: [ :e | e ] with: #filter: with: [ :e | e % 2 :> not ]) reduce: #+) equals: 4146.
   self assert: ((vals fork: #yourself with: #filter: with: [ :e | e % 2 :> not ]) reduce: #+) equals: 4146
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
   self assert: (3 iota reshape: #(3 3)) unique equals: (3 iota reshape: #(1 3)).
"   self assert: (9 iota reshape: #(3 3 3)) unique equals: (9 iota reshape: #(1 3 3))"
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
