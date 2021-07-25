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
Integer >> isBoolean [
   ^ (self = 0) or: (self = 1)
]

{ #category : #'*Pharo-NDArray' }
Integer >> not [
   ^ 1 - self
]
