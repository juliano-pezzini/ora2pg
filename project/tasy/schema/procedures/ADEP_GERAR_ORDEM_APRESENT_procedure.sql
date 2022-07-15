-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adep_gerar_ordem_apresent ( nr_regra_ordem_p bigint) AS $body$
BEGIN
update	w_adep_t
set	nr_seq_apres_grupo = 999,
	nr_seq_apres_inf = 999
where	1 = 1
and	((ie_tipo_item	<> 'E') or (coalesce(nr_seq_apres_inf::text, '') = ''));

CALL adep_gerar_ordem_apres_grupo(nr_regra_ordem_p);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_gerar_ordem_apresent ( nr_regra_ordem_p bigint) FROM PUBLIC;

