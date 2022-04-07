Class {
	#name : #InvalidArgumentError,
	#superclass : #NDArrayError,
	#category : #'Pharo-NDArray'
}

{ #category : #accessing }
InvalidArgumentError >> messageText [
   ^ 'Argument provided is not valid'
]
