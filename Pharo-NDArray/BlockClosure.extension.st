Extension { #name : #BlockClosure }

{ #category : #'*Pharo-NDArray' }
BlockClosure >> <*> aFullBlockClosure [
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
BlockClosure >> <| aFullBlockClosure [
   (self numArgsAsBlock = 1 and:
       aFullBlockClosure numArgsAsBlock = 1) ifFalse: [ 
      ^ ArityError signal ].
   ^ [ :x | self value: (aFullBlockClosure value: x) ]
]

{ #category : #'*Pharo-NDArray' }
BlockClosure >> numArgsAsBlock [
	^ self numArgs
]

{ #category : #'*Pharo-NDArray' }
BlockClosure >> scan [
   ^ [ :x | x scan: self ]
]

{ #category : #'*Pharo-NDArray' }
BlockClosure >> |> aFullBlockClosure [
   "This is the B combinator also known as the Bluebird"
   (self numArgsAsBlock = 1 and:
       aFullBlockClosure numArgsAsBlock = 1) ifFalse: [ 
      ^ ArityError signal ].
   ^ [ :x | aFullBlockClosure value: (self value: x) ]
]
