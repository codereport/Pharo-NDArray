Extension { #name : #Object }

{ #category : #'*Pharo-NDArray' }
Object >> and: aString with: aString2 over: aString3 [
	^ self asNDArray and: aString with: aString2 over: aString3
]

{ #category : #'*Pharo-NDArray' }
Object >> isBoolean [
   ^ false
]

{ #category : #'*Pharo-NDArray' }
Object >> isBooleanValue [
   self isBoolean ifTrue: [ ^ true ].
   ^ false
]

{ #category : #'*Pharo-NDArray' }
Object >> isNDArray [
   ^ false
]
