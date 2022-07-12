-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_descricao_principal_ptu (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);
ie_principal_w	smallint;


BEGIN
select 	max(ie_principal)
into STRICT	ie_principal_w
from 	ptu_pacote_servico
where 	nr_sequencia	= nr_sequencia_p;
if (ie_principal_w = 1) 	then
	ds_retorno_w := obter_desc_expressao(305803);
end if;

if (ie_principal_w = 2) 	then
	ds_retorno_w	:= obter_desc_expressao(314452);
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_descricao_principal_ptu (nr_sequencia_p bigint) FROM PUBLIC;

