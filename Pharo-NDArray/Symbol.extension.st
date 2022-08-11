Extension { #name : #Symbol }

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
