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
   ^ self genericScalarDyadic: anObject with: #*
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> ** anObject [
   ^ self class new withShape: shape with: (data collect: #** @@ anObject)
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> + anObject [
   ^ self genericScalarDyadic: anObject with: #+
]

{ #category : #'verbs (dyadic)' }
NDArray >> , anObject [
   (self rank = 1) ifFalse: [ ^ RankError signal ]. "TODO"
   (anObject asNDArray rank > 1) ifTrue: [ ^ RankError signal ]. "TODO"
   (anObject asNDArray rank = 1) ifTrue: [ 
        ^ (data , anObject data) asNDArray
	 ].
   ^ (data , {anObject}) asNDArray.
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> - anObject [
   ^ self genericScalarDyadic: anObject with: #-
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> / anObject [
   ^ self genericScalarDyadic: anObject with: #/
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> < anObject [
   self rank = 0 ifTrue: [ ^ anObject > data first ].
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
   self rank = 0 ifTrue: [ ^ anObject <= data first ].
   ^ self class new withShape: shape with: (data collect: [ :e | (e >= anObject) asBit ])
]

{ #category : #'verbs (scalar monadic)' }
NDArray >> abs [
   ^ self class new withShape: shape with: (data collect: #abs)
]

{ #category : #arithmetic }
NDArray >> adaptToNumber: aNumber andSend: aSymbol [
	"^ aNumber asNDArray perform: aSymbol with: self"
	^ self perform: (aSymbol commuted) with: aNumber
"   aSymbol = #+ ifTrue: [ ^ self + aNumber ].
   aSymbol = #= ifTrue: [ ^ self = aNumber ].
   aSymbol = #* ifTrue: [ ^ self * aNumber ].
   aSymbol = #< ifTrue: [ ^ self > aNumber ].
   aSymbol = #> ifTrue: [ ^ self < aNumber ].
   aSymbol = #<= ifTrue: [ ^ self >= aNumber ].
   aSymbol = #>= ifTrue: [ ^ self <= aNumber ].
   aSymbol = #min: ifTrue: [ ^ self min: aNumber ]"
]

{ #category : #'verbs (monadic)' }
NDArray >> all [
   ^ self reduce: #and:
]

{ #category : #'trains / combinators' }
NDArray >> and: anNDArray with: a atop: b [ 
   "This is known as the B1 combinator from Combinatory Logic and the 'blackbird' from Combinator Birds"
   a numArgsAsBlock = 2 ifFalse: [ ^ ArityError signal ].
   b numArgsAsBlock = 1 ifFalse: [ ^ ArityError signal ].
   ^ b value: (a value: self value: anNDArray)
]

{ #category : #'trains / combinators' }
NDArray >> and: anNDArray with: f backHook: g [
   "This is known as the D combinator from Combinatory Logic and the 'dove' from Combinator Birds"
   f numArgsAsBlock = 1 ifFalse: [ ^ ArityError signal ].
   g numArgsAsBlock = 2 ifFalse: [ ^ ArityError signal ].
   ^ g value: (f value: self) value: anNDArray
]

{ #category : #'trains / combinators' }
NDArray >> and: anNDarray with: a fork: b and: c [
   "This is a specialization of the E^ combinator from Combinatory Logic and the 'bald eagle' from Combinator Birds"
   a numArgsAsBlock = 2 ifFalse: [ ^ ArityError signal ].
   b numArgsAsBlock = 2 ifFalse: [ ^ ArityError signal ].
   c numArgsAsBlock = 2 ifFalse: [ ^ ArityError signal ].
   ^ b value: (a value: self value: anNDarray) value: (b value: self value: anNDarray)
]

{ #category : #'trains / combinators' }
NDArray >> and: anNDArray with: f hook: g [
   "This is known as the D combinator from Combinatory Logic and the 'dove' from Combinator Birds"
   f numArgsAsBlock = 2 ifFalse: [ ^ ArityError signal ].
   g numArgsAsBlock = 1 ifFalse: [ ^ ArityError signal ].
   ^ f value: self value: (g value: anNDArray).
]

{ #category : #'trains / combinators' }
NDArray >> and: anObject with: f over: g [
   "This is also known as the Psi combinator, 'on' in Haskell and 'over' in APL and BQN"
   f numArgsAsBlock = 2 ifFalse: [ ^ ArityError signal ].
   g numArgsAsBlock = 1 ifFalse: [ ^ ArityError signal ].
   ^ f value: (g value: self) value: (g value: anObject)
]

{ #category : #'verbs (monadic)' }
NDArray >> any [
   ^ self reduce: #or:
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
   anInteger isInteger ifFalse: [ ^ InvalidArgumentError signal ].
   self rank > 1 ifTrue: [ ^ NotYetImplemented signal ].
   self rank = 0 ifTrue: [ 
      anInteger = 0 ifTrue: [ ^ self ]
         ifFalse: [ ^ #() asNDArray ]
      ].
   data size >= anInteger ifTrue: [ 
      ^ (data last: data size - anInteger) asNDArray ]
      ifFalse: [ ^ #() asNDArray ]
]

{ #category : #'trains / combinators' }
NDArray >> dupWith: aFullBlockClosure [
   "This is the W combinator and the Warbler bird. It is known as Self(ie) in APL and Self in BQN.
    The name DUP is taken from FORTH (and other stack based languages)."
	^ aFullBlockClosure value: self value: self
]

{ #category : #'trains / combinators' }
NDArray >> dupWith: f atop: g [
   "This does not map to a combinator from Combinatory Logic"
   f numArgsAsBlock = 1 ifFalse: [ ^ ArityError signal ].
   g numArgsAsBlock = 2 ifFalse: [ ^ ArityError signal ].
   ^ f value: (g value: self value: self)
]

{ #category : #'trains / combinators' }
NDArray >> dupWith: f backHook: g [
   "The name backhook is taken from I, a predecssor language to BQN."
   f numArgsAsBlock = 2 ifFalse: [ ^ ArityError signal ].
   g numArgsAsBlock = 1 ifFalse: [ ^ ArityError signal ].
   ^ g value: (f value: self) value: self
]

{ #category : #'trains / combinators' }
NDArray >> dupWith: a fork: b and: c [
   "This is known as the S' combinator from Combinatory Logic and the 'phoenix' from Combinator Birds"
   a numArgsAsBlock = 1 ifFalse: [ ^ ArityError signal ].
   b numArgsAsBlock = 2 ifFalse: [ ^ ArityError signal ].
   c numArgsAsBlock = 1 ifFalse: [ ^ ArityError signal ].
   ^ b value: (a value: self) value: (c value: self)
]

{ #category : #'trains / combinators' }
NDArray >> dupWith: f hook: g [
   "This is known as the S combinator from Combinatory Logic and the 'starling' from Combinator Birds"
   f numArgsAsBlock = 2 ifFalse: [ ^ ArityError signal ].
   g numArgsAsBlock = 1 ifFalse: [ ^ ArityError signal ].
   ^ f value: self value: (g value: self)
]

{ #category : #'trains / combinators' }
NDArray >> dupWith: f over: g [
   "This does not map to a combinator from Combinatory Logic"
   f numArgsAsBlock = 2 ifFalse: [ ^ ArityError signal ].
   g numArgsAsBlock = 1 ifFalse: [ ^ ArityError signal ].
   ^ f value: (g value: self) value: (g value: self)
]

{ #category : #'verbs (monadic)' }
NDArray >> enlist [
	^ (data collect: [ :e | e data ]) flattened asNDArray 
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

{ #category : #'trains / combinators' }
NDArray >> flip: anNDArray with: f [
   "This is known as the C combinator from Combinatory Logic and the 'cardinal' from Combinator Birds"
   "It is known as flip in Haskell and swap in APL/BQN"
   f numArgsAsBlock = 2 ifFalse: [ ^ ArityError signal ].
   ^ f value: anNDArray value: self.
]

{ #category : #'verbs (scalar monadic)' }
NDArray >> floor [
   ^ self class new withShape: shape with: (data collect: #floor)
]

{ #category : #'verbs (dyadic)' }
NDArray >> gather: anNDArray [
   (self rank = 1 and: anNDArray rank = 1) ifFalse: [ ^ RankError signal ].
   ^ self class new withShape: anNDArray shape with: (anNDArray asNDArray collect: [ :i | i = 0 ifTrue: [ 0 ] ifFalse: [data at: i ]])
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> genericScalarDyadic: anObject with: aBlock [
   | rank0 shapesEqual |
   rank0 := self rank = 0 or: anObject rank = 0.
   shapesEqual := shape = anObject shape.
   (rank0 not and: shapesEqual not) ifTrue: [ ^ ShapeError signal ].
   shapesEqual ifTrue: [ 
      ^ self class new withShape: shape
           with:
           (self data with: anObject data
               collect: aBlock)
      ].
   ^ self class new withShape: shape
        with: (data collect: aBlock @@ anObject)
]

{ #category : #'verbs (monadic)' }
NDArray >> indices [
   | newData |
   self max > 1 ifTrue: [ ^ DomainError signal ].
   self min < 0 ifTrue: [ ^ DomainError signal ].
   self rank > 1 ifTrue: [ ^ NotYetImplemented signal ].
   newData := self data collectWithIndex: #@
           :> select: [ :p | p x = 1 ]
           :> collect: #y.
   ^ newData asNDArray
]

{ #category : #'verbs (dyadic)' }
NDArray >> intersection: anNDArray [
   (self rank = 1 and: anNDArray rank = 1) ifFalse: [ ^ RankError signal ].
   ^ (data intersection: anNDArray data) asNDArray
]

{ #category : #'verbs (scalar monadic)' }
NDArray >> ints [
   ^ self class new withShape: shape with: (data collect: #asInteger)
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

{ #category : #testing }
NDArray >> isEmpty [
   ^ data isEmpty
]

{ #category : #accessing }
NDArray >> isNDArray [
   ^ true
]

{ #category : #accessing }
NDArray >> isNested [
   ^ self first isNDArray
]

{ #category : #'verbs (monadic)' }
NDArray >> last [
   ^ data last
]

{ #category : #'verbs (dyadic)' }
NDArray >> matches: anObject [
   self shape = anObject asNDArray shape ifFalse: [ ^ false ].
   ^ self data = anObject asNDArray data
]

{ #category : #'verbs (monadic)' }
NDArray >> max [
   ^ self reduce: #max:
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> max: aNumber [
   ^ self genericScalarDyadic: aNumber with: #max:
]

{ #category : #'verbs (monadic)' }
NDArray >> maxs [
   "Name borrowed from q/kx: https://code.kx.com/q4m3/A_Built-in_Functions/#a52-maxs"
   ^ self scan: #max:
]

{ #category : #'verbs (dyadic)' }
NDArray >> memberOf: aNDArray [
   | hashedValues newData |
   self rank = 0 ifTrue: [ ^ self class new withShape: aNDArray shape with: (aNDArray data collect: [ :e | (e includes: data first) asBit ]) ].
   self rank = 1 ifTrue: [ 
      hashedValues := aNDArray asNDArray data asSet.
      newData := data collect: [ :e | (hashedValues includes: e) asBit ].
      ^ self class new withShape: shape with: newData ].
   ^ self error: 'Implement for higher ranks'
]

{ #category : #'verbs (monadic)' }
NDArray >> min [
   ^ self reduce: #min:
]

{ #category : #'verbs (scalar dyadic)' }
NDArray >> min: aNumber [
   ^ self genericScalarDyadic: aNumber with: #min:
]

{ #category : #'verbs (monadic)' }
NDArray >> mins [
   "Name borrowed from q/kx: https://code.kx.com/q4m3/A_Built-in_Functions/#a58-mins"
   ^ self scan: #min:
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
NDArray >> negated [
   ^ self class new withShape: shape with: (data collect: #negated)
]

{ #category : #'verbs (scalar monadic)' }
NDArray >> not [
   (data allSatisfy: #isBooleanValue) ifFalse: [ ^ DomainError signal ].
   ^ (self class new withShape: shape with: (data collect: #not)) ints
]

{ #category : #'verbs (dyadic)' }
NDArray >> notMatches: anObject [
   self shape = anObject asNDArray shape ifFalse: [ ^ true ].
   ^ (self data = anObject asNDArray data) not "TODO fix when != implemented"
]

{ #category : #adverbs }
NDArray >> outerProduct: anObject with: aBlock [
   | newData newShape |
   self rank > 1 ifTrue: [ ^ RankError signal ].
   anObject rank > 1 ifTrue: [ ^ RankError signal ].
   newData := anObject asNDArray collect: self @@ aBlock.
   newShape := { anObject size. self data size }.
   ^ self class new withShape: newShape with: newData enlist asArray
      :> transpose
]

{ #category : #'verbs (dyadic)' }
NDArray >> partition: anObject [
   ^ data with: anObject asNDArray data collect: #@
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

{ #category : #'verbs (scalar monadic)' }
NDArray >> reciprocal [
   ^ self class new withShape: shape with: (data collect: #reciprocal)
]

{ #category : #adverbs }
NDArray >> reduce: aBlock [
   | newData |
   self rank = 1 ifTrue: [ ^ data reduce: aBlock ].
   newData := data groupsOf: shape last 
           :> collect: (aBlock reduce)
           :> asArray.
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
   self data isEmpty ifTrue: [ ^ self ].
   newData := data groupsOf: shape last 
           :> collect: #reversed 
           :> asArray.
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
           :> collect: #rotate: @@ anInteger 
           :> asArray.		
   ^ self class new withShape: shape with: newData
]

{ #category : #adverbs }
NDArray >> scan: aBlock [
   | newData |
   newData := data groupsOf: shape last
           :> collect: (aBlock scan)
           :> asArray.
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
   shape isEmpty ifTrue: [ ^ 1 ].
   ^ shape first
]

{ #category : #'verbs (monadic)' }
NDArray >> sort [
   self rank > 1 ifTrue: [ ^ NotYetImplemented signal ].
   ^ self class new withShape: shape with: data sort
]

{ #category : #'verbs (monadic)' }
NDArray >> split [
   self rank = 0 ifTrue: [ ^ self ].
   self rank = 1 ifTrue: [ ^ self enclose ].
   self rank = 2 ifTrue: [ 
      | newData |
      newData := (data groupsOf: shape last) collect: #asNDArray
                    as: Array.
      ^ self class new withShape: shape allButLast with: newData
      ].
   ^ NotYetImplemented signal.
]

{ #category : #'verbs (monadic)' }
NDArray >> sum [
   ^ self reduce: #+
]

{ #category : #'verbs (monadic)' }
NDArray >> sums [
   "Name borrowed from q/kx: https://code.kx.com/q4m3/A_Built-in_Functions/#a92-sums"
   ^ self scan: #+
]

{ #category : #'verbs (dyadic)' }
NDArray >> take: anInteger [
   | n |
   anInteger isInteger ifFalse: [ ^ InvalidArgumentError signal ].
   self rank > 1 ifTrue: [ ^ NotYetImplemented signal ].
   self rank = 0 ifTrue: [ ^ data reshape: anInteger asArray ].
   n := data size min: anInteger.
   ^ ((data first: n) , (0 repeat: anInteger - n))
        asNDArray
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

{ #category : #adverbs }
NDArray >> triangleProduct2: aBinaryBlock [
   ^ (self outerProduct: self with: aBinaryBlock) split asArray with: self size iota collect: [ :a :i | a drop: i - 1 ]
]

{ #category : #adverbs }
NDArray >> triangleProduct: aBinaryBlock [
   ^ ((self outerProduct: self with: aBinaryBlock) split asArray with: self size iota collect: [ :a :i | a drop: i ]) asNDArray
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

{ #category : #adverbs }
NDArray >> upperProduct2: aBinaryBlock [
   | n |
   n := self size.
   ^ (self outerProduct: self with: aBinaryBlock) split asArray with: n iota collect: [ :a :i | ((a drop: i - 1) reverse take: n) reverse asNDArray ]
]

{ #category : #adverbs }
NDArray >> upperProduct: aBinaryBlock [
   | n |
   n := self size.
   ^ (self outerProduct: self with: aBinaryBlock) split asArray
        with: n iota
        collect: [ :a :i | ((a drop: i) reverse take: n) reverse asNDArray ]
]

{ #category : #adverbs }
NDArray >> windowed: anInteger reduce: aBlock [
   | n newData fold |
   self rank = 0 ifTrue: [ ^ RankError signal ].
   self rank > 1 ifTrue: [ ^ NotYetImplemented ].
   anInteger isInteger ifFalse: [ ^ InvalidArgumentError signal ].
   anInteger > self size ifTrue: [ ^ ShapeError signal ].
   n := self size - anInteger + 1.
   fold := [ :i :j | (data copyFrom: i to: j) reduce: aBlock ].
   newData := n iota with: n iota + anInteger - 1
                 collect: fold.
   ^ self class new withAll: newData asArray
]

{ #category : #'trains / combinators' }
NDArray >> with: f atop: g [
   "This is known as the B cominator from Combinatory Logic and also the 'bluebird."
   "It is called 'compose' in most languages and is . in Haskell"
   f numArgsAsBlock = 1 ifFalse: [ ^ ArityError signal ].
   g numArgsAsBlock = 1 ifFalse: [ ^ ArityError signal ].
   ^ f value: (g value: self)
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
