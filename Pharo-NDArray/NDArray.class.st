"
A class for representing n-dimensional arrays.
 
Internal Representation and Key Implementation Points.

  Instance Variables
	data:		Array
	shape:	Array
"
Class {
	#name : #NDArray,
	#superclass : #Object,
	#traits : 'ComposeSyntax',
	#classTraits : 'ComposeSyntax classTrait',
	#instVars : [
		'data',
		'shape',
		'isNested'
	],
	#category : #'Pharo-NDArray'
}

{ #category : #'instance creation' }
NDArray class >> withAll: anArray [
   "Create NDArray from anArray"
   ^ super new withAll: anArray 
]

{ #category : #initialization }
NDArray class >> withShape: aCollection with: anArray [
   ^ super new withShape: aCollection with: anArray
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> % anObject [
   ^ self class new withShape: shape with: (data collect: #% @@ anObject)
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> * anObject [
   ^ self class new withShape: shape with: (data collect: anObject @@ #*)
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> + anObject [
   ^ self class new withShape: shape with: (data collect: anObject @@ #+)
]

{ #category : #'verbs (dyadic)' }
NDArray >> , anObject [
   (self rank = 1) ifFalse: [ ^ RankError signal ]. "TODO"
   (anObject asNDArray rank = 0) ifFalse: [ ^ RankError signal ]. "TODO"
   ^ (data , {anObject}) asNDArray.
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> - anObject [
   ^ self class new withShape: shape with: (data collect: #- @@ anObject)
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> < anObject [
   ^ self class new withShape: shape with: (data collect: [ :e | (e < anObject) asBit ])
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> <= anObject [
   self rank = 0 ifTrue: [ ^ anObject >= data first ].
   ^ self class new withShape: shape with: (data collect: [ :e | (e <= anObject) ints ])
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> = anObject [
   (self rank = anObject rank and: [ self shape ~= anObject shape ]) ifTrue: [ ^ ShapeError signal ].
   anObject rank = 0 ifTrue: [ ^ self class new withShape: shape with: (data collect: [ :e | (anObject first = e) asBit ]) ].
   self rank = 0 ifTrue: [ ^ self class new withShape: anObject shape with: (anObject data collect: [ :e | (self first = e) asBit ]) ].
   (self rank = anObject rank and: [ self shape = anObject shape ]) ifTrue: [ ^ (self data = anObject data) asBit ].
   ^ self error: 'Need to implement scalar for both self/anObject not rank 0'
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> > anObject [
	self rank = 0 ifTrue: [ ^ anObject < data first ].
	^ self class new withShape: shape with: (data collect: [ :e | (e > anObject) asBit ])
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> >= anObject [
   ^ self class new withShape: shape with: (data collect: [ :e | (e >= anObject) asBit ])
]

{ #category : #'verbs (scalar monadic)' }
NDArray >> abs [
   ^ self class new withShape: shape with: (data collect: #abs)
]

{ #category : #arithmetic }
NDArray >> adaptToNumber: anInteger andSend: aSymbol [
   aSymbol = #+ ifTrue: [ ^ self + anInteger ].
   aSymbol = #= ifTrue: [ ^ self = anInteger ].
   aSymbol = #* ifTrue: [ ^ self * anInteger ].
   aSymbol = #< ifTrue: [ ^ self > anInteger ].
   aSymbol = #> ifTrue: [ ^ self < anInteger ].
   aSymbol = #<= ifTrue: [ ^ self >= anInteger ].
   aSymbol = #>= ifTrue: [ ^ self <= anInteger ].
   aSymbol = #min: ifTrue: [ ^ self min: anInteger ]
]

{ #category : #converting }
NDArray >> asArray [
   | arr |
   arr := data.
   shape allButFirst reversed do: [ :n | arr := (arr groupsOf: n) asArray ].
   ^ arr
]

{ #category : #converting }
NDArray >> asBoolean [
   self rank ~~ 0 ifTrue: [ ^ self error: 'Rank Error' ]. "TODO: Create Rank Exception"
   ^ data first
]

{ #category : #converting }
NDArray >> asInteger [
   (self rank ~~ 0) ifTrue: [ ^ self error: 'NDArray asInteger must have empty shape' ].
   ^ data first
]

{ #category : #converting }
NDArray >> asNDArray [
   ^ self
]

{ #category : #'verbs (monadic)' }
NDArray >> asString [
   self first class ~= Character ifTrue: [ ^ self error: 'Only Characters supported' ].
   ^ String newFrom: data
]

{ #category : #'verbs (scalar monadic)' }
NDArray >> ceiling [
   ^ self class new withShape: shape with: (data collect: #ceiling)
]

{ #category : #'verbs (dyadic)' }
NDArray >> collect: aUnaryBlock [
   | newData |
   newData := data collect: aUnaryBlock.
   ^ self class new withShape: shape with: newData
]

{ #category : #accessing }
NDArray >> data [
   ^ data
]

{ #category : #'verbs (dyadic)' }
NDArray >> drop: anInteger [
	anInteger isNDArray ifTrue: [ ^ self error: 'take: only supports integer parameter currently' ].
	self rank = 0 ifTrue: [ anInteger = 0 ifTrue: [ ^ self ] ifFalse: [ ^ #() asNDArray ] ].
	self rank = 1 ifTrue: [ 
		data size >= anInteger
			ifTrue: [ ^ (data last: (data size - anInteger)) asNDArray ] "TODO check to see if there is drop:?"
			ifFalse: [ ^ #() asNDArray ] ].
	^ self error: 'Implement for higher ranks'
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> eq: anObject [
   anObject rank = 0 ifTrue: [ ^ self class new withShape: shape with: (data collect: [ :e | (anObject first = e) asBit ]) ].
   self rank = 0 ifTrue: [ ^ self class new withShape: anObject shape with: (anObject data collect: [ :e | (self first = e) asBit ]) ].
   (self rank = anObject rank and: (self shape = anObject shape) not) ifTrue: [ ^ ShapeError signal ].
   self rank = anObject rank ifTrue: [ 
      ^ self class new withShape: shape with: (data with: anObject data collect: [ :a :b | (a = b) asBit ]) ].
   ^ self error: 'Need to implement scalar for both self/anObject not rank 0'
]

{ #category : #'verbs (scalar monadic)' }
NDArray >> exp [
   ^ self class new withShape: shape with: (data collect: #exp)
]

{ #category : #'verbs (scalar monadic)' }
NDArray >> factorial [
   (data anySatisfy: #negative) ifTrue: [ ^ DomainError signal ].
   ^ self class new withShape: shape with: (data collect: #factorial)
]

{ #category : #'verbs (dyadic)' }
NDArray >> filter: aCollection [ 
   | newData |
   self rank > 1 ifTrue: [ ^ RankError signal ].
   newData := data zip: aCollection asArray
           :> select: [ :a :b | b asBoolean ]
           :> collect: #first.
   ^ self class new withShape: newData shape with: newData
]

{ #category : #'verbs (dyadic)' }
NDArray >> filterPred: aUnaryBlock [
   ^ self filter: (self data collect: [ :e | aUnaryBlock value: e ])
]

{ #category : #'verbs (monadic)' }
NDArray >> first [
   ^ data first
]

{ #category : #'verbs (scalar monadic)' }
NDArray >> floor [
   ^ self class new withShape: shape with: (data collect: #floor)
]

{ #category : #trains }
NDArray >> fork: leftBlock with: binaryBlock with: rightBlock [
   rightBlock numArgsAsBlock = leftBlock numArgsAsBlock ifFalse: [ ^ self error: 'Arity Error' ].
   ^ binaryBlock value: (leftBlock value: self) value: (rightBlock value: self)
]

{ #category : #trains }
NDArray >> hook: binaryBlock with: unaryBlock [
   "rightBlock numArgsAsBlock = leftBlock numArgsAsBlock ifFalse: [ ^ self error: 'Arity Error' ]."
   ^ binaryBlock value: self value: (unaryBlock value: self)
]

{ #category : #'verbs (monadic)' }
NDArray >> ints [
   | newData |
   newData := data collect: #asInteger.
   ^ self class new withShape: shape with: newData
]

{ #category : #'verbs (scalar monadic)' }
NDArray >> invFactorial [
   (data anySatisfy: #negative) ifTrue: [ ^ DomainError signal ].
   ^ self class new withShape: shape with: (data collect: #invFactorial)
]

{ #category : #'verbs (monadic)' }
NDArray >> invIota [
   self rank = 0 ifTrue: [ ^ RankError signal ].
   self data first = 1 ifFalse: [ ^ DomainError signal ].
   "asBoolean vvv figure out why needed"
   (((self windowed: 2 reduce: #-) eq: -1) reduce: #and:) asBoolean ifFalse: [ ^ DomainError signal ].
   self rank = 1 ifTrue: [ ^ data last ].
   ^ self error: 'Implement for higher ranks'
]

{ #category : #'verbs (monadic)' }
NDArray >> invWhere [
   self data isSorted ifFalse: [ ^ DomainError signal ].
   self rank = 0 ifTrue: [ ^ RankError signal ].
   self rank = 1 ifTrue: [ ^ data last iota asNDArray memberOf: data ].
   ^ self error: 'Implement for higher ranks'
]

{ #category : #accessing }
NDArray >> isNDArray [
   ^ true
]

{ #category : #accessing }
NDArray >> isNested [
   ^ self first isNDArray
]

{ #category : #'verbs (dyadic)' }
NDArray >> matches: anObject [
   self shape = anObject asNDArray shape ifFalse: [ ^ false ].
   ^ self data = anObject asNDArray data
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> max: anInteger [ 
   ^ self class new withShape: shape with: (data collect: anInteger @@ #max:)
]

{ #category : #'verbs (dyadic)' }
NDArray >> memberOf: aNDArray [
   | hashedValues newData |
   self rank = 0 ifTrue: [ ^ RankError signal ].
   self rank = 1 ifTrue: [ 
      hashedValues := aNDArray asNDArray data asSet.
      newData := data collect: [ :e | (hashedValues includes: e) asBit ].
      ^ self class new withShape: shape with: newData ].
   ^ self error: 'Implement for higher ranks'
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> min: anInteger [ 
   ^ self class new withShape: shape with: (data collect: anInteger @@ #min:)
]

{ #category : #'verbs (monadic)' }
NDArray >> mix [
   | maxLength newShape newData |
   self isNested ifFalse: [ ^ self ].
   maxLength := (data collect: #size) reduce: #max:.
   newShape := Array with: data size with: maxLength.
   newData := data collect: [ :e | 
                 e size = maxLength
                    ifTrue: [ e data ]
                    ifFalse: [ e data , (Array new: maxLength - e size withAll: 0) ] ].
   ^ self class new withShape: newShape with: newData
]

{ #category : #'verbs (scalar monadic)' }
NDArray >> not [
   (data allSatisfy: [ :e | e isBooleanValue or: e isBoolean ]) ifFalse: [ ^ DomainError signal ].
   ^ (self class new withShape: shape with: (data collect: #not)) ints
]

{ #category : #'verbs (dyadic)' }
NDArray >> notMatches: anObject [
   self shape = anObject asNDArray shape ifFalse: [ ^ true ].
   ^ (self data = anObject asNDArray data) not "TODO fix when != implemented"
]

{ #category : #adverbs }
NDArray >> outerProduct: anObject with: aBinaryBlock [
   | newData |
   (self rank > 1 or: anObject rank > 1) ifTrue: [ ^ RankError signal ].
   "this is fundamentally broken. you cannot apply this as a scalar to every element of 'data'"
   "you must groupby and then perform"
   newData := data collect: [ :e | aBinaryBlock value: e asNDArray value: anObject asNDArray ].
   ^ self class new
        withShape: {
              self data size.
              anObject size}
        with: (newData collect: #asArray) flattened
]

{ #category : #'verbs (dyadic)' }
NDArray >> partition: anNDArray [ 
   ^ data with: anNDArray asNDArray data collect: #@
      :> groupByRuns: #y
      :> select: [ :e | e first y asBoolean ]
      :> collect: [ :e | (e collect: #x) asNDArray ]
      :> asNDArray
]

{ #category : #'instance creation' }
NDArray >> printOn: aStream [
   super printOn: aStream.
   aStream nextPutAll: ': '.
   data printOn: aStream.
   aStream nextPutAll: ' with shape: '. 
   shape printOn: aStream
]

{ #category : #accessing }
NDArray >> rank [
   ^ shape size
]

{ #category : #'verbs (monadic)' }
NDArray >> ravel [
   ^ self class new withAll: data
]

{ #category : #'verbs (monadic)' }
NDArray >> reciprocal [
   ^ self class new withShape: shape with: (data collect: #reciprocal)
]

{ #category : #adverbs }
NDArray >> reduce: aBlock [
   | newData |
   self rank = 1 ifTrue: [ ^ data reduce: aBlock ].
   newData := data groupsOf: shape last 
           :> collect: [ :e | e reduce: aBlock ] as: Array.
   ^ self class new withShape: shape allButLast with: newData
]

{ #category : #adverbs }
NDArray >> reduceFirst: aBinaryBlock [ 
   ^ self transpose reduce: aBinaryBlock
]

{ #category : #'verbs (dyadic)' }
NDArray >> reshape: aCollection [
   | n newData |
   n := aCollection product.
   newData := n ~~ shape product ifTrue: [ data cycle: n ] ifFalse: [ data ].
   ^ self class new withShape: aCollection with: newData
]

{ #category : #'verbs (monadic)' }
NDArray >> reverse [
   | newData |
   newData := data groupsOf: shape last 
           :> collect: [ :e | e reversed ] as: Array.
   ^ self class new withShape: shape with: newData
]

{ #category : #'verbs (scalar monadic)' }
NDArray >> roll [
   (data anySatisfy: #negative) ifTrue: [ ^ DomainError signal ].
   ^ self class new withShape: shape with: (data collect: [ :e | (1 to: e) atRandom ])

]

{ #category : #'verbs (dyadic)' }
NDArray >> rotate: anInteger [
   | newData |
   newData := data groupsOf: shape last 
           :> collect: [ :e | e rotate: anInteger ] as: Array.
   ^ self class new withShape: shape with: newData
]

{ #category : #adverbs }
NDArray >> scan: aBinaryBlock [
   | newData |
   newData := data groupsOf: shape last 
           :> collect: [ :e | e scan: aBinaryBlock ] as: Array.
   ^ self class new withShape: shape with: newData
]

{ #category : #accessing }
NDArray >> shape [
   ^ shape
]

{ #category : #'verbs (scalar monadic)' }
NDArray >> sign [
   ^ self class new withShape: shape with: (data collect: #sign)
]

{ #category : #accessing }
NDArray >> size [
   ^ shape last
]

{ #category : #'verbs (monadic)' }
NDArray >> split [
   self rank = 0 ifTrue: [ ^ self ].
   self rank = 1 ifTrue: [ ^ self enclose ].
   self rank = 2 ifTrue: [
      | newData |
      newData := (data groupsOf: shape last) collect: #asNDArray as: Array.
      ^ self class new withShape: shape allButLast with: newData ].
   ^ self error: 'Implement for higher ranks'
]

{ #category : #'verbs (monadic)' }
NDArray >> sum [
   ^ self reduce: #+
]

{ #category : #'verbs (dyadic)' }
NDArray >> take: anInteger [
   anInteger isNDArray ifTrue: [ ^ self error: 'take: only supports integer parameter currently' ].
   self rank = 0 ifTrue: [ ^ data reshape: anInteger asArray ].
   self rank = 1 ifTrue: [ 
      data size >= anInteger ifTrue: [ ^ (data first: anInteger) asNDArray ]
                             ifFalse: [ ^ data , (Array new: (anInteger - data size) withAll: 0) ] ].
   ^ self error: 'Implement for higher ranks'
]

{ #category : #'verbs (monadic)' }
NDArray >> transpose [
   | chunkedData newData |
   self rank < 2 ifTrue: [ ^ self copy ].
   self rank > 3 ifTrue: [ ^ RankError signal ].
   chunkedData := self data groupsOf: shape last.
   newData := OrderedCollection new.
   1 to: shape last do: [ :i | newData add: (chunkedData collect: [ :row | row at: i ]) ].
   ^ self class new withShape: shape reversed with: newData flattened
]

{ #category : #'verbs (monadic)' }
NDArray >> unique [
   | atoms newData newShape |
   self rank = 0 ifTrue: [ ^ self ].
   self rank = 1 ifTrue: [ ^ self class new withAll: data unique ].
   atoms := shape allButFirst product.
   newData := (data groupsOf: atoms) asArray unique.
   newShape := (Array with: newData size) , shape allButFirst.
   ^ self class new withShape: newShape with: newData
]

{ #category : #'verbs (monadic)' }
NDArray >> uniqueMask [
   | atoms newData newShape |
   self rank = 0 ifTrue: [ ^ 1 ].
   self rank = 1 ifTrue: [ ^ self class new withAll: data uniqueMask ].
   atoms := shape allButFirst product.
   newData := (data groupsOf: atoms) asArray uniqueMask.
   newShape := Array with: shape first.
   ^ self class new withShape: newShape with: newData
]

{ #category : #'verbs (monadic)' }
NDArray >> where [
   self rank = 0 ifTrue: [ ^ RankError signal ].
   self rank = 1 ifTrue: [ 
      ^ data withIndexCollect: #@ 
         :> select: [ :p | p x == 1 ]
         :> collect: #y 
         :> asNDArray ].
   ^ self error: 'Implement for higher ranks'
]

{ #category : #adverbs }
NDArray >> windowed: anInteger reduce: aBinaryBlock [ 
   | coll |
   coll := OrderedCollection new.
   1 to: (self size - anInteger + 1) do: [ :i |
      coll add: ((data copyFrom: i to: i + anInteger - 1) reduce: aBinaryBlock).
   ].
   ^ self class new withAll: coll asArray 
]

{ #category : #'instance creation' }
NDArray >> withAll: aCollection [
   data := aCollection flattened.
   shape := aCollection shape
]

{ #category : #initialization }
NDArray >> withShape: aCollection with: anObject [
   shape := aCollection.
   data := anObject asArray flattened cycle: shape product
]

{ #category : #'verbs (dyadic)' }
NDArray >> without: anNDArray [
	self rank >= 2 ifTrue: [ ^ RankError signal ].
	^ (self data copyWithoutAll: anNDArray asNDArray data) asNDArray
]
