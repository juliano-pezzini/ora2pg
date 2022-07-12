-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_dnv_nascimento (nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/* 	DT = Data de Nascimento
	DV  = DNV*/
ds_retorno			varchar(40);
ds_nascimento_w 	varchar(40);
ds_dnv_w				varchar(40);


BEGIN
select	max(to_char(coalesce(dt_nascimento,clock_timestamp()),'dd/mm/yyyy hh:mm:ss')),
	coalesce(max(nr_dnv), Wheb_mensagem_pck.get_texto(799512))
into STRICT	ds_nascimento_w,
	ds_dnv_w
from 	nascimento
where 	nr_atendimento = nr_atendimento_p;

if (ie_opcao_p = 'DT') then
	ds_retorno := ds_nascimento_w;
elsif (ie_opcao_p = 'DV') then
	ds_retorno := ds_dnv_w;
end if;

return ds_retorno;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_dnv_nascimento (nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;

