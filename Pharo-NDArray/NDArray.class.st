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
NDArray >> - anObject [
   ^ self class new withShape: shape with: (data collect: #- @@ anObject)
]

{ #category : #'verbs (scalar)' }
NDArray >> < anObject [
   ^ self class new withShape: shape with: (data collect: #< @@ anObject)
]

{ #category : #'verbs (scalar)' }
NDArray >> = anObject [
   (self rank = anObject rank and: [self shape ~= anObject shape]) ifTrue: [ ^ ShapeError signal ].
   anObject rank = 0 ifTrue: [ ^ self class new withShape: shape with: (data collect: anObject first @@ #=) ].
   self rank = 0 ifTrue: [ ^ self class new withShape: anObject shape with: (anObject data collect: self first @@ #=) ].
   (self rank = anObject rank and: [self shape = anObject shape]) ifTrue: [ ^ self data = anObject data ].
   ^ self error: 'Need to implement scalar for both self/anObject not rank 0'
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

{ #category : #'verbs (scalar)' }
NDArray >> asString [
   self first class ~= Character ifTrue: [ ^ self error: 'Only Characters supported' ].
   ^ String newFrom: data
]

{ #category : #accessing }
NDArray >> data [
   ^ data
]

{ #category : #'verbs (scalar)' }
NDArray >> eq: anObject [
   anObject rank = 0 ifTrue: [ ^ self class new withShape: shape with: (data collect: anObject first @@ #=) ].
   self rank = 0 ifTrue: [ ^ self class new withShape: anObject shape with: (anObject data collect: self first @@ #=) ].
   (self rank = anObject rank and: self shape ~~ anObject shape) ifTrue: [ ^ ShapeError signal ].
   ^ self error: 'Need to implement scalar for both self/anObject not rank 0'
]

{ #category : #'verbs (dyadic)' }
NDArray >> filter: aCollection [ 
   | newData |
   self rank > 1 ifTrue: [ ^ RankError signal ].
   newData := data zip: aCollection asArray
           :> select: [ :a :b | b asBoolean ]
           :> collect: #first.
   ^ self class new withShape: newData shape with: newData
]

{ #category : #'verbs (dyadic)' }
NDArray >> filterPred: aUnaryBlock [
   ^ self filter: (self data collect: [ :e | aUnaryBlock value: e ])
]

{ #category : #'verbs (monadic)' }
NDArray >> first [
   ^ data first
]

{ #category : #trains }
NDArray >> fork: leftBlock with: binaryBlock with: rightBlock [
   rightBlock numArgsAsBlock = leftBlock numArgsAsBlock ifFalse: [ ^ self error: 'Arity Error' ].
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

{ #category : #'verbs (monadic)' }
NDArray >> not [
   "error if not boolean array"
   ^ self class new withShape: shape with: (data collect: 1 @@ #-)
]

{ #category : #adverbs }
NDArray >> outerProduct: anObject with: aBinaryBlock [
   | newData |
   (self rank > 1 or: anObject rank > 1) ifTrue: [ ^ RankError signal ].
   newData := data collect: [ :e | aBinaryBlock value: e asNDArray value: anObject asNDArray ].
   ^ self class new
        withShape: {
              self data size.
              anObject size}
        with: (newData collect: #asArray) flattened
]

{ #category : #'as yet unclassified' }
NDArray >> partition: anNDArray [ 
   ^ data with: anNDArray data collect: [ :a :b | Point x: a y: b ]
      :> groupByRuns: #y
      :> select: [ :e | e first y asBoolean ]
      :> collect: [ :e | (e collect: #x) asNDArray ]
      :> asNDArray
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

{ #category : #adverbs }
NDArray >> reduceFirst: aBinaryBlock [ 
   ^ self transpose reduce: aBinaryBlock
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

{ #category : #adverbs }
NDArray >> scan: aBinaryBlock [
   | newData |
   newData := data groupsOf: shape last 
           :> collect: [ :e | e scan: aBinaryBlock ] as: Array.
   ^ self class new withShape: shape with: newData
]

{ #category : #accessing }
NDArray >> shape [
   ^ shape
]

{ #category : #'verbs (monadic)' }
NDArray >> sign [
   ^ self class new withShape: shape with: (data collect: #sign)
]

{ #category : #accessing }
NDArray >> size [
   ^ shape last
]

{ #category : #'verbs (monadic)' }
NDArray >> transpose [
   | chunkedData newData |
   self rank < 2 ifTrue: [ ^ self copy ].
   self rank > 3 ifTrue: [ ^ RankError signal ].
   chunkedData := self data groupsOf: shape last.
   newData := OrderedCollection new.
   1 to: shape last do: [ :i | newData add: (chunkedData collect: [ :row | row at: i ]) ].
   ^ self class new withShape: shape reversed with: newData flattened
]

{ #category : #'verbs (monadic)' }
NDArray >> unique [
   | atoms newData newShape |
   self rank = 0 ifTrue: [ ^ self ].
   self rank = 1 ifTrue: [ ^ self class new withAll: data unique ].
   atoms := shape allButFirst product.
   newData := (data groupsOf: atoms) asArray unique.
   newShape := (Array with: newData size) , shape allButFirst.
   ^ self class new withShape: newShape with: newData
]

{ #category : #'as yet unclassified' }
NDArray >> windowed: anInteger reduce: aBinaryBlock [ 
   | coll |
   coll := OrderedCollection new.
   1 to: (self size - anInteger + 1) do: [ :i |
      coll add: ((data copyFrom: i to: i + anInteger - 1) reduce: aBinaryBlock).
   ].
   ^ self class new withAll: coll asArray 
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
