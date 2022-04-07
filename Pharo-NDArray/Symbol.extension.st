Extension { #name : #Symbol }

{ #category : #'*Pharo-NDArray' }
Symbol >> <*> aFullBlockClosure [
   (self numArgsAsBlock = 2 and: aFullBlockClosure numArgsAsBlock = 2) ifTrue: [ ^ ArityError signal ].
   "This is the B combinator also known as the Bluebird"
   (self numArgsAsBlock = 1 and: aFullBlockClosure numArgsAsBlock = 1) ifTrue: [ 
      ^ [ : x | aFullBlockClosure value: (self value: x) ]
   ].
   "This is the backHook from I"
   self numArgsAsBlock = 2 ifTrue: [ ^ [ : x : y | aFullBlockClosure value: (self value: x) value: y ] ].
   "This is the S combinator also known as the Starling"
   ^ [ : x | self value: x value: (aFullBlockClosure value: x) ]
			
]

{ #category : #'*Pharo-NDArray' }
Symbol >> <-> aFullBlockClosure [
   (self numArgsAsBlock = 2 and: aFullBlockClosure numArgsAsBlock = 2) ifTrue: [ ^ ArityError signal ].
   "This is the B combinator also known as the Bluebird"
   (self numArgsAsBlock = 1 and: aFullBlockClosure numArgsAsBlock = 1) ifTrue: [ 
      ^ [ : x | aFullBlockClosure value: (self value: x) ]
   ].
   "This is the D combinator also known as the Dove bird"
   self numArgsAsBlock = 2 ifTrue: [ ^ [ : x : y | self value: x value: (aFullBlockClosure value: y) ] ].
   ^ [ : x : y | aFullBlockClosure value: (self value: x) value: y ]
]

{ #category : #'*Pharo-NDArray' }
Symbol >> <|> aFullBlockClosure [
   "This is the noth the B1 combinator and the Psi combinator"
   (self numArgsAsBlock = 2 and: aFullBlockClosure numArgsAsBlock = 2) ifTrue: [ ^ ArityError signal ].
   "This is the B combinator also known as the Bluebird"
   (self numArgsAsBlock = 1 and: aFullBlockClosure numArgsAsBlock = 1) ifTrue: [ 
      ^ [ : x | aFullBlockClosure value: (self value: x) ]
   ].
   "Psi or 'over'"
   aFullBlockClosure numArgsAsBlock = 2 ifTrue: [ ^ [ : x : y | aFullBlockClosure value: (self value: x) value: (self value: y) ] ].
   "B1 or 'atop'"
   ^ [ : x : y | aFullBlockClosure value: (self value: x value: 	y) ]
]

{ #category : #'*Pharo-NDArray' }
Symbol >> commuted [
   (#(#+, #=, #*, #min:, #max:) includes: self) ifTrue: [ ^ self ].
   self = #< ifTrue: [ ^ #> ].
   self = #> ifTrue: [ ^ #< ].
   self = #<= ifTrue: [ ^ #>= ].
   self = #>= ifTrue: [ ^ #<= ].
]

{ #category : #'*Pharo-NDArray' }
Symbol >> outerProduct [
	^ [ :x :y | x outerProduct: y with: self ]	
]

{ #category : #'*Pharo-NDArray' }
Symbol >> reduce [
   ^ [ :e | e reduce: self ]
]

{ #category : #'*Pharo-NDArray' }
Symbol >> scan [
   ^ [ :e | e scan: self ]
]

{ #category : #'*Pharo-NDArray' }
Symbol >> upperProduct [
	^ [ :x | x upperProduct: self ]
]
