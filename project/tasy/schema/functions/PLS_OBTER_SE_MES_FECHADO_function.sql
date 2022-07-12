-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_mes_fechado ( dt_mes_ref_p timestamp, ie_opcao_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


/* IE_OPCAO_P
	M = Mes competencia
	C = Contabilidade
	T = Todos
*/
ds_retorno_w			varchar(2);
dt_fechamento_w			timestamp;
ie_mes_fechado_w		varchar(1);
ie_contab_fechado_w		varchar(1);


BEGIN

if (ie_opcao_p in ('M','T')) then
	begin
	select	'S'
	into STRICT	ie_mes_fechado_w
	from	pls_competencia
	where	ESTABLISHMENT_TIMEZONE_UTILS.startOfmonth(dt_mes_competencia) = ESTABLISHMENT_TIMEZONE_UTILS.startOfmonth(dt_mes_ref_p)
	and	(dt_fechamento IS NOT NULL AND dt_fechamento::text <> '')
	and	cd_estabelecimento	= cd_estabelecimento_p;
	exception
		when no_data_found then
		ie_mes_fechado_w := 'N';
	end;

	ds_retorno_w := ie_mes_fechado_w;
end if;

if (ie_opcao_p in ('C','T')) then
	begin
	select	'S'
	into STRICT	ie_contab_fechado_w
	from	ctb_mes_ref a,
		estabelecimento b
	where	a.cd_empresa	= b.cd_empresa
	and	ESTABLISHMENT_TIMEZONE_UTILS.startOfmonth(a.dt_referencia) = ESTABLISHMENT_TIMEZONE_UTILS.startOfmonth(dt_mes_ref_p)
	and	(a.dt_fechamento IS NOT NULL AND a.dt_fechamento::text <> '')
	and	b.cd_estabelecimento = cd_estabelecimento_p;
	exception
		when no_data_found then
		ie_contab_fechado_w := 'N';
	end;

	ds_retorno_w := ie_contab_fechado_w;
end if;

if (ie_opcao_p = 'T') then
	if (ie_contab_fechado_w = 'S') or (ie_mes_fechado_w = 'S') then
		ds_retorno_w	:= 'S';
	else
		ds_retorno_w	:= 'N';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_mes_fechado ( dt_mes_ref_p timestamp, ie_opcao_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

