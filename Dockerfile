FROM ubuntu:19.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get install -y \
	   ca-certificates \
	   gettext \
	   bzip2 \
	   cmake \
	   g++ \
	   git \
	   locales \
	   make \
	   checkinstall \
	   openssh-server \wget
	   
	   
RUN update-locale LANG=C.UTF-8

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends\
      libpng-dev \
      libfreetype6-dev \
      libjpeg-dev \
      libexempi-dev \
      libfcgi-dev \
      libgdal-dev \
      libgeos-dev \
      libproj-dev \
      libxslt1-dev \
      swig3.0 \
      python3 \
      libpython3-dev \
      php7.2 \
      php7.2-dev \
      php7.2-curl \
      php7.2-xml \
      apache2 \
      apache2-utils \ 
      apache2-dev \
      libapache2-mod-wsgi \
      sudo \
      libapache2-mod-fcgid

RUN apt-get clean 
    
RUN wget https://download.osgeo.org/mapserver/mapserver-7.4.2.tar.gz
	  
RUN tar -xvzf mapserver-7.4.2.tar.gz
RUN mv mapserver-7.4.2 /usr/local/src/mapserver
	  
RUN mkdir /usr/local/src/mapserver/build && \
    cd /usr/local/src/mapserver/build && \
	  cmake ../ \
            -DCMAKE_INSTALL_PREFIX=/usr/local \
	    -DWITH_PROJ=ON \
            -DWITH_SOS=OFF \
            -DWITH_WMS=ON \
            -DWITH_FRIBIDI=OFF \
            -DWITH_HARFBUZZ=OFF \
            -DWITH_ICONV=OFF \
            -DWITH_CAIRO=OFF \
            -DWITH_SVGCAIRO=OFF \
            -DWITH_RSVG=OFF \
            -DWITH_MYSQL=OFF \
            -DWITH_FCGI=ON \        
            -DWITH_GEOS=ON \
            -DWITH_POSTGIS=ON \
            -DWITH_GDAL=ON \
            -DWITH_OGR=ON \
            -DWITH_CURL=ON \
            -DWITH_CLIENT_WMS=ON \
            -DWITH_CLIENT_WFS=ON \
            -DWITH_WFS=ON \
            -DWITH_WCS=ON \        
            -DWITH_LIBXML2=ON \
            -DWITH_THREAD_SAFETY=OFF \        
            -DWITH_GIF=OFF \
            -DWITH_PYTHON=ON \
            -DWITH_PHP=ON \
            -DWITH_PERL=OFF \
            -DWITH_RUBY=OFF \
            -DWITH_JAVA=OFF \
            -DWITH_CSHARP=OFF \
            -DWITH_ORACLESPATIAL=OFF \
            -DWITH_ORACLE_PLUGIN=OFF \
            -DWITH_MSSQL2008=OFF \
            -DWITH_EXEMPI=ON \
            -DWITH_XMLMAPFILE=ON \
            -DWITH_V8=OFF \
            -DBUILD_STATIC=OFF \
            -DLINK_STATIC_LIBMAPSERVER=OFF \
            -DWITH_APACHE_MODULE=OFF \
            -DWITH_GENERIC_NINT=OFF \
            -DWITH_USE_POINT_Z_M=ON \
            -DWITH_PROTOBUFC=OFF \
            -DCMAKE_PREFIX_PATH=/opt/gdal  && \
          make &&  \
          make install && \
          ldconfig

RUN chmod o+x /usr/local/bin/mapserv

RUN  a2enmod actions cgi alias headers

CMD sudo service apache2 restart && bash

RUN ln -s /usr/local/bin/mapserv /usr/lib/cgi-bin/mapserv

RUN sed -i "918i extension=php_mapscript.so" /etc/php/7.2/apache2/php.ini

RUN sudo service apache2 restart
