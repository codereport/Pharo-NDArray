Extension { #name : #SmallInteger }

{ #category : #'*Pharo-NDArray' }
SmallInteger >> asBoolean [
   self = 0 ifTrue: [ ^ false ].
   self = 1 ifTrue: [ ^ true ].
   ^ self error: 'Non-Boolean'  "TODO: Create exception"
]

{ #category : #'*Pharo-NDArray' }
SmallInteger >> asNDArray [
   ^ NDArray withShape: #() with: (Array with: self)
]

{ #category : #'*Pharo-NDArray' }
SmallInteger >> ifTrue: aFullBlockClosure ifFalse: aFullBlockClosure2 [ 
	self = 1 ifTrue: [ ^ aFullBlockClosure value ].
	self = 0 ifTrue: [ ^ aFullBlockClosure2 value ].
	^ self error: self asString, ' must be 0 or 1 for ifTrue:ifFalse:'
]
