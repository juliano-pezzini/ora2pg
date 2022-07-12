-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_macro_prontuario ( nm_macro_p text, cd_funcao_p bigint default 6001) RETURNS varchar AS $body$
DECLARE


nm_atributo_w		varchar(50);
ds_macro_cliente_w		varchar(255);


BEGIN
if (nm_macro_p IS NOT NULL AND nm_macro_p::text <> '') then
	begin	
	select	max(m.nm_macro)
	into STRICT	ds_macro_cliente_w
	from	macro_prontuario m,
		funcao_macro_cliente c,
		funcao_macro f
	where	f.cd_funcao = cd_funcao_p
	and	f.nr_sequencia = c.nr_seq_macro
	and	c.ds_macro = nm_macro_p
	and	m.nm_macro = f.ds_macro;

	select	max(nm_atributo)
	into STRICT	nm_atributo_w
	from	macro_prontuario
	where	upper(nm_macro) = upper(coalesce(ds_macro_cliente_w,nm_macro_p));
	
	end;
end if;
return nm_atributo_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_macro_prontuario ( nm_macro_p text, cd_funcao_p bigint default 6001) FROM PUBLIC;

