test:
	#sbt 'testOnly pe.PEModuleTester'
	sbt 'test:runMain pe.PEMain --backend-name verilator'
run:
	sbt run
