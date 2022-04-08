Extension { #name : #Number }

{ #category : #'*Pharo-NDArray' }
Number >> asArray [
   ^ { self }
]

{ #category : #'*Pharo-NDArray' }
Number >> first [
   ^ self
]

{ #category : #'*Pharo-NDArray' }
Number >> rank [
   ^ 0
]

{ #category : #'*Pharo-NDArray' }
Number >> repeat: anInteger [ 
   ^ Array new: anInteger withAll: self
]

{ #category : #'*Pharo-NDArray' }
Number >> reshape: aCollection [ 
   ^ self asNDArray reshape: aCollection
]

{ #category : #'*Pharo-NDArray' }
Number >> shape [
	^ #()
]

{ #category : #'*Pharo-NDArray' }
Number >> take: anInteger [ 
   ^ self asNDArray take: anInteger 
]
