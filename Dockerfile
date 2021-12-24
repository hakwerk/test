FROM ubuntu:focal

COPY tmp/bin /opt/boulder
COPY tmp/labca /opt/labca/bin/
COPY tmp/admin/setup.sh /opt/labca/
COPY tmp/admin/templates /opt/labca/templates/
