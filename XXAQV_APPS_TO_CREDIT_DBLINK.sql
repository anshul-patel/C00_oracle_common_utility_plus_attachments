--/*------------------------------------------------- Arqiva -----------------------------------------------------*
-- ****************************************************************************************************************
-- * Type               : DB Links                                                                                *
-- * Script Name        : APPS_TO_CREDIT_DBLINK.sql                                                               *
-- * Purpose            : This file creates the DB Link for conversion components.                                *
-- * Company            : Cognizant Technology Solutions.                                                         *
-- *                                                                                                              *
-- * Change History                                                                                               *
-- * Version     Created By        Creation Date    Comments                                                      *
-- *--------------------------------------------------------------------------------------------------------------*
-- * 0.1         CTS               21/11/2019       Initial Version                                               *
-- ****************************************************************************************************************/

CREATE PUBLIC DATABASE LINK APPS_TO_CREDIT
CONNECT TO CREDIT
IDENTIFIED BY credit21032018
USING 
'(DESCRIPTION =
  (ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = tstcrplora001.arqiva.local)(PORT = 1521)))
  (CONNECT_DATA =(SERVICE_NAME = tstcre01.arqiva.local)(SERVER = DEDICATED)))';
/