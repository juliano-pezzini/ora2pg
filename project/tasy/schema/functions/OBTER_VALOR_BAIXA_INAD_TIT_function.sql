-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_baixa_inad_tit (nr_titulo_p bigint) RETURNS bigint AS $body$
DECLARE

					 
vl_retorno_w	double precision	:= 0;


BEGIN 
 
if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then 
	select	coalesce(sum(a.vl_recebido),0) 
	into STRICT	vl_retorno_w 
	from	tipo_recebimento b, 
		titulo_receber_liq a 
	where	a.nr_titulo	= nr_titulo_p 
	and	a.cd_tipo_recebimento	= b.cd_tipo_recebimento 
	and	coalesce(a.ie_lib_caixa,'S')	= 'S' 
	and	b.ie_tipo_consistencia = '15';
end if;
 
return	vl_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_baixa_inad_tit (nr_titulo_p bigint) FROM PUBLIC;

