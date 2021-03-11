Extension { #name : #Number }

{ #category : #'*Pharo-NDArray' }
Number >> reshape: aCollection [ 
   ^ self asNDArray reshape: aCollection
]
