-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION philips_obter_titulo_projeto ( nr_seq_gerencia_p bigint, ds_titulo_p text, ds_titulo_externo_p text, cd_funcao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_titulo_w	varchar(255);


BEGIN
if (nr_seq_gerencia_p = 9) then
	begin
	begin
	select	coalesce(max(ds_traducao), coalesce(ds_titulo_externo_p, ds_titulo_p))
	into STRICT	ds_titulo_w
	from	funcao_idioma
	where	cd_funcao = cd_funcao_p
	and	upper(nm_atributo) = 'DS_FUNCAO';
	exception
	when others then
		if (ds_titulo_externo_p IS NOT NULL AND ds_titulo_externo_p::text <> '') then
			begin
			ds_titulo_w := ds_titulo_externo_p;
			end;
		else
			begin
			ds_titulo_w := ds_titulo_p;
			end;
		end if;
	end;

	if (ds_titulo_w = ' ') then
		begin
		if (ds_titulo_externo_p IS NOT NULL AND ds_titulo_externo_p::text <> '') then
			begin
			ds_titulo_w := ds_titulo_externo_p;
			end;
		else
			begin
			ds_titulo_w := ds_titulo_p;
			end;
		end if;
		end;
	end if;
	end;
else
	begin
	if (ds_titulo_externo_p IS NOT NULL AND ds_titulo_externo_p::text <> '') then
		begin
		ds_titulo_w := ds_titulo_externo_p;
		end;
	else
		begin
		ds_titulo_w := ds_titulo_p;
		end;
	end if;
	end;
end if;
return ds_titulo_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION philips_obter_titulo_projeto ( nr_seq_gerencia_p bigint, ds_titulo_p text, ds_titulo_externo_p text, cd_funcao_p bigint) FROM PUBLIC;

