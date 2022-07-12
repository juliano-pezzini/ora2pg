-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_descricao_agenda ( cd_agenda_p bigint, cd_tipo_agenda_p bigint, ie_opcao_combo_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_agenda_w		varchar(50);
ds_nome_medico_w	varchar(240);
ds_retorno_w		varchar(255);


BEGIN 
 
if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') and (cd_tipo_agenda_p IS NOT NULL AND cd_tipo_agenda_p::text <> '') then 
	 
	select	coalesce(ds_curta,ds_agenda), 
		substr(obter_nome_medico_combo_agcons(coalesce(cd_estabelecimento_p,cd_estabelecimento), cd_agenda, cd_tipo_agenda, coalesce(ie_opcao_combo_p,coalesce(ie_ordenacao,'N'))),1,240) 
	into STRICT	ds_agenda_w, 
		ds_nome_medico_w 
	from	agenda 
	where	ie_situacao = 'A' 
	and	cd_agenda = cd_agenda_p 
	and	cd_tipo_agenda = cd_tipo_agenda_p;
	 
	if (cd_tipo_agenda_p in (1,2,5)) then 
		ds_retorno_w	:= ds_agenda_w;
	elsif (cd_tipo_agenda_p in (3,4)) then 
		ds_retorno_w	:= ds_nome_medico_w;
	end if;
	 
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_descricao_agenda ( cd_agenda_p bigint, cd_tipo_agenda_p bigint, ie_opcao_combo_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

