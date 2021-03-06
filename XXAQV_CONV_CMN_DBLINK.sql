--/*------------------------------------------------- Arqiva -----------------------------------------------------*
-- ****************************************************************************************************************
-- * Type               : DB Links                                                                                *
-- * Script Name        : XXAQV_CONV_CMN_DBLINK.sql                                                               *
-- * Purpose            : This file creates the DB Link for conversion components.                                *
-- * Company            : Cognizant Technology Solutions.                                                         *
-- *                                                                                                              *
-- * Change History                                                                                               *
-- * Version     Created By        Creation Date    Comments                                                      *
-- *--------------------------------------------------------------------------------------------------------------*
-- * 0.1         CTS               21/11/2019       Initial Version                                               *
-- ****************************************************************************************************************/

CREATE PUBLIC DATABASE LINK XXAQV_CONV_CMN_DBLINK
CONNECT TO apps IDENTIFIED BY r12prj05
USING '(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp) (HOST=uMhtVOraPj501.arqiva.local)(PORT=1521)) (CONNECT_DATA=(SID=PRJEBS05)) )';
/