#!/bin/bash


. ${_NSRC}/core/functions.sh 

repository_url="https://repulpmaster.unx.sas.com/pulp/repos/release-latest/svi/104.0/svi-104.0.0-x64_redhat_linux_6-yum-latest/Packages/s/"
package_name="orchestration-cli"

download_and_unpackage_latest_rpm ${repository_url} ${package_name}
