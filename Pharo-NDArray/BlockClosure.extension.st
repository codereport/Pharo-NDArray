Extension { #name : #BlockClosure }

{ #category : #'*Pharo-NDArray' }
BlockClosure >> scan [
   ^ [ :x | x scan: self ]
]
