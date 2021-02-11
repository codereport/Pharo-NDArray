Extension { #name : #SequenceableCollection }

{ #category : #'*Pharo-NDArray' }
SequenceableCollection >> rank [
   ^ self shape size.
]

{ #category : #'*Pharo-NDArray' }
SequenceableCollection >> shape [
   | dim nextDims |
   dim := Array with: (self size).
   dim first = 0 ifTrue: [ ^ dim ].
   self first isArray ifFalse: [ 
      (self allSatisfy: [ :e | e isArray not ])
         ifFalse: [ ^ self error: 'Non-conformant array (jagged)' ].
      ^ dim
	].
   nextDims := self collect: #shape.
   (nextDims allSatisfy: [ :d | nextDims first = d ]) ifFalse: [ 
      ^ self error: 'Non-confornmant array (jagged)'
   ].
   ^ dim , (nextDims first)
]
