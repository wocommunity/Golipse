#!/bin/bash
ECLIPSE_URL=http://mirror.cc.vt.edu/pub/eclipse/eclipse/downloads/drops/R-3.6.1-201009090800/eclipse-SDK-3.6.1-macosx-cocoa-x86_64.tar.gz
P2_URL=https://gist.github.com/raw/609891/p2
WORKSPACE_MECHANIC_URL=http://wiki.objectstyle.org/confluence/download/attachments/8225785/WorkspaceMechanicExamples.zip
WORKSPACE_MECHANIC_FOLDER=~/.eclipse/mechanic
VERSION=`date +%s`

if [ "$#" -lt "1" -o "$#" -gt "2" ]; then
	echo "usage: $0 [install folder] [(optional) eclipse download url]"
	exit
fi

ECLIPSE_ARCHIVE_PATH=/tmp/eclipse_${VERSION}.tar.gz
P2_PATH=/tmp/p2_${VERSION}
WORKSPACE_MECHANIC_ARCHIVE_PATH=/tmp/WorkspaceMechanicExamples_${VERSION}.zip
ECLIPSE_INSTALL_FOLDER=$1

if [ $2 ]; then
	echo "Setting ECLIPSE_URL to $2"
	ECLIPSE_URL=$2
fi

# Grab Eclipse
if [ ! -e "${ECLIPSE_INSTALL_FOLDER}/Eclipse.app" ]; then
        if [ -e "${ECLIPSE_INSTALL_FOLDER}" ]; then
                ECLIPSE_INSTALL_FOLDER="${ECLIPSE_INSTALL_FOLDER}/eclipse_${VERSION}"
        fi

        echo "Downloading Eclipse ..."
        curl ${ECLIPSE_URL} -o "${ECLIPSE_ARCHIVE_PATH}"
        mkdir -p "${ECLIPSE_INSTALL_FOLDER}"
        cd "${ECLIPSE_INSTALL_FOLDER}"

        echo "Unarchiving Eclipse ..."
        tar -x -v --strip-components 1 -f "${ECLIPSE_ARCHIVE_PATH}"
fi

# Grab the Workspace Mechanic zip
if [ ! -e "${WORKSPACE_MECHANIC_FOLDER}" ]; then
        echo "Downloading the Workspace Mechanic scripts ..."
        curl ${WORKSPACE_MECHANIC_URL} -o "${WORKSPACE_MECHANIC_ARCHIVE_PATH}"
        WORKSPACE_MECHANIC_PARENT=`dirname "${WORKSPACE_MECHANIC_FOLDER}"`
        mkdir -p "${WORKSPACE_MECHANIC_PARENT}"
        cd "${WORKSPACE_MECHANIC_PARENT}"
        unzip "${WORKSPACE_MECHANIC_ARCHIVE_PATH}"
        rm "${WORKSPACE_MECHANIC_ARCHIVE_PATH}"
fi

# Grab the p2 script
echo "Downloading the Eclipse Plugin installer ..."
curl ${P2_URL} -o "${P2_PATH}"
chmod +x "${P2_PATH}"

# Install Plugins
echo "Downloading and Installing the recommended Eclipse plugins ..."
"${P2_PATH}" "${ECLIPSE_INSTALL_FOLDER}"\
 \
http://download.eclipse.org/releases/helios,\
http://dist.springsource.org/release/GRECLIPSE/e3.6,\
http://webobjects.mdimension.com/jadclipse/3.6,\
http://webobjects.mdimension.com/jprofiler6,\
http://www.zeroturnaround.com/update-site,\
http://m2eclipse.sonatype.org/sites/m2e,\
http://webobjects.mdimension.com/hudson/job/WOLips36Current/lastSuccessfulBuild/artifact/site,\
http://workspacemechanic.eclipselabs.org.codespot.com/hg.update/mechanic,\
http://www.bastian-bergerhoff.com/eclipse/features,\
http://download.macromedia.com/pub/labs/jseclipse/autoinstall/site.xml,\
http://download.eclipse.org/technology/babel/update-site/R0.8.0/helios,\
http://community.polarion.com/projects/subversive/download/eclipse/2.0/update-site\
 \
org.eclipse.team.svn.resource.ignore.rules.jdt.feature.group,\
org.eclipse.buckminster.subversive.feature.feature.group,\
org.eclipse.mylyn_feature.feature.group,\
net.sf.jadclipse.feature.group,\
com.jprofiler.integrations.eclipse.feature.group,\
org.zeroturnaround.eclipse.feature.feature.group,\
org.zeroturnaround.eclipse.debug.feature.feature.group,\
org.maven.ide.eclipse.feature.feature.group,\
org.objectstyle.wolips.feature.feature.group,\
org.objectstyle.wolips.goodies.feature.feature.group,\
org.objectstyle.wolips.jprofiler.feature.feature.group,\
org.objectstyle.wolips.jrebel.feature.feature.group,\
com.google.eclipse.mechanic.feature.group,\
de.babe.eclipse.features.Tools.feature.group,\
de.babe.eclipse.features.MC.feature.group,\
de.babe.eclipse.features.QuickREx.feature.group,\
de.babe.eclipse.features.QuickREx_I18N.feature.group,\
de.babe.eclipse.features.tinyHTML.feature.group,\
de.babe.eclipse.features.XPathDeveloper.feature.group,\
com.interaktonline.jseclipse.feature.group,\
org.eclipse.babel.nls_birt_ja.feature.group,\
org.eclipse.babel.nls_datatools_ja.feature.group,\
org.eclipse.babel.nls_dsdp.mtj_ja.feature.group,\
org.eclipse.babel.nls_dsdp.sequoyah_ja.feature.group,\
org.eclipse.babel.nls_dsdp.tm_ja.feature.group,\
org.eclipse.babel.nls_eclipse_ja.feature.group,\
org.eclipse.babel.nls_modeling.emft.eef_ja.feature.group,\
org.eclipse.babel.nls_modeling.gmp.gmf-notation_ja.feature.group,\
org.eclipse.babel.nls_modeling.gmp.gmf-runtime_ja.feature.group,\
org.eclipse.babel.nls_modeling.gmp.gmf-tooling_ja.feature.group,\
org.eclipse.babel.nls_rt.equinox_ja.feature.group,\
org.eclipse.babel.nls_rt.equinox.p2_ja.feature.group,\
org.eclipse.babel.nls_rt.rap_ja.feature.group,\
org.eclipse.babel.nls_technology.actf_ja.feature.group,\
org.eclipse.babel.nls_technology.egit_ja.feature.group,\
org.eclipse.babel.nls_technology.jgit_ja.feature.group,\
org.eclipse.babel.nls_technology.linux-distros_ja.feature.group,\
org.eclipse.babel.nls_technology.packaging.mpc_ja.feature.group,\
org.eclipse.babel.nls_tools.mat_ja.feature.group,\
org.eclipse.babel.nls_tools.mylyn_ja.feature.group,\
org.eclipse.babel.nls_tools.ptp_ja.feature.group,\
org.eclipse.babel.nls_tools.ptp.photran_ja.feature.group,\
org.eclipse.babel.nls_webtools.common_ja.feature.group,\
org.eclipse.babel.nls_webtools.dali_ja.feature.group,\
org.eclipse.babel.nls_webtools.ejbtools_ja.feature.group,\
org.eclipse.babel.nls_webtools.jeetools_ja.feature.group,\
org.eclipse.babel.nls_webtools.jsdt_ja.feature.group,\
org.eclipse.babel.nls_webtools.jsf_ja.feature.group,\
org.eclipse.babel.nls_webtools.servertools_ja.feature.group,\
org.eclipse.babel.nls_webtools.sourceediting_ja.feature.group,\
org.eclipse.babel.nls_webtools.webservices_ja.feature.group,\
org.polarion.eclipse.team.svn.connector.javahl16.feature.group,\
org.polarion.eclipse.team.svn.connector.svnkit16.feature.group,\
org.polarion.eclipse.team.svn.connector.feature.group

echo "Cleaning up ..."
rm "${P2_PATH}"

if [ -e "${ECLIPSE_ARCHIVE_PATH}" ]; then
        rm "${ECLIPSE_ARCHIVE_PATH}"
fi

echo "You should be good to go. Eclipse is installed in '${ECLIPSE_INSTALL_FOLDER}'."
open "${ECLIPSE_INSTALL_FOLDER}"


