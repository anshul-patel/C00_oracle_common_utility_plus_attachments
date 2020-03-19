--/*------------------------------------------------- Arqiva -----------------------------------------------------*
-- ****************************************************************************************************************
-- * Type               : Table                                                                                   *
-- * Application Module : APPS                                                                                    *
-- * Table Name         : XXAQV_CONV_CMN_UTILITY_STG                                                              *
-- * Script Name        : XXAQV_CONV_CMN_UTILITY_STG.sql                                                          *
-- * Purpose            : This table stores error logs for the Uitility Conversion Package                        *
-- * Company            : Cognizant Technology Solutions.                                                         *
-- *                                                                                                              *
-- * Change History                                                                                               *
-- * Version     Created By        Creation Date    Comments                                                      *
-- *--------------------------------------------------------------------------------------------------------------*
-- * 0.1         CTS               28/10/2019     Initial Version                                                 *
-- ****************************************************************************************************************/

CREATE TABLE xxaqv.xxaqv_conv_cmn_utility_stg( record_id           NUMBER 
                                             , module_name         VARCHAR2(500)
                                             , staging_table       VARCHAR2(500)
                                             , batch_run           NUMBER
											 , legacy_identifier   VARCHAR2(1000)
                                             , error_column        VARCHAR2(3000)
                                             , error_message       VARCHAR2(4000)
                                             --, process_flag        VARCHAR2(50) 
                                             , process_stage       VARCHAR2(75) 
                                             , creation_date       DATE
                                             , last_update_date    DATE
                                             , last_update_login   NUMBER
                                             , last_updated_by     NUMBER
                                             , created_by          NUMBER );
-- Creates Synonym in APPS schema too.
EXEC ad_zd_table.upgrade('XXAQV','XXAQV_CONV_CMN_UTILITY_STG');
/
