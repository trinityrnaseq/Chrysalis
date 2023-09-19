all:
	mkdir -p build
	cd build && cmake -DCMAKE_INSTALL_PREFIX="" ../ && ${MAKE} DESTDIR=../ install

debug:
	mkdir -p build
	cd build && cmake -DCMAKE_INSTALL_PREFIX="" -DCMAKE_BUILD_TYPE=Debug ../ && ${MAKE} DESTDIR=../ install


clean:
	@echo cleaning
	(cd build && make clean) || :
	rm -rf ./build ./bin
