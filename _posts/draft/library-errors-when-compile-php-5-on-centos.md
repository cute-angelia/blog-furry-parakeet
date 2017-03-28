title:  在CentOS编译PHP5相关错误和解决办法
date: 2015-07-08 04:01:21
tags: [centos, php, build]
---

=================================

    checking for BZip2 support… yes
    checking for BZip2 in default path… not found
    configure: error: Please reinstall the BZip2 distribution

Fix:
    
    yum install bzip2-devel
    
=================================

    checking for cURL support… yes
    checking if we should use cURL for url streams… no
    checking for cURL in default path… not found
    configure: error: Please reinstall the libcurl distribution -
    easy.h should be in /include/curl/


Fix:

    yum install curl-devel
    
=================================

    checking for curl_multi_strerror in -lcurl… yes
    checking for QDBM support… no
    checking for GDBM support… no
    checking for NDBM support… no
    configure: error: DBA: Could not find necessary header file(s).


Fix:

    yum install db4-devel
    

<!-- more -->


=================================
    
    checking for fabsf… yes
    checking for floorf… yes
    configure: error: jpeglib.h not found.


Fix:

    yum install libjpeg-devel
    
=================================
    
    checking for fabsf… yes
    checking for floorf… yes
    checking for jpeg_read_header in -ljpeg… yes
    configure: error: png.h not found.


Fix:

    yum install libpng-devel
    
=================================

    checking for png_write_image in -lpng… yes
    If configure fails try –with-xpm-dir= configure: error: freetype.h not found.


Fix: 

    Reconfigure your PHP with the following option.
    --with-xpm-dir=/usr 
    
=================================

    checking for png_write_image in -lpng… yes
    configure: error: libXpm.(a|so) not found.

Fix:

    yum install libXpm-devel
    
=================================

    checking for bind_textdomain_codeset in -lc… yes
    checking for GNU MP support… yes
    configure: error: Unable to locate gmp.h

Fix:

    yum install gmp-devel
    
=================================

    checking for utf8_mime2text signature… new
    checking for U8T_DECOMPOSE…
    configure: error: utf8_mime2text() has new signature, but U8T_CANONICAL is
    missing. This should not happen. Check config.log for additional information.

Fix:

    yum install libc-client-devel
    
=================================

    checking for LDAP support… yes, shared
    checking for LDAP Cyrus SASL support… yes
    configure: error: Cannot find ldap.h

Fix:
    yum install openldap-devel
    
=================================
   
    configure: error: Cannot find ldap libraries in /usr/lib 

Fix:

    --with-libdir=lib64
    
=================================

    checking for mysql_set_character_set in -lmysqlclient… yes
    checking for mysql_stmt_next_result in -lmysqlclient… no
    checking for Oracle Database OCI8 support… no
    checking for unixODBC support… configure: error: ODBC header
    file ‘/usr/include/sqlext.h’ not found!

Fix: 

    yum install unixODBC-devel
    
=================================

    checking for PostgreSQL support for PDO… yes, shared
    checking for pg_config… not found
    configure: error: Cannot find libpq-fe.h. Please specify correct
    PostgreSQL installation path
    
Fix:

    yum install postgresql-devel
    
=================================

    checking for sqlite 3 support for PDO… yes, shared
    checking for PDO includes… (cached) /usr/local/src/php-5.3.7/ext
    checking for sqlite3 files in default path… not found
    configure: error: Please reinstall the sqlite3 distribution

Fix:

    yum install sqlite-devel
    
=================================

    checking for utsname.domainname… yes
    checking for PSPELL support… yes
    configure: error: Cannot find pspell
Fix:

    yum install aspell-devel
=================================

    checking whether to enable UCD SNMP hack… yes
    checking for default_store.h… no checking for kstat_read in -lkstat… no
    checking for snmp_parse_oid in -lsnmp… no
    checking for init_snmp in -lsnmp… no
    configure: error: SNMP sanity check failed. Please check config.log for
    more information.
    
Fix:

    yum install net-snmp-devel
    
=================================

    checking whether to enable XMLWriter support… yes, shared
    checking for xml2-config path… (cached) /usr/bin/xml2-config
    checking whether libxml build works… (cached) yes
    checking for XSL support… yes, shared
    configure: error: xslt-config not found. Please reinstall the libxslt &gt;=
    1.1.0 distribution
    
Fix:

    yum install libxslt-devel
    
=================================

    configure: error: xml2-config not found. Please check your libxml2
    installation.

Fix:

    yum install libxml2-devel
=================================

    checking for PCRE headers location… configure: error: Could not find
    pcre.h in /usr
Fix:
    yum install pcre-devel
=================================
    
    configure: error: Cannot find MySQL header files under yes.
    Note that the MySQL client library is not bundled anymore!
Fix:

    yum install mysql-devel
    
=================================

    checking for unixODBC support… configure: error: ODBC header
    file ‘/usr/include/sqlext.h’ not found!
Fix:

    yum install unixODBC-devel
    
=================================

    checking for pg_config… not found
    configure: error: Cannot find libpq-fe.h. Please specify correct
    PostgreSQL installation path
Fix: 

    yum install postgresql-devel
    
=================================

    configure: error: Cannot find pspell
    
Fix:
    
    yum install pspell-devel
    
=================================

    configure: error: Could not find net-snmp-config binary. Please check your
    net-snmp installation.
    
Fix:

    yum install net-snmp-devel
    
=================================

    configure: error: xslt-config not found. Please reinstall the libxslt &gt;=
    1.1.0 distribution
Fix:

    yum install libxslt-devel
    
=================================

> [原文](http://supportlobby.com/library-errors-when-compile-php-5-on-centos/)
