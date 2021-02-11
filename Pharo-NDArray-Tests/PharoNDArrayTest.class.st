Class {
	#name : #PharoNDArrayTest,
	#superclass : #TestCase,
	#category : #'Pharo-NDArray-Tests'
}

{ #category : #tests }
PharoNDArrayTest >> testRank [
   self assert: (#() rank) equals: 1.
   self assert: (#(1 2 3) rank) equals: 1.
   self assert: (#((1 2 3) (4 5 6)) rank) equals: 2.
   self assert: (#(((1 2 3) (4 5 6)) ((1 2 3) (4 5 6))) rank) equals: 3.
]

{ #category : #tests }
PharoNDArrayTest >> testShape [
   self assert: (#() shape) equals: #(0).
   self assert: (#(1 2 3) shape) equals: #(3).
   self should: [ #(1 (2 3)) shape ] raise: Error.
   self assert: (#((1 2 3) (4 5 6)) shape) equals: #(2 3).
   self should: [ #((1 2 3) (4 5)) shape ] raise: Error.
   self assert: (#(((1 2 3) (4 5 6)) ((1 2 3) (4 5 6))) shape) equals: #(2 2 3).
   self should: [ #(((1 2 3) (4 5 6)) ((1 2 3) (4 5))) shape ] raise: Error.
]
