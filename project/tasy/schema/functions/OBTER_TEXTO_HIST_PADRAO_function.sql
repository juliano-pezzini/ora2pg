-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_texto_hist_padrao (nm_usuario_p text) RETURNS varchar AS $body$
DECLARE

ds_hist_padrao_w	varchar(4000);
ds_texto_rtf_w	varchar(4000) := '';

BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	select 	ds_hist_padrao
	into STRICT	ds_hist_padrao_w
	from 	usuario
	where 	nm_usuario = nm_usuario_p;
	if (ds_hist_padrao_w <> '')	then
		ds_texto_rtf_w := wheb_rtf_pck.get_texto_rtf(ds_hist_padrao_w);
	end if;
end if;
return	ds_texto_rtf_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_texto_hist_padrao (nm_usuario_p text) FROM PUBLIC;
