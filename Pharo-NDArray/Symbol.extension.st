Extension { #name : #Symbol }

{ #category : #'*Pharo-NDArray' }
Symbol >> <*> aFullBlockClosure [
   "This is the S combinator also known as the Starling"
   (self numArgsAsBlock = 2 and: aFullBlockClosure numArgsAsBlock = 2) ifTrue: [ ^ ArityError signal ].
   self numArgsAsBlock = 2 ifTrue: [ ^ [ : x | self value: x value: (aFullBlockClosure value: x) ] ].
			
]

{ #category : #'*Pharo-NDArray' }
Symbol >> <-> aFullBlockClosure [
   "This is the D combinator also known as the Dove bird"
   (self numArgsAsBlock = 2 and: aFullBlockClosure numArgsAsBlock = 2) ifTrue: [ ^ ArityError signal ].
   self numArgsAsBlock = 2 ifTrue: [ ^ [ : x : y | self value: x value: (aFullBlockClosure value: y) ] ].
   ^ [ : x : y | aFullBlockClosure value: (self value: x) value: y ]
]

{ #category : #'*Pharo-NDArray' }
Symbol >> <|> aFullBlockClosure [
   "This is the noth the B1 combinator and the Psi combinator"
   (self numArgsAsBlock = 2 and: aFullBlockClosure numArgsAsBlock = 2) ifTrue: [ ^ ArityError signal ].
   "Psi or 'over'"
   aFullBlockClosure numArgsAsBlock = 2 ifTrue: [ ^ [ : x : y | aFullBlockClosure value: (self value: x) value: (self value: y) ] ].
   "B1 or 'atop'"
   ^ [ : x : y | aFullBlockClosure value: (self value: x value: 	y) ]
]
