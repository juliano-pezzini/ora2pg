-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION script_nome_form_tasy ( nm_form_p text, ds_aplicacao_p text) RETURNS varchar AS $body$
DECLARE


nm_form_w	varchar(9);
ds_inicio_w	varchar(3);
ds_meio_w	varchar(3);
ds_fim_w	varchar(3);


BEGIN
if (nm_form_p IS NOT NULL AND nm_form_p::text <> '') then
	begin
	if (coalesce(length(nm_form_p),0) = 9) and (position('_' in nm_form_p) = 7) then
		begin
		ds_inicio_w	:= substr(nm_form_p,1,3);
		ds_meio_w	:= substr(nm_form_p,4,3);
		ds_fim_w	:= substr(nm_form_p,7,3);

		if (ds_aplicacao_p = 'TasyPLS') then
			begin
			ds_meio_w	:= upper(ds_meio_w);
			end;
		else
			begin
			ds_meio_w	:= initcap(ds_meio_w);
			end;
		end if;

		nm_form_w	:= initcap(ds_inicio_w) || ds_meio_w || upper(ds_fim_w);
		end;
	end if;
	end;
end if;
return nm_form_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION script_nome_form_tasy ( nm_form_p text, ds_aplicacao_p text) FROM PUBLIC;

