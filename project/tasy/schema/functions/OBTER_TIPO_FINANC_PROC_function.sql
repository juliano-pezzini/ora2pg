-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_financ_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_p bigint) RETURNS varchar AS $body$
DECLARE


/* ie_tipo_p
	1 - Código
	2 - Descrição
*/
ds_retorno_w		varchar(255);
ie_tipo_financiamento_w	varchar(4);


BEGIN

begin
select	/*+INDEX (SUSPROC_PK)*/	ie_tipo_financiamento
into STRICT	ie_tipo_financiamento_w
from	sus_procedimento
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p
and	(ie_tipo_financiamento IS NOT NULL AND ie_tipo_financiamento::text <> '');
exception
	when others then
	ds_retorno_w	:= '';
end;

if (ie_tipo_p	= 1) then
	ds_retorno_w	:= ie_tipo_financiamento_w;
elsif (ie_tipo_p	= 2) then
	ds_retorno_w	:= obter_valor_dominio(2135, ie_tipo_financiamento_w);
end if;

return	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_financ_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_p bigint) FROM PUBLIC;
