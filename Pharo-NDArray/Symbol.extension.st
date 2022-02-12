Extension { #name : #Symbol }

{ #category : #'*Pharo-NDArray' }
Symbol >> *- aFullBlockClosure [
   "This is the D combinator also known as the Dove bird"
   ^ [ : x : y | self value: x value: (aFullBlockClosure value: y) ]
]
