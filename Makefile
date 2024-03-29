default: versioncheck

clean:
	./gradlew clean

compile:
	./gradlew build -xtest

scan:
	./gradlew build --scan -xtest

build: compile

uberjar:
	./gradlew uberjar

uber: uberjar
	java -jar build/libs/server.jar

run:
	./gradlew run

tests:
	./gradlew check

dbinfo:
	./gradlew flywayInfo

dbclean:
	./gradlew flywayClean

dbmigrate:
	./gradlew flywayMigrate

dbreset: dbclean dbmigrate

dbvalidate:
	./gradlew flywayValidate

lint:
	./gradlew lintKotlinMain
	./gradlew lintKotlinTest

test:
	~/node_modules/.bin/cypress open

versioncheck:
	./gradlew dependencyUpdates

depends:
	./gradlew dependencies

upgrade-wrapper:
	./gradlew wrapper --gradle-version=7.2 --distribution-type=bin