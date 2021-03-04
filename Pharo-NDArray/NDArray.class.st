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

{ #category : #arithmetic }
NDArray >> % anObject [
   ^ self class new withShape: shape with: (data collect: #% @@ anObject)
]

{ #category : #arithmetic }
NDArray >> + anObject [
   ^ self class new withShape: shape with: (data collect: anObject @@ #+)
]

{ #category : #comparing }
NDArray >> = anObject [
   anObject class = NDArray ifTrue: [ ^ shape = anObject shape and: data = anObject data ].
   ^ self class new withShape: shape with: (data collect: anObject @@ #=)
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

{ #category : #accessing }
NDArray >> data [
   ^ data
]

{ #category : #accessing }
NDArray >> filter: aCollection [ 
   | newData |
   self rank > 1 ifTrue: [ ^ self error: 'Rank Error' ]. "TODO: Create Rank Exception"
   newData := data zip: aCollection asArray
           :> select: [ :a :b | b asBoolean ]
           :> collect: #first.
   ^ self class new withShape: newData shape with: newData
]

{ #category : #accessing }
NDArray >> first [
   ^ data first
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

{ #category : #structuring }
NDArray >> ravel [
   ^ self class new withAll: data
]

{ #category : #enumerating }
NDArray >> reduce: aBlock [
   | newData |
   newData := data groupsOf: shape last 
           :> collect: [ :e | e reduce: aBlock ] as: Array.
   ^ self class new withShape: shape allButLast with: newData
]

{ #category : #structuring }
NDArray >> reshape: aCollection [
   | n newData |
   n := aCollection product.
   newData := n ~~ shape product ifTrue: [ data cycle: n ] ifFalse: [ data ].
   ^ self class new withShape: aCollection with: newData
]

{ #category : #enumerating }
NDArray >> reverse [
   | newData |
   newData := data groupsOf: shape last 
           :> collect: [ :e | e reversed ] as: Array.
   ^ self class new withShape: shape with: newData
]

{ #category : #accessing }
NDArray >> shape [
   ^ shape
]

{ #category : #'instance creation' }
NDArray >> withAll: aCollection [
   data := aCollection flattened.
   shape := aCollection shape 
]

{ #category : #initialization }
NDArray >> withShape: aCollection with: anArray [
   shape := aCollection.
   data := anArray flattened cycle: shape product 
]
