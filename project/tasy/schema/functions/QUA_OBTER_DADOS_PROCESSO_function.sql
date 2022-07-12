-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_dados_processo ( nr_seq_processo_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
D - Descrição processo
*/
ds_retorno_w		varchar(255);
ds_processo_w		varchar(255);


BEGIN

select	SUBSTR(obter_desc_expressao(CD_EXP_PROCESSO,DS_PROCESSO),1,80) ds_processo
into STRICT	ds_processo_w
from	qua_processo
where	nr_sequencia	=	nr_seq_processo_p;

if (ie_opcao_p	= 'D') then
	ds_retorno_w	:= ds_processo_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_dados_processo ( nr_seq_processo_p bigint, ie_opcao_p text) FROM PUBLIC;
