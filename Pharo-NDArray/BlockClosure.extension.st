Extension { #name : #BlockClosure }

{ #category : #'*Pharo-NDArray' }
BlockClosure >> numArgsAsBlock [
	^ self numArgs
]

{ #category : #'*Pharo-NDArray' }
BlockClosure >> scan [
   ^ [ :x | x scan: self ]
]
