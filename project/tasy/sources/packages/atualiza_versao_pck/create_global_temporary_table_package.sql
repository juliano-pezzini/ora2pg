-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE atualiza_versao_pck.create_global_temporary_table () AS $body$
DECLARE

    v_cmd             varchar(32000);
    v_tablespace_name varchar(250);

BEGIN
    for t in current_setting('atualiza_versao_pck.c_create_temporary_table_01')::loop CURSOR
      v_cmd := null;
      for c in current_setting('atualiza_versao_pck.c_create_table_02')::CURSOR(p_nm_tabela(t.nm_tabela) loop
        v_cmd := v_cmd || ',' || c.nm_atributo || ' ' ||
                 atualiza_versao_pck.format_data_type(c.ie_tipo_atributo,
                                  c.qt_tamanho,
                                  c.qt_decimais);
      end loop;

      v_cmd := 'create global temporary table ' || t.nm_tabela || ' (' ||
               trim(both ',' from v_cmd) || ') ' || t.ie_temporaria;

      v_tablespace_name := atualiza_versao_pck.get_tabletemp_tablespace(t.nm_tabela); --obter_tablespace_tab_temp(t.nm_tabela);
      CALL atualiza_versao_pck.insert_cmd(p_operacao    => 'CREATE GLOBAL TEMPORARY TABLE',
                 p_cmd         => v_cmd,
                 p_object_name => t.nm_tabela,
                 p_tablespace  => v_tablespace_name);

    end loop;
  end;

  --------------------------------------------------------------------------------------
  --                                                                                 
  -- Cria as instruções CREATE INDEX para a atualização.
  --                                                                                 
  --------------------------------------------------------------------------------------
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_versao_pck.create_global_temporary_table () FROM PUBLIC;
