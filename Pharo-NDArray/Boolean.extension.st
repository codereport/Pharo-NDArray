Extension { #name : #Boolean }

{ #category : #'*Pharo-NDArray' }
Boolean >> adaptToNumber: rcvr andSend: selector [ 
	^ rcvr perform: selector with: self asBit
]

{ #category : #'*Pharo-NDArray' }
Boolean >> asBoolean [
	^ self 
]

{ #category : #'*Pharo-NDArray' }
Boolean >> ints [
   ^ self asBit
]

{ #category : #'*Pharo-NDArray' }
Boolean >> isBoolean [
   ^ true
]
