-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION apap_dinamico_pck.obter_tabela_data (dt_inicio_p timestamp, dt_fim_p timestamp) RETURNS SETOF DATE_TABLE_T AS $body$
DECLARE

  date_table_v_w date_table_t := date_table_t();
  vl_diferenca_w bigint := 0;
BEGIN
  vl_diferenca_w := fim_dia(dt_fim_p) - inicio_dia(dt_inicio_p);
  for i in 1..vl_diferenca_w
  loop
	date_table_v_w.extend();
	date_table_v_w[i].dt_atual := inicio_dia(dt_inicio_p) + i-1;
	RETURN NEXT date_table_v_w(i);
  end loop;
  return;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION apap_dinamico_pck.obter_tabela_data (dt_inicio_p timestamp, dt_fim_p timestamp) FROM PUBLIC;