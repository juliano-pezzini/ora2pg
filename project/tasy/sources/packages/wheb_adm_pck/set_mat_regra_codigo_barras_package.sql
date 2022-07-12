-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_adm_pck.set_mat_regra_codigo_barras (cd_estabelecimento_p bigint) AS $body$
BEGIN
	select	coalesce(max(nr_seq_mat_regra_barra),2)
	into STRICT	current_setting('wheb_adm_pck.nr_seq_mat_regra_barra_w')::bigint
	from	parametro_estoque
	where	cd_estabelecimento	= cd_estabelecimento_p;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wheb_adm_pck.set_mat_regra_codigo_barras (cd_estabelecimento_p bigint) FROM PUBLIC;
