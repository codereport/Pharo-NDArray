Extension { #name : #SmallInteger }

{ #category : #'*Pharo-NDArray' }
SmallInteger >> asNDArray [
   ^ NDArray withShape: #() with: (Array with: self)
]
