Extension { #name : #Integer }

{ #category : #'*Pharo-NDArray' }
Integer >> = aNumber [
   aNumber class = NDArray ifTrue: [ ^ aNumber adaptToInteger: self andCompare: #= ].
   aNumber isNumber ifFalse: [ ^ false ].
   aNumber isInteger ifTrue: [ 
      aNumber negative == self negative
         ifTrue: [ ^ (self bytesCompare: aNumber) = 0 ]
         ifFalse: [ ^ false ] ].
   ^ aNumber adaptToInteger: self andCompare: #=
]

{ #category : #'*Pharo-NDArray' }
Integer >> and: anInteger [ 
   ^ self * anInteger
]

{ #category : #'*Pharo-NDArray' }
Integer >> ifFalse: aFullBlockClosure [ 
   ^ self asBoolean ifFalse: aFullBlockClosure .
]

{ #category : #'*Pharo-NDArray' }
Integer >> isBooleanValue [
   ^ self = 0 or: self = 1
]

{ #category : #'*Pharo-NDArray' }
Integer >> not [
   self isBooleanValue ifFalse: [ ^ DomainError signal ].
   ^ 1 - self
]

{ #category : #'*Pharo-NDArray' }
Integer >> or: anInteger [ 
   ^ self max: anInteger
]
