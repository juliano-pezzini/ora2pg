-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_setor_atend ( nr_seq_setor_atend_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
	IE_OPCAO_P:
	'DS'    =	DESCRICAO DO SETOR

*/
ds_retorno_w		varchar(255)	:= null;
ds_setor_atend_w	varchar(255);


BEGIN
if (coalesce(nr_seq_setor_atend_p,0) > 0) then

	begin
	select 	ds_setor_atendimento
	into STRICT	ds_setor_atend_w
	from 	pls_setor_atendimento
	where 	nr_sequencia = nr_seq_setor_atend_p;
	exception
	when others then
		ds_setor_atend_w	:= null;
	end;

	ds_retorno_w 	:= ds_setor_atend_w;

	if (ie_opcao_p = 'DS') then
		ds_retorno_w 	:= ds_setor_atend_w;
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_setor_atend ( nr_seq_setor_atend_p bigint, ie_opcao_p text) FROM PUBLIC;
