-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conv_envio ( nm_tabela_p text, nm_atributo_p text, cd_interno_p text, ds_data_type_p text ) RETURNS varchar AS $body$
DECLARE


/* ds_data_type_p
E - cd_externo
S - cd_sistema_codificacao
*/
cd_externo_w				varchar(1000);
cd_sistema_codificacao_w	varchar(1000);

ds_value_w					varchar(4000);
count_w						smallint := 0;


BEGIN

if (ds_data_type_p not in ('E', 'S')) then
	return null;
end if;

select count(1)
into STRICT count_w
from	conversao_meio_externo
where	upper(nm_tabela)	= upper(nm_tabela_p)
and	upper(nm_atributo)	= upper(nm_atributo_p)
and	upper(cd_interno)	= upper(cd_interno_p)
and	coalesce(ie_envio_receb,'A') in ('E','A')  LIMIT 1;

if (count_w > 0) then
	select	cd_externo,
			cd_sistema_codificacao
	into STRICT	cd_externo_w,
			cd_sistema_codificacao_w
	from	conversao_meio_externo
	where	upper(nm_tabela)	= upper(nm_tabela_p)
	and	upper(nm_atributo)	= upper(nm_atributo_p)
	and	upper(cd_interno)	= upper(cd_interno_p)
	and	coalesce(ie_envio_receb,'A') in ('E','A')  LIMIT 1;
else
	begin
	
	select cd_valor_ontologia cd_externo,
			ie_ontologia cd_sistema_codificacao
	into STRICT	cd_externo_w,
			cd_sistema_codificacao_w
	from RES_CADASTRO_ONTOLOGIA_CLI
	where 1=1
	and upper(nm_tabela)	= upper(nm_tabela_p)
	and	upper(nm_atributo)	= upper(nm_atributo_p)
	and	upper(cd_valor_tasy)	= upper(cd_interno_p)  LIMIT 1;
	
	exception
		when no_data_found then
		return null;
	end;
end if;

if (ds_data_type_p = 'E') then
	ds_value_w := substr(cd_externo_w, 1);
elsif (ds_data_type_p = 'S') then
	ds_value_w := substr(cd_sistema_codificacao_w, 1);
end if;

return ds_value_w;

exception
	when others then
		return null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conv_envio ( nm_tabela_p text, nm_atributo_p text, cd_interno_p text, ds_data_type_p text ) FROM PUBLIC;
