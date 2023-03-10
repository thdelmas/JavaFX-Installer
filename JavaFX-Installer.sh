#!/bin/bash

URL="https://download2.gluonhq.com/openjfx/19.0.2.1/openjfx-19.0.2.1_linux-x64_bin-sdk.zip"

DEST="/usr/lib"
export PATH_TO_FX=$DEST"/$(ls $DEST | grep javafx-sdk)/lib"


if ! java -version 2>&-
then
	echo java isn\'t installed
	sudo apt update
	sudo apt install -y default-jdk
	if ! java -version 2>&-
	then
		echo failed to install java
		exit 1
	else
		echo java installed
		export JAVA_HOME="$(
		update-alternatives --config java | grep bin | rev | cut -d' ' -f1 | rev
		)"
	fi

fi

curl -fsSL "$URL" --output openjfx.zip
sudo unzip openjfx.zip -d "$DEST"
rm openjfx.zip


curl -fsSL 'https://raw.githubusercontent.com/openjfx/samples/master/HelloFX/CLI/hellofx/HelloFX.java' --output HelloFX.java

javac --module-path $PATH_TO_FX --add-modules javafx.controls HelloFX.java
java --module-path $PATH_TO_FX --add-modules javafx.controls HelloFX

rm HelloFX.java HelloFX.class

echo "You should add the following line to your shrc
  export PATH_TO_FX=$PATH_TO_FX
  export JAVA_HOME=$JAVA_HOME"
