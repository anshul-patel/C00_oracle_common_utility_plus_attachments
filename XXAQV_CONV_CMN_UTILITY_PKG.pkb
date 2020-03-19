CREATE OR REPLACE PACKAGE BODY xxaqv_conv_cmn_utility_pkg 
--/*------------------------------------------------- Arqiva -----------------------------------------------------*
-- ****************************************************************************************************************
-- * Type               : Package Body                                                                            *
-- * Application Module : APPS                                                                                    *
-- * Packagage Name     : XXAQV_CONV_CMN_UTILITY_PKG                                                              *
-- * Script Name        : XXAQV_CONV_CMN_UTILITY_PKG.pkb                                                          *
-- * Purpose            : This package is to store all the common validation and utility prcedues and             *
-- *                      function for Conversion in R12.2.9                                                      *
-- * Company            : Cognizant Technology Solutions.                                                         *
-- *                                                                                                              *
-- * Change History                                                                                               *
-- * Version     Created By        Creation Date    Comments                                                      *
-- *--------------------------------------------------------------------------------------------------------------*
-- * 0.1         CTS               28/10/2019     Initial Version                                                 *
-- ****************************************************************************************************************
 IS
--
   gv_debug_flag   VARCHAR2(10);
   gn_request_id   NUMBER := fnd_global.conc_request_id;
   gn_user_id      NUMBER := fnd_global.user_id;
   gn_login_id     NUMBER := fnd_global.login_id;

--/****************************************************************************************************************
-- * Procedure : print_logs                                                                                        *
-- * Purpose   : This procedure will print log messages in the FND LOG and DBMS LOG.                              *
-- ****************************************************************************************************************/

   PROCEDURE print_logs (
      p_message       IN   VARCHAR2
      ,p_destination   IN   VARCHAR2 DEFAULT 'L'
   ) IS
   BEGIN
      IF p_destination = 'L' THEN
         IF nvl(
            gn_request_id
            ,-1
         ) < 1 THEN
            dbms_output.put_line(p_message);
         ELSE
            fnd_file.put_line(
               fnd_file.log
               ,to_char(
                  sysdate
                  ,'DD-MON-RRRR HH24:MI:SS'
               ) || ' - ' || p_message
            );
         END IF;

      ELSIF p_destination = 'O' THEN
         IF nvl(
            gn_request_id
            ,-1
         ) < 1 THEN
            dbms_output.put_line(p_message);
         ELSE
            fnd_file.put_line(
               fnd_file.output
               ,p_message
            );
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         fnd_file.put_line(
            fnd_file.log
            ,'Exception in package XXAQV_CONV_CMN_UTILITY_PKG.PRINT_LOGS' || to_char(sqlcode) || '-' || sqlerrm
         );
   END print_logs;

--/****************************************************************************************************************
-- * Procedure : PRINT_OUTPUT                                                                                     *
-- * Purpose   : This procedure will print output messages in the FND OUTPUT.                                     *
-- ****************************************************************************************************************/

   PROCEDURE print_output (
      p_module_name     IN   VARCHAR2
      ,p_batch_run       IN   NUMBER
      ,p_stage           IN   VARCHAR2
      ,p_staging_table   IN   VARCHAR2 DEFAULT NULL
   ) IS

      ln_error_count     NUMBER := 0;
      ln_total_count     NUMBER := 0;
      ln_success_count   NUMBER := 0;
      --
      CURSOR cur_errors IS
      SELECT DISTINCT xccus.*
        FROM xxaqv_conv_cmn_utility_stg xccus
       WHERE 1 = 1
         AND xccus.module_name        = p_module_name
         AND xccus.staging_table      = nvl(
         p_staging_table
         ,xccus.staging_table
      )
          --AND xccus.process_flag              = 'ERROR'
         AND xccus.process_stage      = p_stage
         AND nvl(
         xccus.batch_run
         ,- 1
      ) = nvl(
         p_batch_run
         ,nvl(
            xccus.batch_run
            ,- 1
         )
      );

   BEGIN
        /*SELECT COUNT(1) INTO ln_error_count
          FROM xxaqv_conv_cmn_utility_stg      xccus
         WHERE 1 = 1 AND xccus.module_name               = p_module_name
           AND xccus.staging_table             = NVL(p_staging_table, xccus.staging_table)
           AND xccus.process_flag              = 'ERROR' AND xccus.process_stage             = p_stage
           AND xccus.batch_run                 = p_batch_run;*/
      print_logs(
         '****************************** Error Report ******************************'
         ,'O'
      );
      print_logs(
         ''
         ,'O'
      );
      print_logs(
         rpad(
            'Package Name:'
            ,30
         ) || p_module_name
         ,'O'
      );
	  --print_logs(RPAD('Date:', 40) || RPAD(sysdate, 30), 'O');        
      --print_logs(RPAD('Conversion Stage:', 40) || RPAD(p_stage, 30), 'O');         
      --print_logs(RPAD('Batch Total Error Count:', 40) || RPAD(ln_error_count, 30), 'O');
      print_logs(
         ''
         ,'O'
      );
      print_logs(
         '***************************************************************************'
         ,'O'
      );
      print_logs(
         ''
         ,'O'
      );
      print_logs(
         rpad(
            'BATCH ID'
            ,30
         ) || rpad(
            'LEGACY IDENTIFIER'
            ,60
         ) || rpad(
            'COLUMN NAME'
            ,40
         ) || rpad(
            'ERROR MESSAGE'
            ,4000
         )
         ,'O'
      );

      print_logs(
         rpad(
            '-----------'
            ,30
         ) || rpad(
            '-------------------'
            ,60
         ) || rpad(
            '-------------'
            ,40
         ) || rpad(
            '---------------'
            ,4000
         )
         ,'O'
      );

      FOR indx IN cur_errors LOOP print_logs(
         rpad(
            indx.batch_run
            ,30
         ) || rpad(
            NVL(indx.legacy_identifier, ' ')
            ,60
         ) || rpad(
           NVL(indx.error_column, ' ')
            ,40
         ) || indx.error_message
         ,'O'
      );
      END LOOP;

   EXCEPTION
      WHEN OTHERS THEN
         print_logs('Exception in package XXAQV_CONV_CMN_UTILITY_PKG.PRINT_OUTPUT:' || to_char(sqlcode) || '-' || sqlerrm);
   END print_output; 

--/****************************************************************************************************************
-- * Function  : VALIDATE_OPER_UNIT                                                                               *
-- * Purpose   : This function will validate operating unit and return organization id.                           *
-- ****************************************************************************************************************/

   FUNCTION validate_oper_unit (
      p_operating_unit IN VARCHAR2
   ) RETURN NUMBER IS
      ln_org_id NUMBER;
   BEGIN
      SELECT hou.organization_id
        INTO ln_org_id
        FROM hr_operating_units hou
       WHERE 1 = 1
         AND hou.name = p_operating_unit;
          -- AND hou.short_code           = 'AQV';

      RETURN ln_org_id;
   EXCEPTION
      WHEN OTHERS THEN
         print_logs('VALIDATE_OPER_UNIT: Exception validating operating unit:' || to_char(sqlcode) || '-' || sqlerrm);
         ln_org_id := 0;
         RETURN ln_org_id;
   END validate_oper_unit;  
   
--/****************************************************************************************************************
-- * Function  : VALIDATE_HR_ALL_ORG                                                                              *
-- * Purpose   : This function will validate organization value from hr_all_organization_units and return organization_id *
-- ****************************************************************************************************************/

   FUNCTION validate_hr_all_org (
      p_org_name IN VARCHAR2
   ) RETURN NUMBER IS
      ln_org_id NUMBER;
   BEGIN
      SELECT haou.organization_id
        INTO ln_org_id
        FROM hr_all_organization_units haou
       WHERE 1 = 1
         AND haou.name = p_org_name;
          -- AND hou.short_code           = 'AQV';

      RETURN ln_org_id;
   EXCEPTION
      WHEN OTHERS THEN
         print_logs('VALIDATE_HR_ALL_ORG: Exception validating operating unit:' || to_char(sqlcode) || '-' || sqlerrm);
         ln_org_id := 0;
         RETURN ln_org_id;
   END validate_hr_all_org;     

--/****************************************************************************************************************
-- * Procedure : VALIDATE_LEDGER                                                                                  *
-- * Purpose   : This procedure will validate the ledger and return coa_id and ledger_id.                         *
-- ****************************************************************************************************************/

   PROCEDURE validate_ledger (
      p_gl_ledger              IN    VARCHAR2
      ,p_operating_unit         IN    VARCHAR2
      ,x_chart_of_accounts_id   OUT   NUMBER
      ,x_ledger_id              OUT   NUMBER
   ) IS
   BEGIN
      SELECT gl.ledger_id
             ,gl.chart_of_accounts_id
        INTO
         x_ledger_id
      ,x_chart_of_accounts_id
        FROM hr_operating_units   hou
             ,gl_ledgers           gl
       WHERE 1 = 1
         AND hou.set_of_books_id  = gl.ledger_id
         AND hou.name             = p_operating_unit;

   EXCEPTION
      WHEN OTHERS THEN
         print_logs('VALIDATE_LEDGER: Exception validating GL Ledger:' || to_char(sqlcode) || '-' || sqlerrm);
   END validate_ledger;

--/****************************************************************************************************************
-- * Function  : VALIDATE_INV_ORG                                                                                 *
-- * Purpose   : This function will validate item inventory org and return organization id.                       *
-- ****************************************************************************************************************/

   FUNCTION validate_inv_org (
      p_inventory_org IN VARCHAR2
   ) RETURN NUMBER IS
      ln_inv_org_id NUMBER;
   BEGIN
      SELECT ood.organization_id
        INTO ln_inv_org_id
        FROM hr_operating_units             hou
             ,org_organization_definitions   ood
       WHERE 1 = 1
         AND hou.organization_id    = ood.operating_unit
         AND ood.organization_code  = p_inventory_org;

      RETURN ln_inv_org_id;
   EXCEPTION
      WHEN OTHERS THEN
         print_logs('VALIDATE_INV_ORG: Exception validating inventory org:' || to_char(sqlcode) || '-' || sqlerrm);
         ln_inv_org_id := 0;
         RETURN ln_inv_org_id;
   END validate_inv_org;

--/****************************************************************************************************************
-- * Procedure  : VALIDATE_CODE_COMB                                                                               *
-- * Purpose    : This procedure will validate the code combination and return code combination id.                *
-- ****************************************************************************************************************/

   PROCEDURE validate_code_comb (
      p_coa_id                  IN    NUMBER
      ,p_concatenated_segments   IN    VARCHAR2
      ,x_code_combination_id     OUT   NUMBER
   ) IS
   BEGIN
      x_code_combination_id := fnd_flex_ext.get_ccid(
         application_short_name   => 'SQLGL'
         ,key_flex_code            => 'GL#'
         ,structure_number         => p_coa_id
         ,validation_date          => sysdate
         ,concatenated_segments    => p_concatenated_segments
      );
   EXCEPTION
      WHEN OTHERS THEN
         print_logs('VALIDATE_CODE_COMB: Exception validating Code Combinations:' || to_char(sqlcode) || '-' || sqlerrm);
   END validate_code_comb;

--/****************************************************************************************************************
-- * Procedure  : get_code_combination                                                                            *
-- * Purpose    : This procedure will validate the code combination and return code combination id                *    
-- *              as autonomous transaction                                                                       *
-- ****************************************************************************************************************/

   PROCEDURE get_code_combination (
      p_coa_id                  IN    NUMBER
      ,p_concatenated_segments   IN    VARCHAR2
      ,x_code_combination_id     OUT   NUMBER
      ,x_ret_code                OUT   NUMBER
      ,x_ret_msg                 OUT   VARCHAR2
   ) IS
      PRAGMA autonomous_transaction;
   BEGIN
      x_ret_code              := 0;
      x_ret_msg               := NULL;
	  --
      x_code_combination_id   := fnd_flex_ext.get_ccid(
         application_short_name   => 'SQLGL'
         ,key_flex_code            => 'GL#'
         ,structure_number         => p_coa_id
         ,validation_date          => sysdate
         ,concatenated_segments    => p_concatenated_segments
      );

      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK;
         print_logs('GET_CODE_COMBINATION: Unexpected Error:' || to_char(sqlcode) || '-' || sqlerrm);
         x_ret_code   := 1;
         x_ret_msg    := 'GET_CODE_COMBINATION: Unexpected Error: ' || sqlerrm;
   END get_code_combination;

--/****************************************************************************************************************
-- * Function  : VALIDATE_PAY_TERMS                                                                               *
-- * Purpose   : This function will validate payment terms and return term id.                                    *
-- ****************************************************************************************************************/

   FUNCTION validate_pay_terms (
      p_terms_name IN VARCHAR2
   ) RETURN NUMBER IS
      ln_term_id NUMBER;
   BEGIN
      SELECT ate.term_id
        INTO ln_term_id
        FROM ap_terms ate
       WHERE 1 = 1
         AND ate.name = p_terms_name
         AND trunc(sysdate) BETWEEN nvl(
         ate.start_date_active
         ,trunc(sysdate) - 1
      ) AND nvl(
         ate.end_date_active
         ,trunc(sysdate) + 1
      );

      RETURN ln_term_id;
   EXCEPTION
      WHEN OTHERS THEN
         print_logs('VALIDATE_PAY_TERMS: Exception validating payment terms:' || to_char(sqlcode) || '-' || sqlerrm);
         ln_term_id := 0;
         RETURN ln_term_id;
   END validate_pay_terms;

--/****************************************************************************************************************
-- * Function  : VALIDATE_RA_PAY_TERMS                                                                               *
-- * Purpose   : This function will validate AR payment terms and return term id.                                    *
-- ****************************************************************************************************************/

   FUNCTION validate_ra_pay_terms (
      p_ra_terms_name IN VARCHAR2
   ) RETURN NUMBER IS
      ln_ra_term_id NUMBER;
   BEGIN
      SELECT ate.term_id
        INTO ln_ra_term_id
        FROM ra_terms ate
       WHERE 1 = 1
         AND ate.name = p_ra_terms_name
         AND trunc(sysdate) BETWEEN nvl(
         ate.start_date_active
         ,trunc(sysdate) - 1
      ) AND nvl(
         ate.end_date_active
         ,trunc(sysdate) + 1
      );

      RETURN ln_ra_term_id;
   EXCEPTION
      WHEN OTHERS THEN
         print_logs('VALIDATE_RA_PAY_TERMS: Exception validating payment terms:' || to_char(sqlcode) || '-' || sqlerrm);
         ln_ra_term_id := 0;
         RETURN ln_ra_term_id;
   END validate_ra_pay_terms;

--/****************************************************************************************************************
-- * Function  : VALIDATE_EMP_DETAILS                                                                             *
-- * Purpose   : This procedure will validate employee name and return the details.                               *
-- ****************************************************************************************************************/

   PROCEDURE validate_emp_details (
      p_employee_name   IN    VARCHAR2
      ,p_employee_num    IN    VARCHAR2
      ,x_employee_id     OUT   NUMBER
      ,x_full_name       OUT   VARCHAR2
   ) IS
   BEGIN
      SELECT papf.person_id
             ,papf.full_name
        INTO
         x_employee_id
      ,x_full_name
        FROM per_all_people_f papf
       WHERE 1 = 1
         AND trunc(sysdate) BETWEEN trunc(
         nvl(
            papf.effective_start_date
            ,sysdate
         )
      ) AND trunc(
         nvl(
            papf.effective_end_date
            ,sysdate
         )
      )
         AND upper(
         papf.full_name
      )        = nvl(
         upper(p_employee_name)
         ,upper(
            papf.full_name
         )
      )
         AND upper(
         papf.employee_number
      )  = nvl(
         upper(p_employee_num)
         ,upper(
            papf.employee_number
         )
      );

   EXCEPTION
      WHEN OTHERS THEN
         print_logs('VALIDATE_EMP_DETAILS: Exception validating payment terms:' || to_char(sqlcode) || '-' || sqlerrm);
   END validate_emp_details;

--/****************************************************************************************************************
-- * Procedure : CHECK_GL_PERIOD                                                                                  *
-- * Purpose   : This procedure will check if the GL period is open for a particular module.                      *
-- ****************************************************************************************************************/

   PROCEDURE check_gl_period (
      p_period_name       IN    VARCHAR2
      ,p_period_set_name   IN    VARCHAR2
      ,p_application_id    IN    VARCHAR2
      ,p_sob_id            IN    NUMBER
      ,x_gl_date           OUT   DATE
      ,x_period_status     OUT   VARCHAR2
   ) IS
   BEGIN
      SELECT gp.end_date
        INTO x_gl_date
        FROM gl_periods gp
       WHERE 1 = 1
         AND gp.period_set_name  = p_period_set_name
         AND gp.period_name      = to_char(
         to_date(
            p_period_name
            ,'MONTH-YYYY'
         )
         ,'MON-YY'
      );

      SELECT decode(
         gps.closing_status
         ,'O'
         ,'Open'
         ,'C'
         ,'Closed'
         ,'F'
         ,'Future'
         ,'N'
         ,'Never'
         ,gps.closing_status
      ) period_status
        INTO x_period_status
        FROM gl_period_statuses gps
       WHERE 1 = 1
         AND gps.application_id      = p_application_id
         AND upper(
         gps.period_name
      )  = upper(p_period_name)
         AND gps.set_of_books_id     = p_sob_id;

   EXCEPTION
      WHEN OTHERS THEN
         print_logs('CHECK_GL_PERIOD: Exception validating GL Period:' || to_char(sqlcode) || '-' || sqlerrm);
   END check_gl_period;

--/****************************************************************************************************************
-- * Procedure : GET_LOOKUP_VALUE                                                                                 *
-- * Purpose   : This procedure will derive the lookup value for a lookup type.                                   *
-- ****************************************************************************************************************/

   PROCEDURE get_lookup_value (
      p_lookup_type    IN    VARCHAR2
      ,p_lookup_code    IN    VARCHAR2
      ,x_lookup_value   OUT   VARCHAR2
   ) IS
   BEGIN
      SELECT flv.meaning
        INTO x_lookup_value
        FROM fnd_lookup_values flv
       WHERE 1 = 1
         AND flv.lookup_type  = p_lookup_type
         AND flv.lookup_code  = p_lookup_code
         AND trunc(sysdate) BETWEEN nvl(
         trunc(
            flv.start_date_active
         )
         ,trunc(sysdate)
      ) AND nvl(
         trunc(
            flv.end_date_active
         )
         ,trunc(sysdate)
      )
         AND enabled_flag     = 'Y';

   EXCEPTION
      WHEN OTHERS THEN
         print_logs('GET_LOOKUP_VALUE: Exception fetching lookup values:' || to_char(sqlcode) || '-' || sqlerrm);
   END get_lookup_value;

--/****************************************************************************************************************
-- * Function  : GET_FND_MSG                                                                                      *
-- * Purpose   : This function will derive fnd messaged with token substitution and return the message.           *
-- ****************************************************************************************************************/

   FUNCTION get_fnd_msg (
      p_msg_code   IN   VARCHAR2
      ,p_token1     IN   VARCHAR2
      ,p_token2     IN   VARCHAR2
      ,p_token3     IN   VARCHAR2
      ,p_token4     IN   VARCHAR2
      ,p_token5     IN   VARCHAR2
   ) RETURN VARCHAR2 IS
   BEGIN
      fnd_message.clear;
      fnd_message.set_name(
         'XXAQV'
         ,p_msg_code
      );
      fnd_message.set_token(
         'X_TOKEN1'
         ,p_token1
      );
      fnd_message.set_token(
         'X_TOKEN2'
         ,p_token2
      );
      fnd_message.set_token(
         'X_TOKEN3'
         ,p_token3
      );
      fnd_message.set_token(
         'X_TOKEN4'
         ,p_token4
      );
      fnd_message.set_token(
         'X_TOKEN5'
         ,p_token5
      );
      RETURN fnd_message.get;
   EXCEPTION
      WHEN OTHERS THEN
         print_logs('GET_FND_MSG: Exception fetching fnd messages:' || to_char(sqlcode) || '-' || sqlerrm);
         RETURN NULL;
   END get_fnd_msg;

--/****************************************************************************************************************
-- * Procedure : GET_COLUMN_VALUE                                                                                 *
-- * Purpose   : This procedure will extract individual fields from a line of a .csv file.                         *
-- ****************************************************************************************************************/

   FUNCTION get_column_value (
      p_data_row IN VARCHAR2
   ) RETURN gv_type_var IS
      lv_var gv_type_var;
   BEGIN
      SELECT regexp_substr(
         p_data_row
         ,'[^,]+'
         ,1
         ,level
      ) BULK COLLECT
        INTO lv_var
        FROM dual CONNECT BY
         level <= greatest(
            coalesce(
               regexp_count(
                  p_data_row
                  ,','
               ) + 1
               ,0
            )
         );

      RETURN lv_var;
   EXCEPTION
      WHEN OTHERS THEN
         print_logs('Exception in XXAQV_CONV_CMN_UTILITY_PKG.GET_COLUMN_VALUE:' || to_char(sqlcode) || '-' || sqlerrm);
   END get_column_value;

--/****************************************************************************************************************
-- * Procedure : INSERT_ERROR_RECORDS                                                                             *
-- * Purpose   : This procedure will insert error logs into the error logging table.                              *
-- ****************************************************************************************************************/

   PROCEDURE insert_error_records (
      p_conv_cmn_var IN gt_conv_cmn_utility_typ
   ) IS
   BEGIN
      FOR i IN p_conv_cmn_var.first..p_conv_cmn_var.last LOOP INSERT INTO xxaqv.xxaqv_conv_cmn_utility_stg (
         record_id
         ,module_name
         ,staging_table
         ,legacy_identifier
         ,batch_run
         ,error_column
         ,error_message       
           --,process_flag        
         ,process_stage
         ,creation_date
         ,last_update_date
         ,last_update_login
         ,last_updated_by
         ,created_by
      ) VALUES (
         xxaqv_conv_cmn_utility_stg_s.NEXTVAL
         ,p_conv_cmn_var(i).module_name
         ,p_conv_cmn_var(i).staging_table
         ,p_conv_cmn_var(i).legacy_identifier
         ,p_conv_cmn_var(i).batch_run
         ,p_conv_cmn_var(i).error_column
         ,p_conv_cmn_var(i).error_message       
           --,p_conv_cmn_var(i).process_flag        
         ,p_conv_cmn_var(i).process_stage
         ,sysdate
         ,sysdate
         ,gn_login_id
         ,gn_user_id
         ,gn_user_id
      );

      END LOOP;

      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         print_logs('INSERT_ERROR_RECORDS: Exception inserting error records:' || to_char(sqlcode) || '-' || sqlerrm);
   END insert_error_records;

--/****************************************************************************************************************
-- * Procedure : INSERT_ERR_RECS                                                                                  *
-- * Purpose   : This procedure will insert error logs into the error logging table.                              *
-- ****************************************************************************************************************/

   PROCEDURE insert_err_recs (
      p_module_name         IN   VARCHAR2
      ,p_staging_table       IN   VARCHAR2
      ,p_batch_run           IN   NUMBER
      ,p_process_stage       IN   VARCHAR2
      ,p_legacy_identifier   IN   VARCHAR2
      ,p_error_column        IN   VARCHAR2
      ,p_error_message       IN   VARCHAR2
   ) IS
      PRAGMA autonomous_transaction;
   BEGIN
      INSERT INTO xxaqv.xxaqv_conv_cmn_utility_stg (
         record_id
         ,module_name
         ,staging_table
         ,legacy_identifier
         ,batch_run
         ,process_stage
         ,error_column
         ,error_message       
           --,process_flag        
         ,creation_date
         ,last_update_date
         ,last_update_login
         ,last_updated_by
         ,created_by
      ) VALUES (
         xxaqv_conv_cmn_utility_stg_s.NEXTVAL
         ,p_module_name
         ,p_staging_table
         ,p_legacy_identifier
         ,p_batch_run
         ,p_process_stage
         ,p_error_column
         ,p_error_message       
           --,p_conv_cmn_var(i).process_flag        
         ,sysdate
         ,sysdate
         ,gn_login_id
         ,gn_user_id
         ,gn_user_id
      );

      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         print_logs('INSERT_ERR_RECS: Exception inserting error records:' || to_char(sqlcode) || '-' || sqlerrm);
   END insert_err_recs;   

--/****************************************************************************************************************
-- * Procedure : SUBMIT_CONC_PROG                                                                                 *
-- * Purpose   : This procedure will submit concurrent jobs from PLSQL Packages.                                  *
-- ****************************************************************************************************************/

   PROCEDURE submit_conc_prog (
      p_application   IN    VARCHAR2
      ,p_program       IN    VARCHAR2
      ,p_argument1     IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument2     IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument3     IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument4     IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument5     IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument6     IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument7     IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument8     IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument9     IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument10    IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument11    IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument12    IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument13    IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument14    IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument15    IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument16    IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument17    IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument18    IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument19    IN    VARCHAR2 DEFAULT chr(0)
      ,p_argument20    IN    VARCHAR2 DEFAULT chr(0)
      ,x_retcode       OUT   NUMBER
      ,x_err_msg       OUT   VARCHAR2
   ) IS

      ln_request_id           NUMBER;
      lb_child_request_wait   BOOLEAN;
      lv_phase                VARCHAR2(100);
      lv_status               VARCHAR2(30);
      lv_dev_phase            VARCHAR2(100);
      lv_dev_status           VARCHAR2(100);
      lv_message              VARCHAR2(50);
   BEGIN
      ln_request_id := fnd_request.submit_request(
         application   => p_application
         ,program       => p_program
         ,description   => NULL
         ,start_time    => sysdate
         ,sub_request   => false
         ,argument1     => p_argument1
         ,argument2     => p_argument2
         ,argument3     => p_argument3
         ,argument4     => p_argument4
         ,argument5     => p_argument5
         ,argument6     => p_argument6
         ,argument7     => p_argument7
         ,argument8     => p_argument8
         ,argument9     => p_argument9
         ,argument10    => p_argument10
         ,argument11    => p_argument11
         ,argument12    => p_argument12
         ,argument13    => p_argument13
         ,argument14    => p_argument14
         ,argument15    => p_argument15
         ,argument16    => p_argument16
         ,argument17    => p_argument17
         ,argument18    => p_argument18
         ,argument19    => p_argument19
         ,argument20    => p_argument20
      );

      COMMIT;
	  --
      IF ln_request_id > 0 THEN
         print_logs('SUBMIT_CONC_PROG: Successfully Submitted the Concurrent Request: ' || ln_request_id);
         LOOP
            lb_child_request_wait := fnd_concurrent.wait_for_request(
               request_id   => ln_request_id
               ,INTERVAL     => 2
               ,phase        => lv_phase
               ,status       => lv_status
               ,dev_phase    => lv_dev_phase
               ,dev_status   => lv_dev_status
               ,message      => lv_message
            );

            EXIT WHEN upper(lv_phase) = 'COMPLETED' OR upper(lv_status) IN (
               'CANCELLED'
               ,'ERROR'
               ,'TERMINATED'
            );

         END LOOP;

         IF upper(lv_phase) = 'COMPLETED' AND upper(lv_status) = 'ERROR' THEN
            x_retcode   := 1;
            x_err_msg   := 'SUBMIT_CONC_PROG: Concurrent request completed in error. Oracle request id: ' || ln_request_id || ' ' || sqlerrm;
         ELSIF upper(lv_phase) = 'COMPLETED' AND upper(lv_status) = 'NORMAL' THEN
            x_retcode   := 0;
            x_err_msg   := 'SUBMIT_CONC_PROG: Concurrent request completed. Oracle request id: ' || ln_request_id;
         ELSE
            x_retcode   := 1;
            x_err_msg   := 'SUBMIT_CONC_PROG: Concurrent request completed in error. Oracle request id: ' || ln_request_id || ' ' || sqlerrm;
         END IF;

      ELSE
         x_retcode   := 1;
         x_err_msg   := 'Concurrent request failed to submit ' || p_program || ' :' || fnd_message.get;
         print_logs('SUBMIT_CONC_PROG: ' || x_err_msg);
      END IF;

      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         x_retcode   := 1;
         x_err_msg   := 'SUBMIT_CONC_PROG: Exception submitting concurrent request:' || to_char(sqlcode) || '-' || sqlerrm;
   END submit_conc_prog;
   
--/****************************************************************************************************************
-- * Procedure : GET_TARGET_VALUE                                                                                 *
-- * Purpose   : This function will return target account based on source account.                                 *
-- ****************************************************************************************************************/

   FUNCTION get_target_value (
      p_module_name    IN    VARCHAR2
      ,p_field_to_map   IN    VARCHAR2
      ,p_src_value      IN    VARCHAR2
      ,x_error_msg      OUT   VARCHAR2
   ) RETURN VARCHAR2 IS
      lv_trgt_val VARCHAR2(4000) := NULL;
   BEGIN
      --print_logs('Module Name : ' || p_module_name);
      --print_logs('Field To Map: ' || p_field_to_map);
      --print_logs('Source Value: ' || p_src_value);
      --
      SELECT target_value
        INTO lv_trgt_val
        FROM xxaqv_common_mapping_table
       WHERE 1 = 1
         AND enabled_flag         = 'Y'
         AND upper(module_name)   = upper(p_module_name)
         AND upper(field_to_map)  = upper(p_field_to_map)
         AND upper(source_value)  = upper(p_src_value);

      --print_logs('Target Value: ' || lv_trgt_val);

      x_error_msg := NULL;
      RETURN lv_trgt_val;
   EXCEPTION
      WHEN no_data_found THEN
         x_error_msg := p_field_to_map || '-' || p_src_value || ' :Target value is not mapped';
         RETURN NULL;
      WHEN OTHERS THEN
         x_error_msg := 'GET_TARGET_VALUE: Exception getting mapped value: ' || sqlerrm;
         RETURN NULL;
   END get_target_value;   

END xxaqv_conv_cmn_utility_pkg;
/