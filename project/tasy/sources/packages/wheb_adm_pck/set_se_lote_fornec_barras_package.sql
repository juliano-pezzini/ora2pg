-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_adm_pck.set_se_lote_fornec_barras (cd_estabelecimento_p bigint) AS $body$
BEGIN
	select	coalesce(max(ie_barras_lote_fornec),'N')
	into STRICT	current_setting('wheb_adm_pck.ie_barras_lote_fornec_w')::varchar(15)
	from	parametro_estoque
	where	cd_estabelecimento	= cd_estabelecimento_p;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wheb_adm_pck.set_se_lote_fornec_barras (cd_estabelecimento_p bigint) FROM PUBLIC;
