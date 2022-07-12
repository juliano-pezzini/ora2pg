-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION atualiza_versao_pck.exp_tables_rule_002 (p_table_name text) RETURNS varchar AS $body$
DECLARE

    v_ret varchar(1);

BEGIN
    v_ret := 'S';
    if user = 'CORP' and p_table_name in ('INT_EMPRESA', 'INT_SISTEMA',
        'INT_TIPO', 'INT_INTEGRACAO') then
      v_ret := 'N';
    end if;
    return v_ret;
  end;

  --------------------------------------------------------------------------------------
  --
  --
  --
  --------------------------------------------------------------------------------------
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION atualiza_versao_pck.exp_tables_rule_002 (p_table_name text) FROM PUBLIC;