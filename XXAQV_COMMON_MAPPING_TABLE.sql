--/*------------------------------------------------- Arqiva -----------------------------------------------------*
-- ****************************************************************************************************************
-- * Type               : Table                                                                                   *
-- * Application Module : APPS                                                                                    *
-- * Table Name         : XXAQV_COMMON_MAPPING_TABLE                                                              *
-- * Script Name        : XXAQV_COMMON_MAPPING_TABLE.sql                                                          *
-- * Purpose            : MAPPING TABLE                                                                           *
-- * Company            : Cognizant Technology Solutions.                                                         *
-- *                                                                                                              *
-- * Change History                                                                                               *
-- * Version     Created By        Creation Date    Comments                                                      *
-- *--------------------------------------------------------------------------------------------------------------*
-- * 0.1         CTS                29/11/2019      Initial Version                                               *
-- ****************************************************************************************************************/

CREATE TABLE xxaqv.xxaqv_common_mapping_table ( 
    module_name         VARCHAR2 (240)
   ,field_to_map        VARCHAR2 (240)
   ,source_value        VARCHAR2 (240)
   ,target_value        VARCHAR2 (240)
   ,enabled_flag        VARCHAR2 (5)
   ,attribute1          VARCHAR2 (240)
   ,attribute2          VARCHAR2 (240)
   ,attribute3          VARCHAR2 (240)
   ,attribute4          VARCHAR2 (240)
   ,attribute5          VARCHAR2 (240)
   ,attribute6          VARCHAR2 (240)
   ,attribute7          VARCHAR2 (240)
   ,attribute8          VARCHAR2 (240)
   ,attribute9          VARCHAR2 (240)
   ,attribute10         VARCHAR2 (240)
   ,last_updated_by     NUMBER
   ,last_update_date    DATE
   ,last_update_login   NUMBER
   ,created_by          NUMBER
   ,creation_date       DATE);
 
EXEC ad_zd_table.upgrade ('XXAQV','XXAQV_COMMON_MAPPING_TABLE');
/
