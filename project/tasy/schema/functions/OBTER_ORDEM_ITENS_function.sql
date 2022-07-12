-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ordem_itens (ie_origem_inf_p bigint, ie_valor_p text ) RETURNS bigint AS $body$
DECLARE


/* É passado como segundo parametro o valor do parâmetro 503 da prescrição para que os itens da prescricao apareçam conforme a ordenação das pastas*/

ie_retorno_w bigint;


BEGIN
if (ie_origem_inf_p	< 60) or (coalesce(ie_valor_p, 'N')	<> 'S') then
	ie_retorno_w	:= ie_origem_inf_p;
elsif (ie_origem_inf_p	= 120) and (coalesce(ie_valor_p, 'N')	= 'S') then
	ie_retorno_w	:= 60;
elsif (ie_origem_inf_p	>= 60) and (coalesce(ie_valor_p, 'N')	= 'S') then
	ie_retorno_w	:= ie_origem_inf_p + 10;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ordem_itens (ie_origem_inf_p bigint, ie_valor_p text ) FROM PUBLIC;

