# TIC Mallorca
<<<<<<< HEAD

**Environment variables**

<pre>
sudo mkdir /opt/regweb

// PACKAGES DIRECTORY
echo 'PACKAGES="/opt/regweb/packages"' | sudo tee --append /etc/environment
sudo mkdir /opt/regweb/packages

//JBOSS
echo 'JBOSS="/usr/local/jboss-as"' | sudo tee --append /etc/environment
sudo mkdir /usr/local/jboss-as

// UPDATE ENVIRONMENT VARIABLES
source /etc/environment
</pre>


'''Requirements'''

''JDK 1.7 (7u80)''
<pre>
// Make directory
sudo mkdir $PACKAGES/JDK

// Download package
// sudo wget http://download.oracle.com/otn/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz -P $PACKAGES/JDK
sudo wget https://github.com/alejandrovillen/ticmallorca/JDK/jdk-7u80-linux-x64.tar.gz -P $PACKAGES/JDK

// Unzip and move to jvm folder
sudo tar -xzvf $PACKAGES/JDK/jdk-7u80-linux-x64.tar.gz
sudo mkdir /usr/lib/jvm
sudo cp -R $PACKAGES/JDK/jdk1.7.0_80 /usr/lib/jvm/

// Update java versions (https://gist.github.com/senthil245/6093389)
sudo update-alternatives --install "/usr/bin/java" "java" \
"/usr/lib/jvm/jdk1.7.0_80/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" \
"/usr/lib/jvm/jdk1.7.0_80/bin/javac" 1
sudo update-alternatives --install "/usr/bin/javaws" "javaws" \
"/usr/lib/jvm/jdk1.7.0_80/bin/javaws" 1

// Select java 1.7 version
sudo update-alternatives --config java
</pre>

''ANT version 1.9.6''
<pre>
// sudo apt-get install -y ant ant-optional
</pre>

''POSTGRESQL''
<pre>
sudo apt-get install -y postgresql
</pre>

''GIT''
<pre>
sudo apt-get install git
</pre>

''Maven''
<pre>
sudo apt-get install maven
</pre>

''Unzip''
<pre>
sudo apt-get install unzip
</pre>

''Make''
<pre>
sudo apt-get install make
</pre>

''Python''
<pre>
sudo apt-get install python
</pre>

''RegWeb3 project 3.0.9''
<pre>
sudo mkdir $PACKAGES/RegWeb
cd $PACKAGES/RegWeb
sudo wget https://github.com/GovernIB/registre/releases/download/registre-3.0.9/release-regweb3-3.0.9.zip \
sudo wget https://github.com/GovernIB/registre/archive/registre-3.0.9.zip \
sudo wget https://github.com/GovernIB/registre/archive/registre-3.0.9.tar.gz
sudo unzip release-regweb3-3.0.9.zip
sudo mkdir regweb
sudo cp -r ./release-regweb3-3.0.9/* ./regweb
</pre>


''JBoss 5.1.0 GA''
<pre>
sudo mkdir $PACKAGES/JBoss
cd $PACKAGES/JBoss
sudo wget https://sourceforge.net/projects/jboss/files/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA-jdk6.zip/download
sudo unzip download -d ./
sudo cp -r ./jboss-5.1.0.GA/* $JBOSS
</pre>

''JBoss Bug Fix''
<pre>
sudo mkdir $PACKAGES/JBossBug
cd $PACKAGES/JBossBug
sudo wget https://repository.jboss.org/nexus/content/repositories/root_repository/jboss/metadata/1.0.6.GA-brew/lib/jboss-metadata.jar
// Apply the JBoss Bug Fix
sudo cp -r $PACKAGES/JBossBug/* $JBOSS/common/lib/
sudo cp  -r $PACKAGES/JBossBug/* $JBOSS/client/
</pre>

''JBoss CXF''
<pre>
sudo mkdir $PACKAGES/JBossCXF
cd $PACKAGES/JBossCXF
sudo wget http://download.jboss.org/jbossws/jbossws-cxf-3.4.1.GA.zip
sudo unzip jbossws-cxf-3.4.1.GA.zip
sudo cp -r $PACKAGES/JBossCXF/jbossws-cxf-bin-dist/* $JBOSS
</pre>

''Color-JUnit''
<pre>
sudo mkdir $PACKAGES/ColorJUnit
cd $PACKAGES/ColorJUnit
sudo git clone https://github.com/eevans/color-junit
cd color-junit
//sudo chmod +x Makefile
sudo make install
</pre>

''Postgresql Driver''
<pre>
sudo mkdir $PACKAGES/Postgresql_driver
cd $PACKAGES/Postgresql_driver
sudo wget http://jdbc.postgresql.org/download/postgresql-8.4-703.jdbc3.jar
sudo cp -r $PACKAGES/Postgresql_driver/postgresql-8.4-703.jdbc3.jar -P $JBOSS/server/default/lib/
</pre>


''DDBB''

<pre>
// Connect to ddbb
$ sudo bash <- hacemos que la consola tenga permisos de su
$ su postgres <- cambiamos el usuario con el que trabajaremos
$ psql -U postgres <- parece que se conecta en modo su

// Postgres version
postgres=# SELECT version();

// Get config file, this file contains the port to access to database ddbb, 5432.
postgres=# show config_file;
-- to access from external connections you must change this configuration. listen_addresses = '*' 
	sudo nano -c /etc/postgresql/9.5/main/postgresql.conf
-- to access from external connections you must change this configuration.  
	sudo nano -c /etc/postgresql/9.5/main/pg_hba.conf
		# TYPE DATABASE USER CIDR-ADDRESS  METHOD
		host    all             all             0.0.0.0/0               md5

	sudo service postgresql stop
	sudo service postgresql start



// List ddbb
postgres=# \list


// List users
postgres=# \du

// Delete ddbbs
postgres=# drop database regweb;
postgres=# drop database seycon;

// Delete schema
postgres=# drop schema regweb cascade;
postgres=# drop schema seycon cascade;

// Delete Role user
postgres=# reassign owned by regweb to postgres;
postgres=# drop owned by regweb;
postgres=# drop role regweb;
postgres=# reassign owned by seycon to postgres;
postgres=# drop owned by seycon;
postgres=# drop role seycon;

// Create user
postgres=# create user regweb with encrypted password 'regweb' nocreateuser; <- importante las comillas del password
postgres=# create user seycon with encrypted password 'seycon' nocreateuser; <- importante las comillas del password

// Create ddbb
postgres=# create database regweb with owner=regweb;
postgres=# create database seycon with owner=seycon;

// Schema list
postgres=# \dn


// Grant
postgres=# grant all privileges on database regweb to regweb;
postgres=# grant all privileges on database seycon to seycon;
postgres=# grant all privileges on schema public to regweb;
postgres=# grant all privileges on schema public to seycon;
// Exit
\q

// Import schema and data
psql -h localhost -p 5432 -U regweb -W -d regweb
regweb=> \i /opt/regweb/packages/RegWeb/regweb/scripts/bbdd/postgresql/regweb3_create_schema.sql
regweb=> \i /opt/regweb/packages/RegWeb/regweb/scripts/bbdd/postgresql/regweb3_create_data.sql

psql -h localhost -p 5432 -U seycon -W -d seycon
seycon=> \i /opt/regweb/packages/RegWeb/regweb/scripts/bbdd/postgresql/seycon_schema.sql
seycon=> \i /opt/regweb/packages/RegWeb/regweb/scripts/bbdd/postgresql/seycon_data_example.sql

// To exit
\q

</pre>





'''JBoss settings'''

''CXF content and config''
<pre>
sudo cp $JBOSS/ant.properties.example $JBOSS/ant.properties
sudo nano -c $JBOSS/ant.properties
	# Optional JBoss Home
	jboss510.home=/usr/local/jboss-as
	jbossws.integration.target=jboss510
cd $JBOSS
sudo ant deploy-jboss510
</pre>

''Update build-testsuite.xml''
-- at line 371 insert this attribute -> includeantruntime="false"
<pre>
sudo nano -c $JBOSS/tests/ant-import/build-testsuite.xml
</pre>

''Deploy folder''
-- Insert this tag <value>${jboss.server.home.url}deployregweb</value> at line28.
<pre>
sudo mkdir $JBOSS/server/default/deployregweb
sudo nano -c $JBOSS/server/default/conf/bootstrap/profile.xml
</pre>

''Public ports and upgrade memory size''
<pre>
sudo nano -c $JBOSS/bin/run.conf
-- Insert this at the end of file
	JAVA_OPTS="$JAVA_OPTS -Djboss.bind.address=0.0.0.0"
-- Change values at line45 
	-Xms512m -Xmx1303m -XX:MaxPermSize=256m
</pre>

''Multi Datasources''
<pre>
sudo nano -c $JBOSS/server/default/conf/jbossts-properties.xml
-- Insert this at line228 
	<property name="com.arjuna.ats.jta.allowMultipleLastResources" value="true" />	
</pre>

''Auth WSBASIC''
<pre>
sudo nano -c $JBOSS/server/default/deployers/jbossweb.deployer/META-INF/war-deployers-jboss-beans.xml
-- Insert this block at line158
	<entry>
	<key>WSBASIC</key>
	<value>org.apache.catalina.authenticator.BasicAuthenticator</value>
	</entry>
</pre>

''Parameters Size''
<pre>
sudo nano -c $JBOSS/server/default/deploy/properties-service.xml
-- Insert this at line42
<attribute name="Properties">
org.apache.tomcat.util.http.Parameters.MAX_COUNT=1000
</attribute>
</pre>

''File Settings''

File properties
<pre>
sudo mkdir -p $JBOSS/regweb_files
sudo chmod 777 $JBOSS/regweb_files
sudo cp -r $PACKAGES/RegWeb/regweb/scripts/config/regweb3-properties-service.xml $JBOSS/server/default/deployregweb
sudo nano -c $JBOSS/server/default/deployregweb/regweb3-properties-service.xml
-- Update this attributes
<attribute name="Properties">
	<!-- Others -->
	es.caib.regweb3.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
	# es.caib.regweb3.hibernate.query.substitutions=?
	es.caib.regweb3.dir3caib.server=http://gmpreregweb1.cilma.apl:8080/dir3caib
	es.caib.regweb3.dir3caib.username=****
    es.caib.regweb3.dir3caib.password=****
	es.caib.regweb3.sir.usedirectapi=false
	es.caib.regweb3.maxuploadsizeinbytes=104857600 
	# es.caib.regweb3.scan_default_validez_documento=?

	<!-- General -->
	es.caib.regweb3.defaultlanguage=ca
	es.caib.regweb3.showtimestamp=false

	<!-- Caib -->
	es.caib.regweb3.iscaib=false
	es.caib.regweb3.preregistre=http://www.caib.es

	<!-- Url de WS SIR -->
	es.caib.regweb3.sir.serverbase=http://localhost:8380/services

	<!-- Directorio base para los archivos generales -->
	es.caib.regweb3.archivos.path=/usr/local/jboss-as/regweb_files
</attribute>
</pre>

''User Auth''

<pre>
sudo nano -c $JBOSS/server/default/conf/login-config.xml
-- Configuration of DDBB. Insert at line130
	<application-policy name = "seycon">
		<authentication>
		<!-- DATABASE -->
		  <login-module code="org.jboss.security.auth.spi.DatabaseServerLoginModule" flag="suf$
			 <module-option name="dsJndiName">java:/es.caib.seycon.db.wl</module-option>
			 <module-option name="principalsQuery">
				select USU_PASS from SC_WL_USUARI where USU_CODI = ?
			 </module-option>
			 <module-option name="rolesQuery">
				select UGR_CODGRU,'Roles' from SC_WL_USUGRU where UGR_CODUSU = ?
			 </module-option>
		   </login-module>
		</authentication>
	  </application-policy>


sudo nano -c $JBOSS/server/default/deployregweb/seycon-ds.xml
-- Insert this
	<?xml version="1.0" encoding="UTF-8"?>
	<datasources>
	  <local-tx-datasource>
		<jndi-name>es.caib.regweb3.db</jndi-name>
		<!--  POSTGRESQL   -->
		<connection-url>jdbc:postgresql://172.19.0.119:5432/seycon</connection-url>
		<driver-class>org.postgresql.Driver</driver-class>
		<user-name>seycon</user-name>
		<password>seycon</password>
	  </local-tx-datasource>
	</datasources>
</pre>	
		
''Binary copy''

<pre>
sudo cp $PACKAGES/RegWeb/regweb/regweb3.ear $JBOSS/server/default/deployregweb
</pre>

''DataSources''

<pre>
sudo cp $PACKAGES/RegWeb/regweb/scripts/datasource/regweb3-ds.xml $JBOSS/server/default/deployregweb
</pre>

''Plugins''

<pre>
sudo nano -c $JBOSS/server/default/deployregweb/regweb3-properties-service.xml
-- User information
<!-- ======== PLUGIN USER-INFORMATION - DATABASE ======= -->
es.caib.regweb3.userinformationplugin=org.fundaciobit.plugins.userinformation.database.DataBaseUserInformationPlugin
es.caib.regweb3.plugins.userinformation.database.jndi=java:/es.caib.seycon.db.wl
es.caib.regweb3.plugins.userinformation.database.users_table=SC_WL_USUARI
es.caib.regweb3.plugins.userinformation.database.username_column=USU_CODI
es.caib.regweb3.plugins.userinformation.database.administrationid_column=USU_NIF
es.caib.regweb3.plugins.userinformation.database.name_column=USU_NOM
#es.caib.regweb3.plugins.userinformation.database.surname_1_column
#es.caib.regweb3.plugins.userinformation.database.surname_2_column      
#es.caib.regweb3.plugins.userinformation.database.language_column
#es.caib.regweb3.plugins.userinformation.database.telephone_column
es.caib.regweb3.plugins.userinformation.database.email_column=USU_EMAIL
#es.caib.regweb3.plugins.userinformation.database.gender_column
#es.caib.regweb3.plugins.userinformation.database.password_column
es.caib.regweb3.plugins.userinformation.database.userroles_table=SC_WL_USUGRU
es.caib.regweb3.plugins.userinformation.database.userroles_rolename_column=UGR_CODGRU
es.caib.regweb3.plugins.userinformation.database.userroles_username_column=UGR_CODUSU

<!-- ======== PLUGIN USER-INFORMATION - LDAP ======= -->
<!--
es.caib.regweb3.userinformationplugin=org.fundaciobit.plugins.userinformation.ldap.LdapUserInformationPlugin
es.caib.regweb3.plugins.userinformation.ldap.host_url=ldap://ldap.ibit.org:389
es.caib.regweb3.plugins.userinformation.ldap.security_principal=[LDAPUSERNAME]
es.caib.regweb3.plugins.userinformation.ldap.security_authentication=simple
es.caib.regweb3.plugins.userinformation.ldap.security_credentials=[PASSWORD of LDAPUSERNAME]
es.caib.regweb3.plugins.userinformation.ldap.users_context_dn=cn=Users,dc=ibitnet,dc=lan
es.caib.regweb3.plugins.userinformation.ldap.search_scope=onelevel
es.caib.regweb3.plugins.userinformation.ldap.search_filter=(|(memberOf=CN=@PFI_ADMIN,CN=Users,DC=ibitnet,DC=lan)(memberOf=CN=@PFI_USER,CN=Users,DC=ibitnet,DC=lan))
es.caib.regweb3.plugins.userinformation.ldap.attribute.username=sAMAccountName
es.caib.regweb3.plugins.userinformation.ldap.attribute.mail=mail
es.caib.regweb3.plugins.userinformation.ldap.attribute.administration_id=postOfficeBox
es.caib.regweb3.plugins.userinformation.ldap.attribute.name=givenName
es.caib.regweb3.plugins.userinformation.ldap.attribute.surname=sn
es.caib.regweb3.plugins.userinformation.ldap.attribute.telephone=telephoneNumber
es.caib.regweb3.plugins.userinformation.ldap.attribute.memberof=memberOf
es.caib.regweb3.plugins.userinformation.ldap.prefix_role_match_memberof=CN=@
es.caib.regweb3.plugins.userinformation.ldap.suffix_role_match_memberof=,CN=Users,DC=ibitnet,DC=lan
-->

<!-- ======== PLUGIN DE CUSTODIA - FILESYSTEM ============== -->
es.caib.regweb3.annex.documentcustodyplugin=org.fundaciobit.plugins.documentcustody.filesystem.FileSystemDocumentCustodyPlugin
es.caib.regweb3.annex.plugins.documentcustody.filesystem.prefix=ANNEX_
es.caib.regweb3.annex.plugins.documentcustody.filesystem.basedir=/regweb-3.0-files/
# {0} = custodyID  i {1} = URL.Encoded(custodyID)
es.caib.regweb3.annex.plugins.documentcustody.filesystem.baseurl=http://localhost:8080/annexos/index.jsp?custodyID={1}

<!-- ======== PLUGIN SCANNER ======= -->
<!-- Possibles valors: [0:NO, 1: MMS, 2:DWT, 3:CAIB]-->
es.caib.regweb3.scan.plugins=

<!-- Sense escaneig -->
es.caib.regweb3.scan.plugin.0=

<!-- Altres plugins (disabled)-->
es.caib.regweb3.scan.plugin.1=es.fundaciobit.plugins.scanweb.scan_mmscomputing.MmsComputingScanWebPlugin
es.caib.regweb3.scan.plugin.1.plugins.scanweb.mmscomputing.resourcePath=/anexo/scanwebresource2/1/{0}/
es.caib.regweb3.scan.plugin.1.plugins.scanweb.mmscomputing.uploadPath=/anexo/guardarScan/{0}
es.caib.regweb3.scan.plugin.1.plugins.scanweb.mmscomputing.fileFieldName=RemoteFile
es.caib.regweb3.scan.plugin.1.plugins.scanweb.mmscomputing.submitButton=desaAnnex

<!-- Dynamic Web Twain -->
es.caib.regweb3.scan.plugin.2=es.limit.plugins.scanweb.dynamicwebtwain.DynamicWebTwainScanWebPlugin
es.caib.regweb3.scan.plugin.2.plugins.scanweb.dynamicwebtwain.applicationPath=regweb3

<!-- Applet CAIB -->
es.caib.regweb3.scan.plugin.3=

</pre>

''File Validation Server Service''

<pre>
sudo mkdir $JBOSS/server/default/deployregweb/custodia.war
cd $JBOSS/server/default/deployregweb/custodia.war
</pre>
=======
>>>>>>> a2429df33514a8d7f9539a91e463d4d22432352f
