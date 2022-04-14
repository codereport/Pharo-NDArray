Extension { #name : #Symbol }

{ #category : #'*Pharo-NDArray' }
Symbol >> <*> aBlock [
   | a b |
   a := self numArgsAsBlock.
   b := aBlock numArgsAsBlock.
   (a + b = 3 and: (a min: b) > 0) ifFalse: [ ^ ArityError signal ].
   "This is the backHook from I"
   b = 2 ifTrue: [ 
      ^ [ :x | aBlock value: (self value: x) value: x ] ].
   "This is the S combinator also known as the Starling"
   ^ [ :x | self value: x value: (aBlock value: x) ]
]

{ #category : #'*Pharo-NDArray' }
Symbol >> <-> aBlock [
   | a b |
   a := self numArgsAsBlock.
   b := aBlock numArgsAsBlock.
   (a + b = 3 and: (a min: b) > 0) ifFalse: [ ^ ArityError signal ].
   "This is the D combinator also known as the Dove bird"
   a = 2 ifTrue: [ ^ [ : x : y | self value: x value: (aBlock value: y) ] ].
   ^ [ : x : y | aBlock value: (self value: x) value: y ]
]

{ #category : #'*Pharo-NDArray' }
Symbol >> <| aBlock [
   "This is the Q combinator known as the Queer Bird"
   (self numArgsAsBlock = 1 and:
       aBlock numArgsAsBlock = 1) ifFalse: [ 
      ^ ArityError signal ].
   ^ [ :x | self value: (aBlock value: x) ]
]

{ #category : #'*Pharo-NDArray' }
Symbol >> <|> aBlock [
   | a b |
   a := self numArgsAsBlock.
   b := aBlock numArgsAsBlock.
   (a + b = 3 and: (a min: b) > 0) ifFalse: [ ^ ArityError signal ].
   "Psi or 'over'"
   a = 2 ifTrue: [ 
      ^ [ :x :y | 
        self value: (aBlock value: x) value: (aBlock value: y) ] ].
   "B1 or 'atop'"
   ^ [ :x :y | self value: (aBlock value: x value: y) ]
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

{ #category : #'*Pharo-NDArray' }
Symbol >> |> aBlock [
   "This is the B combinator also known as the Bluebird"
   (self numArgsAsBlock = 1 and:
       aBlock numArgsAsBlock = 1) ifFalse: [ 
      ^ ArityError signal ].
   ^ [ :x | aBlock value: (self value: x) ]
]
