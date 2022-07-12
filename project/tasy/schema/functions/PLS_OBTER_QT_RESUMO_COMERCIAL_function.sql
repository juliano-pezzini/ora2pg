-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qt_resumo_comercial ( ie_dimensao_p text, dt_mes_referencia_p timestamp, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


qt_retorno_w		bigint;


BEGIN

if (ie_opcao_p = 'D') then
	select	qt_registros
	into STRICT	qt_retorno_w
	from	w_pls_resumo_comercial
	where	dt_referencia	= dt_mes_referencia_p
	and	ie_dimensao	= ie_dimensao_p;
elsif (ie_opcao_p = 'T') then
	select	sum(qt_registros)
	into STRICT	qt_retorno_w
	from	w_pls_resumo_comercial
	where	dt_referencia	= dt_mes_referencia_p;
end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qt_resumo_comercial ( ie_dimensao_p text, dt_mes_referencia_p timestamp, ie_opcao_p text) FROM PUBLIC;

