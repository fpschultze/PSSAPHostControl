# PSSAPHostControl

Windows PowerShell Module. Wrapper functions for SAPHostControl SOAP WebMethods.

*Connect-PSSAPHostControl*
Connects to the SAPHostControl web service interface.
Returns a saphostcontrol web service proxy object for the given SAP host.

*Get-PSSAPDatabaseStatus*
Gets the status of the database specified.
The result contains the components of the database and their status.

*Get-PSSAPDatabaseSystemStatus*
Gets the status of the database system specified in parameters.

*Start-PSSAPDatabase*
Starts the database specified in the parameters.

*Stop-PSSAPDatabase*
Stops the database specified in the parameters.
