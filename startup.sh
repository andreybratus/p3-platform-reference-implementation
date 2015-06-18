#!/bin/bash
# All ports based on https://github.com/fusepoolP3/overall-architecture/blob/master/default-ports.md

# Webserver for GUIs
/etc/init.d/lighttpd start
/usr/local/bin/wrapdocker

# LDP
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-ldp-marmotta.jar &                             # Port 8080
if [ -z "$LDPURI" ]; then
    echo ldp uri is set
    export LDPURI=http://localhost:8080/
fi

echo LDPURI: $LDPURI

su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-proxy.jar -T $LDPURI &                                    # Port 8181
# Others
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-transformer-web-client.jar &                   # Port 8151

# GUIs
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-dashboard.jar &                                # Port 8200
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-pipeline-gui.jar &                             # Port 8201
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-dictionary-matcher-factory-gui.jar &           # Port 8202
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-batchrefine-factory-gui.jar -P 8203 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-xslt-factory-gui.jar &                         # Port 8204
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-resource-gui.jar &                             # Port 8205

# Transformers
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-pipeline-transformer.jar -C &                  # Port 8300
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-dictionary-matcher-transformer.jar &           # Port 8301
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-geo-enriching-transformer.jar -P 8302 &
su p3 -s /usr/bin/java -- -Xmx1g -jar /usr/local/lib/p3-any23-transformer.jar &                 # Port 8303
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-stanbol-launcher.jar -p 8304 &                 # Port 8304
su p3 -s /usr/bin/java -- -Xmx2g -jar /usr/local/lib/p3-literal-extraction-transformer.jar &    # Port 8305
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-silkdedup.jar &                                # Port 8306
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-xslt-transformer.jar &                         # port 8307
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-geocoordinates-transformer.jar -P 8308 &
# TODO: p3-osm-transformer, punditTransformer, p3-bing-translate-transformer 


docker run -d -p 8386:80  danilogiacomi/pundit
docker run -p 8310:8310 fusepool/p3-batchrefine






