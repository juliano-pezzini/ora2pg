-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_mov_benef_pck.obter_cd_tipo_logradouro_pf ( cd_tipo_logradouro_p sus_tipo_logradouro.cd_tipo_logradouro%type) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(255);
current_setting('pls_mov_benef_pck.c01')::CURSOR CURSOR FOR
	SELECT	cd_intercambio
	from	pls_interc_tipo_logradouro
	where (cd_tipo_logradouro = cd_tipo_logradouro_p or (coalesce(nr_seq_tipo_logradouro::text, '') = '' and coalesce(cd_tipo_logradouro::text, '') = ''))
	order by coalesce(cd_tipo_logradouro,0);
BEGIN
ds_retorno_w	:= null;
for r_c01_w in current_setting('pls_mov_benef_pck.c01')::loop CURSOR
	begin
	ds_retorno_w	:= r_c01_w.cd_intercambio;
	end;
end loop;
return	ds_retorno_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_mov_benef_pck.obter_cd_tipo_logradouro_pf ( cd_tipo_logradouro_p sus_tipo_logradouro.cd_tipo_logradouro%type) FROM PUBLIC;
