--/*------------------------------------------------- Arqiva -----------------------------------------------------*
-- ****************************************************************************************************************
-- * Type               : Index                                                                                   *
-- * Application Module : APPS                                                                                    *
-- * Packagage Name     : XXAQV_CONV_CMN_UTILITY_STG_N1                                                           *
-- * Script Name        : XXAQV_CONV_CMN_UTILITY_STG_N1.sql                                                       *
-- * Purpose            : Script for Index creation on XXAQV_CONV_CMN_UTILITY_STG table                           *
-- * Company            : Cognizant Technology Solutions.                                                         *
-- *                                                                                                              *
-- * Change History                                                                                               *
-- * Version     Created By        Creation Date    Comments                                                      *
-- *--------------------------------------------------------------------------------------------------------------*
-- * 0.1         CTS               21/11/2019     Initial Version                                                 *
-- ****************************************************************************************************************

CREATE INDEX XXAQV_CONV_CMN_UTILITY_STG_N1
          ON XXAQV.XXAQV_CONV_CMN_UTILITY_STG (MODULE_NAME, BATCH_RUN, PROCESS_STAGE, STAGING_TABLE);
/