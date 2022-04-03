Extension { #name : #SequenceableCollection }

{ #category : #'*Pharo-NDArray' }
SequenceableCollection >> asNDArray [
   ^ NDArray withAll: self asArray 
]

{ #category : #'*Pharo-NDArray' }
SequenceableCollection >> outerProduct: anObject with: aBinaryBlock [
   ^ self asNDArray outerProduct: anObject with: aBinaryBlock
]

{ #category : #'*Pharo-NDArray' }
SequenceableCollection >> rank [
   ^ self shape size.
]

{ #category : #'*Pharo-NDArray' }
SequenceableCollection >> reshape: aCollection [ 
   ^ self asNDArray reshape: aCollection 
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

{ #category : #'*Pharo-NDArray' }
SequenceableCollection >> uniqueMask [
   | values |
   values := Set new.
   ^ self collect: [ :e | (values includes: e) 
          ifTrue: [ 0 ] 
         ifFalse: [ values add: e. 1 ]]
]
