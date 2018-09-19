# Content Structure

admin (code often used for administrative purposes)
      | - bash
	  | - cli
	  
code (SAS or CAS exampel scripts)

core (core content to support underlying scripts)

*README.md

# Need to...
## clean out code directory
## Start looking into some ansible alternatives
8/9/18 - Cleanup directories...

# Process Flow
Looking to build out a process flow to automate the installation process.  We can leverage some of the scripts already utilized in our easy deploy construct.  Some new aspects would be to auto-orchestrate and handling of the pre-work in the playbook prior to deploy.  A nice to have would be adding in post-configuration automation and the ingestion of data.

Current Outline:
 - Clone GIT Repo
 - Integrity Check
 - Validate Pre-requisites
 - Isolate IP/Hostname
 - Configure OpenLDAP
 - Orchestate Playbook
 - Pre-configure Viya
 - Deploy
 - Post-Configure
 - Data Ingestion
