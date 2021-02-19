Extension { #name : #SequenceableCollection }

{ #category : #'*Pharo-NDArray' }
SequenceableCollection >> asNDArray [
	^ NDArray withAll: self
]

{ #category : #'*Pharo-NDArray' }
SequenceableCollection >> rank [
   ^ self shape size.
]

{ #category : #'*Pharo-NDArray' }
SequenceableCollection >> shape [
   | dim nextDims |
   dim := Array with: self size.
   dim first = 0 ifTrue: [ ^ dim ].
   self first isArray ifFalse: [ 
      (self anySatisfy: #isArray) ifTrue: [ ^ JaggedArray signal ].
      ^ dim ]. 
   nextDims := self collect: #shape.
   nextDims allEqual ifFalse: [ ^ JaggedArray signal ].
   ^ dim , nextDims first
]
