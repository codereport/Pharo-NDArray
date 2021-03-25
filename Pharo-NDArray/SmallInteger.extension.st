Extension { #name : #SmallInteger }

{ #category : #'*Pharo-NDArray' }
SmallInteger >> asBoolean [
   (self = 1 or: self = 0) ifFalse: [ ^ self error: 'Non-Boolean' ]. "TODO: Create exception"
   ^ self = 1
]

{ #category : #'*Pharo-NDArray' }
SmallInteger >> asNDArray [
   ^ NDArray withShape: #() with: (Array with: self)
]

{ #category : #'*Pharo-NDArray' }
SmallInteger >> shape [
	^ #()
]
