-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tax_dmed_ir_pck.load_file_header () AS $body$
DECLARE

      file_content tax_dmed_arquivo.ds_arquivo%type := '';

BEGIN
      file_content := file_content || 'Dmed'                                                              || current_setting('tax_dmed_ir_pck.data_separator')::varchar(1);
      file_content := file_content || extract(YEAR from current_setting('tax_dmed_ir_pck.control_table')::generalda_control_type[1].dt_ano_referencia)               || current_setting('tax_dmed_ir_pck.data_separator')::varchar(1);
      file_content := file_content || extract(YEAR from current_setting('tax_dmed_ir_pck.control_table')::generalda_control_type[1].dt_ano_calendario)               || current_setting('tax_dmed_ir_pck.data_separator')::varchar(1);
      file_content := file_content || current_setting('tax_dmed_ir_pck.control_table')::generalda_control_type[1].ie_retificadora                                    || current_setting('tax_dmed_ir_pck.data_separator')::varchar(1);
      file_content := file_content || current_setting('tax_dmed_ir_pck.control_table')::generalda_control_type[1].nr_recibo                                          || current_setting('tax_dmed_ir_pck.data_separator')::varchar(1);
      file_content := file_content || current_setting('tax_dmed_ir_pck.control_table')::generalda_control_type[1].ds_identificador                                   || current_setting('tax_dmed_ir_pck.data_separator')::varchar(1);
      CALL tax_dmed_ir_pck.add_data_file(file_content, 'HEADER');
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tax_dmed_ir_pck.load_file_header () FROM PUBLIC;
