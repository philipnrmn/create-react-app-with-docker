IMG=node
V=10.16.0-alpine

.PHONY: clean env deps run dist
clean:
	rm -rf app/node_modules app/dist

env:
	docker run -it -v "$(shell pwd):/home/node:Z" -w=/home/node -u node $(IMG):$(V) npx create-react-app .
add:
ifdef PACKAGE
	docker run -it -v "$(shell pwd):/home/node:Z" -w=/home/node/app -u node $(IMG):$(V) npm install $(PKG)
	PACKAGE=""
else
	@echo "set PACKAGE in your environment before calling make add, e.g.:"
	@echo "PACKAGE=lodash make add"
endif

deps:
	docker run -it -v "$(shell pwd):/home/node:Z" -w=/home/node/app -u node $(IMG):$(V) npm install

run:
	docker run -it -v "$(shell pwd):/home/node:Z" -p 3000:3000 -w=/home/node/app -u node $(IMG):$(V) npm start

dist:
	docker run -it -v "$(shell pwd):/home/node:Z" -w=/home/node/app -u node $(IMG):$(V) npm run-script build
