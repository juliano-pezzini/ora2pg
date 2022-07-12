-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION adep_obter_config_gas ( cd_modalidade_vent_p text, ie_respiracao_p text, ie_modo_adm_p text) RETURNS varchar AS $body$
DECLARE


ds_config_w	varchar(255);
ds_texto_aux_w	varchar(100);


BEGIN

if (cd_modalidade_vent_p IS NOT NULL AND cd_modalidade_vent_p::text <> '') then
	begin
	ds_texto_aux_w	:= wheb_mensagem_pck.get_texto(300593);

	select	ds_texto_aux_w || ds_modalidade
	into STRICT	ds_config_w
	from	modalidade_ventilatoria
	where	cd_modalidade = cd_modalidade_vent_p;
	end;
elsif (ie_respiracao_p IS NOT NULL AND ie_respiracao_p::text <> '') then
	begin
	ds_texto_aux_w	:= wheb_mensagem_pck.get_texto(300595);

	ds_config_w	:= substr(ds_texto_aux_w || obter_valor_dominio(1299,ie_respiracao_p),1,255);
	end;
elsif (ie_modo_adm_p IS NOT NULL AND ie_modo_adm_p::text <> '') then
	begin
	ds_texto_aux_w	:= wheb_mensagem_pck.get_texto(300597);

	ds_config_w	:= substr(ds_texto_aux_w || obter_valor_dominio(1568,ie_modo_adm_p),1,255);
	end;
end if;
return ds_config_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_obter_config_gas ( cd_modalidade_vent_p text, ie_respiracao_p text, ie_modo_adm_p text) FROM PUBLIC;

