-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_nf ( vl_origem_p bigint, ie_acao_p text, ie_entrada_saida_p text, ie_foco_p text) RETURNS bigint AS $body$
DECLARE


/* ie_foco_p serve para dizer se o foco é a entrada ou a saida */

vl_retorno_w	double precision;


BEGIN

if (ie_entrada_saida_p = ie_foco_p) then
	begin
	if (ie_acao_p	= 1) then
		vl_retorno_w	:= vl_origem_p;
	else
		vl_retorno_w	:= vl_origem_p * -1;
	end if;
	end;
else
	begin
	if (ie_acao_p	= 1) then
		vl_retorno_w	:= vl_origem_p * -1;
	else
		vl_retorno_w	:= vl_origem_p;
	end if;
	end;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_nf ( vl_origem_p bigint, ie_acao_p text, ie_entrada_saida_p text, ie_foco_p text) FROM PUBLIC;
