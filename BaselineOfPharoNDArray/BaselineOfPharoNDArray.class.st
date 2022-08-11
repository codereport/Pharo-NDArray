Class {
	#name : #BaselineOfPharoNDArray,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoNDArray
}

{ #category : #baselines }
BaselineOfPharoNDArray >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
		"Dependencies"
		   spec 
				baseline: 'PharoFunctional' with: [ spec repository: 'github://dvmason/Pharo-Functional' ].
		"Packages"
			spec
				package: 'Pharo-NDArray' with: [ spec requires: #('PharoFunctional') ];
				package: 'Pharo-NDArray-Tests'  with: [ spec requires: #('Pharo-NDArray') ].
		"Groups"
			spec
				group: 'default' with: #('Pharo-NDArray');
				group: 'all' with: #('Pharo-NDArray' 'Pharo-NDArray-Tests' 'PharoFunctional')
		]
]
