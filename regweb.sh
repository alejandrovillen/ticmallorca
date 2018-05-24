

# RegWeb3 installation

#Dependences
	apt-get install -y git unzip make python postgresql ant ant-optional

# Environment variables
	echo 'JBOSS="/usr/local/jboss-as"' | sudo tee --append /etc/environment
	echo 'PACKAGES="/opt/regweb/packages"' | sudo tee --append /etc/environment
	echo 'TICPACK="/opt/regweb/packages/ticmallorca"' | sudo tee --append /etc/environment
	source /etc/environment

# Directory
	mkdir /opt/regweb
	mkdir $PACKAGES
	mkdir $PACKAGES/RegWeb
	mkdir $PACKAGES/RegWeb/regweb
	mkdir $PACKAGES/JBossBug
	mkdir $PACKAGES/ColorJUnit
	mkdir $PACKAGES/Postgresql_driver
	mkdir /usr/local/jboss-as
	mkdir /usr/lib/jvm


# Packages
	cd $PACKAGES
	sudo git clone https://github.com/alejandrovillen/ticmallorca.git
	## JDK
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
		cd $PACKAGES/RegWeb
		wget https://github.com/GovernIB/registre/releases/download/registre-3.0.9/release-regweb3-3.0.9.zip
		wget https://github.com/GovernIB/registre/archive/registre-3.0.9.zip
		wget https://github.com/GovernIB/registre/archive/registre-3.0.9.tar.gz
		unzip release-regweb3-3.0.9.zip
		cp -r ./release-regweb3-3.0.9/* ./regweb
	## JBoss 5.1.0 GA
		cp -r $TICPACK/JBoss/* $JBOSS
	## JBoss Bug Fix
		cd $PACKAGES/JBossBug
		wget https://repository.jboss.org/nexus/content/repositories/root_repository/jboss/metadata/1.0.6.GA-brew/lib/jboss-metadata.jar
		# Apply the JBoss Bug Fix
		cp -r $PACKAGES/JBossBug/* $JBOSS/common/lib/
		cp  -r $PACKAGES/JBossBug/* $JBOSS/client/
	## JBoss CXF
		cp -r $TICPACK/JBossCXF/* $JBOSS
	## Color-JUnit
		cd $PACKAGES/ColorJUnit
		git clone https://github.com/eevans/color-junit
		cd color-junit
		make install
	## Postgresql Driver
		cd $PACKAGES/Postgresql_driver
		wget http://jdbc.postgresql.org/download/postgresql-8.4-703.jdbc3.jar
		cp -r $PACKAGES/Postgresql_driver/postgresql-8.4-703.jdbc3.jar -P $JBOSS/server/default/lib/
