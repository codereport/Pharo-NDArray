Class {
	#name : #NDArray,
	#superclass : #Object,
	#traits : 'ComposeSyntax',
	#classTraits : 'ComposeSyntax classTrait',
	#instVars : [
		'data',
		'shape'
	],
	#category : #'Pharo-NDArray'
}

{ #category : #'instance creation' }
NDArray class >> withAll: anArray [
   "Create NDArray from anArray"
   ^ super new withAll: anArray 
]

{ #category : #initialization }
NDArray class >> withShape: aCollection with: anArray [
   ^ super new withShape: aCollection with: anArray
]

{ #category : #'verbs (scalar)' }
NDArray >> % anObject [
   ^ self class new withShape: shape with: (data collect: #% @@ anObject)
]

{ #category : #'verbs (scalar)' }
NDArray >> + anObject [
   ^ self class new withShape: shape with: (data collect: anObject @@ #+)
]

{ #category : #'verbs (scalar)' }
NDArray >> = anObject [
   anObject class = NDArray ifTrue: [ ^ shape = anObject shape and: data = anObject data ].
   ^ self class new withShape: shape with: (data collect: anObject @@ #=)
]

{ #category : #arithmetic }
NDArray >> adaptToNumber: anInteger andSend: aSymbol [
   aSymbol = #+ ifTrue: [ ^ self + anInteger ].
   aSymbol = #= ifTrue: [ ^ self = anInteger ].
]

{ #category : #converting }
NDArray >> asArray [
   | arr |
   arr := data.
   shape allButFirst reversed do: [ :n | arr := (arr groupsOf: n) asArray ].
   ^ arr
]

{ #category : #converting }
NDArray >> asBoolean [
   self rank ~~ 0 ifTrue: [ ^ self error: 'Rank Error' ]. "TODO: Create Rank Exception"
   ^ data first
]

{ #category : #converting }
NDArray >> asInteger [
   (self rank ~~ 0) ifTrue: [ ^ self error: 'NDArray asInteger must have empty shape' ].
   ^ data first
]

{ #category : #converting }
NDArray >> asNDArray [
   ^ self
]

{ #category : #accessing }
NDArray >> data [
   ^ data
]

{ #category : #'verbs (dyadic)' }
NDArray >> filter: aCollection [ 
   | newData |
   self rank > 1 ifTrue: [ ^ self error: 'Rank Error' ]. "TODO: Create Rank Exception"
   newData := data zip: aCollection asArray
           :> select: [ :a :b | b asBoolean ]
           :> collect: #first.
   ^ self class new withShape: newData shape with: newData
]

{ #category : #'verbs (monadic)' }
NDArray >> first [
   ^ data first
]

{ #category : #trains }
NDArray >> fork: leftBlock with: binaryBlock with: rightBlock [
   rightBlock numArgs = leftBlock numArgs ifFalse: [ ^ self error: 'Arity Error' ].
   ^ binaryBlock value: (leftBlock value: self) value: (rightBlock value: self)

]

{ #category : #'verbs (monadic)' }
NDArray >> ints [
   | newData |
   newData := data collect: #asInteger.
   ^ self class new withShape: shape with: newData
]

{ #category : #'verbs (dyadic)' }
NDArray >> matches: anObject [
   self shape = anObject asNDArray shape ifFalse: [ ^ false ].
   ^ self data = anObject asNDArray data
]

{ #category : #'as yet unclassified' }
NDArray >> outerProduct: anObject with: aBinaryBlock [
   | newData |
   " error on ranks"
   newData := OrderedCollection new.
   self data do: [ :e | newData add: (aBinaryBlock value: e value: anObject asNDArray) ].
   ^ NDArray new withShape: {self data size. anObject size} with: (newData collect: #asArray) flattened 
]

{ #category : #'instance creation' }
NDArray >> printOn: aStream [
   super printOn: aStream.
   aStream nextPutAll: ': '.
   data printOn: aStream.
   aStream nextPutAll: ' with shape: '. 
   shape printOn: aStream
]

{ #category : #accessing }
NDArray >> rank [
   ^ shape size
]

{ #category : #'verbs (monadic)' }
NDArray >> ravel [
   ^ self class new withAll: data
]

{ #category : #adverbs }
NDArray >> reduce: aBlock [
   | newData |
   newData := data groupsOf: shape last 
           :> collect: [ :e | e reduce: aBlock ] as: Array.
   ^ self class new withShape: shape allButLast with: newData
]

{ #category : #'verbs (dyadic)' }
NDArray >> reshape: aCollection [
   | n newData |
   n := aCollection product.
   newData := n ~~ shape product ifTrue: [ data cycle: n ] ifFalse: [ data ].
   ^ self class new withShape: aCollection with: newData
]

{ #category : #'verbs (monadic)' }
NDArray >> reverse [
   | newData |
   newData := data groupsOf: shape last 
           :> collect: [ :e | e reversed ] as: Array.
   ^ self class new withShape: shape with: newData
]

{ #category : #'verbs (dyadic)' }
NDArray >> rotate: anInteger [
   | newData |
   newData := data groupsOf: shape last 
           :> collect: [ :e | e rotate: anInteger ] as: Array.
   ^ self class new withShape: shape with: newData
]

{ #category : #accessing }
NDArray >> shape [
   ^ shape
]

{ #category : #'verbs (monadic)' }
NDArray >> unique [
   | atoms newData newShape |
   self rank = 0 ifTrue: [ ^ self ].
   self rank = 1 ifTrue: [ ^ self class new withAll: data copyWithoutDuplicates ].
   atoms := shape allButFirst product.
   newData := (data groupsOf: atoms) copyWithoutDuplicates as: Array.
   newShape := (Array with: newData size) , shape allButFirst.
   ^ self class new withShape: newShape with: newData
]

{ #category : #'instance creation' }
NDArray >> withAll: aCollection [
   data := aCollection flattened.
   shape := aCollection shape 
]

{ #category : #initialization }
NDArray >> withShape: aCollection with: anObject [
   shape := aCollection.
   data := anObject asArray flattened cycle: shape product
]
