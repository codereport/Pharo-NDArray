Class {
	#name : #NDArray,
	#superclass : #Object,
	#instVars : [
		'data',
		'shape'
	],
	#category : #'Pharo-NDArray'
}

{ #category : #'instance creation' }
NDArray class >> new [
   ^ self shouldNotImplement 
]

{ #category : #'instance creation' }
NDArray class >> withAll: anArray [
   "Create NDArray from anArray"
   ^ super new withAll: anArray 
]

{ #category : #initialization }
NDArray class >> withShape: aCollection with: anArray [
   ^ super new withShape: aCollection with: anArray
]

{ #category : #converting }
NDArray >> asArray [
   | arr |
   arr := data.
   shape allButFirst reversed do: [ :n | arr := (arr groupsOf: n) asArray ].
   ^ arr
]

{ #category : #converting }
NDArray >> asInteger [
   (self rank ~~ 0) ifTrue: [ ^ self error: 'NDArray asInteger must have empty shape' ].
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

{ #category : #'as yet unclassified' }
NDArray >> ravel [
	shape := Array with: (shape product)
]

{ #category : #enumerating }
NDArray >> reduce: aBlock [
   data := data groupsOf: shape last 
        :> collect: [ :e | e reduce: aBlock ] 
        :> asArray.
   shape := shape allButLast
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
