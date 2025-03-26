# bin/bash
if [ "$1" = "-first" ]; then
	echo 'Installing requirements before the first run'
	# apt-get update && apt-get install openjdk-11-jre-headless ant -y --no-install-recommend
	./scripts/sh/dl_saxon.sh
	pip install -U pip
	pip install -r requirements.txt
fi
./scripts/sh/fetch_data.sh
python ./scripts/py/renameGraphicNames.py
ant add-graphic-url -f scripts/ant/build.xml
ant build-editions -f scripts/ant/build.xml
python ./scripts/py/renameFiles.py
