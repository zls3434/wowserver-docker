ifeq ($(OS),Windows_NT)
	DATE:=$(shell echo %date:~0,4%%date:~5,2%%date:~8,2%)
else
	DATE:=$(shell date +"%Y%m%d")
endif

download:
	@if [ ! -d "TrinityCore" ]; then \
	    git clone -b 3.3.5 https://github.com/TrinityCore/TrinityCore.git; \
	else \
	    cd TrinityCore && git pull origin 3.3.5; \
	    cd ..; \
	fi

prebuild:
	docker build -t zls3434/wow-build:latest -f build.Dockerfile .
	docker build -t zls3434/wow-base:latest -f base.Dockerfile .

build:
	@if [ ! -d "dist" ]; then \
	    mkdir dist; \
	fi
	docker run --rm -it \
	  -v ./TrinityCore:/build/TrinityCore \
	  -v ./dist:/wowserver \
	  -w /build/TrinityCore/build \
	  zls3434/wow-build:latest \
	  -c 'cmake ../ -DCMAKE_INSTALL_PREFIX=/wowserver && make && make install'
	docker build -t zls3434/wowserver-auth:v3.3.5-$(DATE) -f auth.Dockerfile .
	docker build -t zls3434/wowserver-world:v3.3.5-$(DATE) -f world.Dockerfile .

