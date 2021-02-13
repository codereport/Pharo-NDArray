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
