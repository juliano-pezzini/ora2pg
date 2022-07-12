-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE atualiza_versao_pck.create_function_based_index () AS $body$
DECLARE

    v_cmd varchar(32000);

BEGIN
    for i in current_setting('atualiza_versao_pck.c_create_func_based_index_01')::loop CURSOR
    
      v_cmd := 'create  index ' || i.nm_indice || ' on ' || i.nm_tabela || '(' ||
               i.ds_indice_function || ') @PARALLEL_DEGREE@ ';

      CALL atualiza_versao_pck.insert_cmd(p_operacao    => 'CREATE FUNCTION BASED INDEX'
,
                 p_cmd         => v_cmd,
                 p_object_name => i.nm_indice);
    end loop;
  end;

  --------------------------------------------------------------------------------------
  --                                                                                 
  -- Cria as instruções CREATE SEQUENCE para a atualização.
  --                                                                                 
  --------------------------------------------------------------------------------------
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_versao_pck.create_function_based_index () FROM PUBLIC;