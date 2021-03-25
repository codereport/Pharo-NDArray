Extension { #name : #Character }

{ #category : #'*Pharo-NDArray' }
Character >> asNDArray [
   ^ NDArray withShape: #() with: (Array with: self)
]
