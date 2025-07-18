# GPO - Prevent Interactive logon for service accounts

## Overview

Deny logon locally is a Group Policy Object (GPO) setting that should be used for all service accounts because it shuts down one avenue of exploitation—an interactive logon (e.g., a logon using Ctrl+Alt+Del) to a system with that account.

## Create Policy

1. Create a group that holds users that are going to be denied from local login. (eg, d-logonlocally-deny)
2. In the GPO Snapin create new policy
3. Navigate Path: Computer > Policies > Windows Settings > Security Settings > Local Policy > User Rights Assignment
4. Add the group to the settings : Deny Log on Locally and Deny Log on through RDS

![GPO Menu Path](/.images/GPO_interactivelogin.png)

## Testing Procedure

On the server test by logging in as a service account.

![Test Plan](/.images/GPO_InteractiveLoginTest.png)