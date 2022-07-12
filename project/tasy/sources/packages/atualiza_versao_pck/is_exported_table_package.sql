-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION atualiza_versao_pck.is_exported_table (p_table_name text) RETURNS boolean AS $body$
DECLARE

    v_is_exp_table varchar(1);
    v_ret          boolean;

BEGIN
    select CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END 
      into STRICT v_is_exp_table
      from tasy_versao.tasy_exptables t
     where t.table_name = p_table_name;
    if v_is_exp_table = 'S' then
      v_ret := true;
    else
      v_ret := false;
    end if;
    return v_ret;
  end;

  --------------------------------------------------------------------------------------
  --                                                                                 
  -- Retorna se a coluna informada no parametro faz parte de uma chave primária
  -- da tabela.
  --                                                                                 
  --------------------------------------------------------------------------------------
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION atualiza_versao_pck.is_exported_table (p_table_name text) FROM PUBLIC;
