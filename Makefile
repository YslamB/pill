include .env

dev:
	@echo "Running the app..."
	@go run main.go
db:
	@echo "Initializing pharmacy database..."
	@psql -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER) -d $(DB_NAME)\
		-f ./pkg/database/init/create.sql
	@psql -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER) -d $(DB_NAME)\
		-f ./pkg/database/init/insert.sql
	@echo "Has been successfully migrated"
build:
	@echo "Building the app, please wait..."
	@go build -o ./bin/pharmacy main.go
	@echo "Done."
build-cross:
	@echo "Bulding for windows, linux and macos (darwin m2), please wait..."
	@GOOS=linux GOARCH=amd64 go build -o ./bin/pharmacy-linux main.go
	@GOOS=darwin GOARCH=arm64 go build -o ./bin/pharmacy-macos main.go
	@GOOS=windows GOARCH=amd64 go build -o ./bin/pharmacy-windows main.go
	@echo "Done."
deploy:
	scp ./bin/pharmacy-linux pharmacy@255.255.255.255:/var/www/pharmacy/
deploy-db:
	scp -r ./database/init pharmacy@255.255.255.255:/var/www/pharmacy/
