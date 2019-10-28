
build: src/Main.elm
	elm make src/Main.elm --output=assets/main.js

develop: src/Main.elm views/index.html
	elm-live src/Main.elm --port=8080 --open --pushstate --start-page=views/index.html -- --output=assets/main.js
