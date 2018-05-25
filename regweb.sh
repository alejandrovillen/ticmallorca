#!/bin/bash

# RegWeb3 installation

#Dependences
	read -p "Press to install dependences"
	apt-get install -y git unzip make python postgresql ant ant-optional

# Environment variables
	read -p "Press to set environment variables"
	echo 'JBOSS="/usr/local/jboss-as"' | sudo tee --append /etc/environment
	echo 'PACKAGES="/opt/regweb/packages"' | sudo tee --append /etc/environment
	echo 'TICPACK="/opt/regweb/packages/ticmallorca"' | sudo tee --append /etc/environment
	source /etc/environment


# Directory
	read -p "Press to create directories"
	mkdir -p /opt/regweb
	mkdir -p $PACKAGES
	mkdir -p $PACKAGES/RegWeb
	mkdir -p $PACKAGES/RegWeb/regweb
	mkdir -p $PACKAGES/JBossBug
	mkdir -p $PACKAGES/ColorJUnit
	mkdir -p $PACKAGES/Postgresql_driver
	mkdir -p $TICPACK
	mkdir -p $JBOSS
	mkdir -p $JBOSS/server/default/deployregweb
	mdkir -p $JBOSS/server/default/lib/
	mkdir -p $JBOSS/regweb_files
	mkdir -p $JBOSS/dir3caib_files
	mkdir -p /usr/lib/jvm

# Init
	read -p "Press to init TICPACK"
	mv ./dist/* $TICPACK
	
# Packages
	## JDK
		read -p "Press to install JDK"
		cp -R $TICPACK/JDK/jdk1.7.0_80 /usr/lib/jvm/
		# Update java versions (https://gist.github.com/senthil245/6093389)
		sudo update-alternatives --install "/usr/bin/java" "java" \
		"/usr/lib/jvm/jdk1.7.0_80/bin/java" 1
		sudo update-alternatives --install "/usr/bin/javac" "javac" \
		"/usr/lib/jvm/jdk1.7.0_80/bin/javac" 1
		sudo update-alternatives --install "/usr/bin/javaws" "javaws" \
		"/usr/lib/jvm/jdk1.7.0_80/bin/javaws" 1
		# Select java 1.7 version
		sudo update-alternatives --config java
	## RegWeb3 release 3.0.9
		read -p "Press to install RegWeb3"
		cd $PACKAGES/RegWeb
		wget https://github.com/GovernIB/registre/releases/download/registre-3.0.9/release-regweb3-3.0.9.zip
		unzip release-regweb3-3.0.9.zip
		cp -r ./release-regweb3-3.0.9/* ./regweb
		cp ./regweb/regweb3.ear $JBOSS/server/default/deployregweb
	## JBoss 5.1.0 GA
		read -p "Press to install JBoss 5.1.0 GA"
		cp -r $TICPACK/JBoss/* $JBOSS
	## JBoss Bug Fix
		read -p "Press to install JBoss Fix"
		cd $PACKAGES/JBossBug
		wget https://repository.jboss.org/nexus/content/repositories/root_repository/jboss/metadata/1.0.6.GA-brew/lib/jboss-metadata.jar
		# Apply the JBoss Bug Fix
		cp -r $PACKAGES/JBossBug/* $JBOSS/common/lib/
		cp  -r $PACKAGES/JBossBug/* $JBOSS/client/
	## JBoss CXF
		read -p "Press to install JBoss CXF"
		cp -r $TICPACK/JBossCXF/* $JBOSS
	## Color-JUnit
		read -p "Press to install Color-JUnit"
		cd $PACKAGES/ColorJUnit
		git clone https://github.com/eevans/color-junit
		cd color-junit
		make install
	## Postgresql Driver
		read -p "Press to install PostgresDriver"
		cd $PACKAGES/Postgresql_driver
		wget http://jdbc.postgresql.org/download/postgresql-8.4-703.jdbc3.jar
		cp -r $PACKAGES/Postgresql_driver/postgresql-8.4-703.jdbc3.jar -P $JBOSS/server/default/lib/

# Settings
	read -p "Press to configure settings"
	## CXF content and config
		cp $TICPACK/App/regweb/ant.properties $JBOSS
	## Update build-testsuite.xml
		cp $TICPACK/App/regweb/build-testsuite.xml $JBOSS/tests/ant-import/
	## Deploy folder
		cp $TICPACK/App/regweb/profile.xml $JBOSS/server/default/conf/bootstrap/
	## Public ports and upgrade memory size
		cp $TICPACK/App/regweb/run.conf $JBOSS/bin/
	## MultiDatasources
		cp $TICPACK/App/regweb/jbossts-properties.xml $JBOSS/server/default/conf/
	## Auth Basic
		cp $TICPACK/App/regweb/war-deployers-jboss-beans.xml $JBOSS/server/default/deployers/jbossweb.deployer/META-INF/
	## Parameters Size
		cp $TICPACK/App/regweb/properties-service.xml $JBOSS/server/default/deploy/
	## File settings
		chmod 777 $JBOSS/regweb_files
		cp $TICPACK/App/regweb/regweb3-properties-service.xml $JBOSS/server/default/deployregweb/
	## User Auth
		cp $TICPACK/App/regweb/login-config.xml $JBOSS/server/default/conf/
	## Seycon DataSource
		cp $PACKAGES/RegWeb/regweb/scripts/datasource/seycon-ds.xml $JBOSS/server/default/deployregweb/
	## Regweb3 Datasource
		cp $PACKAGES/RegWeb/regweb/scripts/datasource/regweb3-ds.xml $JBOSS/server/default/deployregweb/
	## Binary Copy
		cp $PACKAGES/RegWeb/regweb/regweb3.ear $JBOSS/server/default/deployregweb
	## Plugins 
		### All changes over regweb3-properties-service.xml
		### DATABASE
		### LDAP
		### FILESYSTEM - CUSTODIA
		### SCANER
		### WEB TWAIN
	## Postgresql Config
		cp $TICPACK/Databases/postgresql/postgresql.conf /etc/postgresql/9.5/main/
		cp $TICPACK/Databases/postgresql/pg_hba.conf /etc/postgresql/9.5/main/
		service postgresql stop
		service postgresql start

# Services
	## JBOSS Service
		read -p "Press to setup JBoss service"
		cp $TICPACK/App/regweb/jboss /etc/init.d/
		chmod 777 /etc/init.d/jboss
		update-rc.d jboss defaults
		update-rc.d jboss enable
		/etc/init.d/jboss start
	## 



	
