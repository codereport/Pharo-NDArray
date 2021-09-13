Class {
	#name : #ArityError,
	#superclass : #NDArrayError,
	#category : #'Pharo-NDArray'
}

{ #category : #accessing }
ArityError >> messageText [
   ^ 'Arity of blocks do not match'
]
