--/*------------------------------------------------- Arqiva -----------------------------------------------------*
-- ****************************************************************************************************************
-- * Type               : Grant                                                                                   *
-- * Application Module : APPS                                                                                    *
-- * Packagage Name     : XXAQV_CONV_CMN_UTILITY_GRANTS                                                           *
-- * Script Name        : XXAQV_CONV_CMN_UTILITY_DB_GRANTS.sql                                                    *
-- * Purpose            : Script for creating sequence synonym                                                    *
-- * Company            : Cognizant Technology Solutions.                                                         *
-- *                                                                                                              *
-- * Change History                                                                                               *
-- * Version     Created By        Creation Date    Comments                                                      *
-- *--------------------------------------------------------------------------------------------------------------*
-- * 0.1         CTS               21/11/2019     Initial Version                                                 *
-- ****************************************************************************************************************

GRANT ALL ON xxaqv.xxaqv_conv_cmn_utility_stg_s TO apps_ro WITH GRANT OPTION;

GRANT SELECT ON xxaqv.xxaqv_common_mapping_table TO apps_ro WITH GRANT OPTION;

GRANT SELECT ON xxaqv.xxaqv_conv_cmn_utility_stg TO apps_ro WITH GRANT OPTION;

GRANT SELECT ON xxaqv.xxaqv_attach_docs_stg TO apps_ro WITH GRANT OPTION;
/