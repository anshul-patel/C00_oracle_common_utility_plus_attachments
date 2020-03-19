--/*------------------------------------------------- Arqiva -----------------------------------------------------*
-- ****************************************************************************************************************
-- * Type               : Sequence                                                                                *
-- * Application Module : Arqiva Custom Application (xxaqv)                                                       *
-- * Script Name        : XXAQV_CONV_CMN_UTILITY_STG_S.sql                                                            *
-- * Purpose            : These sequences are created for common utility component tables.                        *
-- * Company            : Cognizant Technology Solutions.                                                         *
-- *                                                                                                              *
-- * Change History                                                                                               *
-- * Version     Created By        Creation Date    Comments                                                      *
-- *--------------------------------------------------------------------------------------------------------------*
-- * 1.0         CTS               28/10/2019     Initial Version                                                 *
-- ****************************************************************************************************************/

CREATE SEQUENCE xxaqv.xxaqv_conv_cmn_utility_stg_s 
INCREMENT BY 1 
START WITH 1 
NOCYCLE CACHE 20 
NOORDER;

GRANT ALL ON xxaqv.xxaqv_conv_cmn_utility_stg_s TO apps WITH GRANT OPTION;
/
