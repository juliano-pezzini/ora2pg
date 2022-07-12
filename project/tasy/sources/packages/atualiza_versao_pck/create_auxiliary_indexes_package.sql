-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE atualiza_versao_pck.create_auxiliary_indexes () AS $body$
DECLARE

    v_col_list_a varchar(32000);
    v_col_list_b varchar(32000);
    v_col_pk     varchar(32000);
    v_cmd        varchar(32000);

  tep RECORD;
  tep_cols RECORD;

BEGIN
    for tep in (SELECT /*+ NO_PARALLEL */                 table_name
                  from all_tables
                 where owner = 'TASY_VERSAO'
                 order by table_name) loop
      v_col_pk := null;

      for tep_cols in (SELECT /*+ NO_PARALLEL */                        column_name
                         from all_tab_cols
                        where owner = 'TASY_VERSAO'
                          and table_name = tep.table_name
                          and data_type not in ('LONG', 'LONG RAW')
                        order by column_id) loop
        if atualiza_versao_pck.is_pk_column(tep.table_name, tep_cols.column_name) then
          v_col_pk := v_col_pk || tep_cols.column_name || ',';
        end if;
      end loop;

      v_col_pk := trim(both ',' from v_col_pk);
      if (v_col_pk IS NOT NULL AND v_col_pk::text <> '') then
        v_cmd := 'create index ix1$' || tep.table_name ||
                 ' on tasy_versao.' || tep.table_name || '(' || v_col_pk || ')';

        begin
          EXECUTE v_cmd;
        exception
          when others then
            null;
        end;

        v_cmd := 'create index ix2$' || tep.table_name ||
                 ' on tasy_versao.' || tep.table_name || '(' || v_col_pk ||
                 ',dt_atualizacao)';
        begin
          EXECUTE v_cmd;
        exception
          when others then
            null;
        end;

        v_cmd := 'create index ix3$' || tep.table_name ||
                 ' on tasy_versao.' || tep.table_name || '(dt_atualizacao,' ||
                 v_col_pk || ')';
        begin
          EXECUTE v_cmd;
        exception
          when others then
            null;
        end;

        v_cmd := 'create index ix4$' || tep.table_name ||
                 ' on tasy_versao.' || tep.table_name || '(dt_atualizacao)';
        begin
          EXECUTE v_cmd;
        exception
          when others then
            null;
        end;
      end if;
    end loop;
  end;

  --------------------------------------------------------------------------------------
  --                                                                                 
  -- Popula a tabela objeto_sistema_dtr, convertendo o campos DS_SCRIPT_CRIACAO
  -- para CLOB. A conversão é necessária por causa de restrições com o tipo LONG.
  --                                                                                 
  --------------------------------------------------------------------------------------
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_versao_pck.create_auxiliary_indexes () FROM PUBLIC;