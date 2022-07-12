-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE atualiza_versao_pck.gen_insert_records (p_table_name text, p_ds_campo_copia text, p_reg_count bigint) AS $body$
DECLARE

    v_col_list  varchar(32000);
    v_col_pk    varchar(2000);
    v_col_where varchar(2000);
    v_reg_count bigint;
    v_cmd       text;

  tep_cols RECORD;

BEGIN
    v_reg_count := 0;
    for tep_cols in (SELECT nm_atributo column_name
                       from tasy_versao.tabela_atributo
                      where nm_tabela = p_table_name
                        and ie_tipo_atributo not in ('FUNCTION', 'TIMESTAMP', 'LONG', 'LONG RAW',
                             'VISUAL')) loop
      v_col_list := v_col_list || tep_cols.column_name || ',';
      if atualiza_versao_pck.is_pk_column(p_table_name, tep_cols.column_name) then
        v_col_pk    := v_col_pk || tep_cols.column_name || ',';
        v_col_where := v_col_where || ' and a.' || tep_cols.column_name ||
                       '=b.' || tep_cols.column_name;
      end if;
    end loop;

    v_col_pk   := trim(both ',' from v_col_pk);
    v_col_list := trim(both ',' from v_col_list);
    v_col_list := replace(v_col_list, ',', ',' || chr(10));

    v_cmd := 'insert into ' || p_table_name || '(' || v_col_list || ') ' ||
             chr(10) || ' select ' || v_col_list || ' from tasy_versao.' ||
             p_table_name || ' a ' || chr(10) || p_ds_campo_copia ||
             chr(10) || ' log errors into log_error_exp_tables (''' ||
             upper(p_table_name) || ''') reject limit unlimited';

    CALL atualiza_versao_pck.insert_cmd(p_operacao         => 'INSERT NEW RECORDS ON DICTIONARY TABLES',
               p_cmd              => v_cmd,
               p_object_name      => p_table_name,
               p_qt_reg_exp_table => p_reg_count);

  end;

  --------------------------------------------------------------------------------------
  --                                                                                 
  -- Cria as instruções para DELETE das tabela de dicionário
  --                                                                                 
  --------------------------------------------------------------------------------------
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_versao_pck.gen_insert_records (p_table_name text, p_ds_campo_copia text, p_reg_count bigint) FROM PUBLIC;