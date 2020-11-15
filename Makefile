test-pe:
	#sbt 'testOnly pe.PEModuleTester'
	sbt 'test:runMain pe.PEMain --backend-name verilator'
test-tile:
	sbt 'test:runMain pe.TileMain --backend-name verilator'
run:
	sbt run
