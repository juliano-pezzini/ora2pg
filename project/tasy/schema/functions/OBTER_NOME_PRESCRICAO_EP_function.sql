-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_prescricao_ep ( nr_prescricao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
ie_recem_nato_w		varchar(1);
nm_recem_nato_w		varchar(100);
nm_pessoa_fisica_w	varchar(100);
ds_recem_nato_w		varchar(5);

ds_retorno_w		varchar(255);


BEGIN 
 
select 	max(coalesce(ie_recem_nato,'N')), 
	max(obter_nome_pf(cd_recem_nato)), 
	max(obter_nome_pf(cd_pessoa_fisica)), 
	max(CASE WHEN  substr(converte_numero_romano(nr_recem_nato),1,20) IS NULL THEN null  ELSE (substr(converte_numero_romano(nr_recem_nato),1,20)||' ') END ) 
into STRICT	ie_recem_nato_w, 
	nm_recem_nato_w, 
	nm_pessoa_fisica_w, 
	ds_recem_nato_w 
from	prescr_medica 
where 	nr_prescricao = nr_prescricao_p;
 
 
if (ie_recem_nato_w = 'N') then 
	ds_retorno_w := nm_pessoa_fisica_w;
 
elsif (nm_recem_nato_w IS NOT NULL AND nm_recem_nato_w::text <> '') then 
 
	if (ie_opcao_p = 'PRN') then 
		ds_retorno_w := nm_pessoa_fisica_w || ' - ' || wheb_mensagem_pck.get_texto(309440) ||' ' || ds_recem_nato_w || ': ' || nm_recem_nato_w; -- RN 
	elsif (ie_opcao_p = 'RND') then 
		ds_retorno_w := wheb_mensagem_pck.get_texto(309440) ||' ' || ds_recem_nato_w || wheb_mensagem_pck.get_texto(309447) || ': ' || nm_pessoa_fisica_w; -- RN	-- de 
	else
		ds_retorno_w := wheb_mensagem_pck.get_texto(309440) ||' ' || ds_recem_nato_w || ': ' || nm_recem_nato_w; -- RN 
	end if;
else 
	ds_retorno_w := wheb_mensagem_pck.get_texto(309440) ||' ' || ds_recem_nato_w || wheb_mensagem_pck.get_texto(309447) || ': ' || nm_pessoa_fisica_w; -- RN	-- de 
end if;
 
 
return	ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_prescricao_ep ( nr_prescricao_p bigint, ie_opcao_p text) FROM PUBLIC;
