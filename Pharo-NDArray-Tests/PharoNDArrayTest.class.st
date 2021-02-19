Class {
	#name : #PharoNDArrayTest,
	#superclass : #TestCase,
	#category : #'Pharo-NDArray-Tests'
}

{ #category : #tests }
PharoNDArrayTest >> testEquals [
   self assert: ((NDArray withAll: #(1 2 3)) = 1) asArray equals: #(true false false).
   self assert: ((NDArray withAll: #(#(1 2 3) #(1 2 3))) = 2) asArray equals: #(#(false true false) #(false true false)).
   self
      assert: ((NDArray withAll: #(#(1 2) #(4 5))) = 5) asArray
      equals: #(#(false false) #(false true))
]

{ #category : #tests }
PharoNDArrayTest >> testFilter [
   | arr |
   self assert: (NDArray withAll: #(1 3)) equals: (NDArray withAll: #(1 3)).
   self assert: ((NDArray withAll: #(1 2 3)) filter: #(true false true)) equals: (NDArray withAll: #(1 3)).
   self assert: ((NDArray withAll: #(#(1 2 3) #(1 2 3))) = 2) asArray equals: #(#(false true false) #(false true false)).
   self assert: ((NDArray withAll: #(#(1 2) #(4 5))) = 5) asArray equals: #(#(false false) #(false true)).
   arr := #(1 2 3) asNDArray.
   self assert: (arr filter: arr % 2) equals: (NDArray withAll: #(1 3))
]

{ #category : #tests }
PharoNDArrayTest >> testModulus [
   self assert: ((NDArray withAll: #(1 2 3)) % 2) asArray equals: #(1 0 1).
   self assert: ((NDArray withAll: #(#(1 2 3) #(4 5 6))) % 4) asArray equals: #(#(1 2 3) #(0 1 2)).
   self assert: ((NDArray withAll: #(#(1 2 3) #(4 5 6))) % 3) asArray equals: #(#(1 2 0) #(1 2 0))
]

{ #category : #tests }
PharoNDArrayTest >> testPlus [
   self assert: ((NDArray withAll: #(1 2 3)) + 1) asArray equals: #(2 3 4).
   self assert: ((NDArray withAll: #(#(1 2 3) #(4 5 6))) + 10) ravel asArray equals: (6 iota collect: 10 @@ #+).
   self assert: ((NDArray withAll: #(#(1 2 3) #(4 5 6))) + 10) asArray equals: #(#(11 12 13) #(14 15 16))
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
   self assert: ((NDArray withAll: #(1 2 3)) reduce: #+) asInteger equals: 6.
   self assert: ((NDArray withAll: #(#(1 2 3) #(4 5 6))) reduce: #+) asArray equals: #(6 15).
   self assert: ((NDArray withShape: #(2 2 3) with: 12 iota) reduce: #+) asArray equals: #(#(6 15) #(24 33))
]

{ #category : #tests }
PharoNDArrayTest >> testReshape [
   self assert: ((NDArray withShape: #(2 3) with: #(42)) reshape: #(3)) asArray equals: #(42 42 42).
   self assert: ((NDArray withShape: #(2) with: #(42)) reshape: #(3)) asArray equals: #(42 42 42).
   self assert: ((NDArray withShape: #(2 2) with: #(42)) reshape: #(4)) asArray equals: #(42 42 42 42).
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
PharoNDArrayTest >> testWithShapeWith [
   self assert: (NDArray withShape: #(2 3) with: #(42)) asArray equals: #(#(42 42 42) #(42 42 42)).
   self assert: (NDArray withShape: #(3) with: 10 iota) asArray equals: #(1 2 3).
   self assert: (NDArray withShape: #(2 3) with: 6 iota) asArray equals: #(#(1 2 3) #(4 5 6)).
   self assert: (NDArray withShape: #(2 2 3) with: 6 iota) asArray equals: #(#(#(1 2 3) #(4 5 6)) #(#(1 2 3) #(4 5 6)))
]
