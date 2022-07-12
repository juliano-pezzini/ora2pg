-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_inf_ultima_prescr ( nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/* 
ie_opcao_p 
		P = nr prescricao 
		M = nome médico 
		S = setor da prescricao 
*/
 
 
nr_prescricao_w bigint;
nm_medico_w  varchar(254);
ds_setor_w  varchar(254);
retorno_w  varchar(254) := '';


BEGIN 
 
select	max(nr_prescricao) 
into STRICT 	nr_prescricao_w 
from 	prescr_medica 
where 	nr_atendimento = nr_atendimento_p;
 
if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') then 
		select 	substr(obter_nome_pessoa_fisica(cd_medico, null),1,255), 
				substr(obter_nome_setor(cd_setor_atendimento),1,255) 
		into STRICT 	nm_medico_w, 
				ds_setor_w 
		from 	prescr_medica 
		where 	nr_prescricao = nr_prescricao_w;
else 
		ds_setor_w := substr(obter_nome_setor(obter_setor_atendimento(nr_atendimento_p)),1,255);
end if;
 
if (ie_opcao_p = 'P') then 
	retorno_w := nr_prescricao_w;
elsif (ie_opcao_p = 'M') then 
	retorno_w := nm_medico_w;
elsif (ie_opcao_p = 'S') then 
	retorno_w := ds_setor_w;
end if;
 
return retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_inf_ultima_prescr ( nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;

