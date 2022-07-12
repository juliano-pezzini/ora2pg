-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_moeda_nac (cd_estabelecimento_p bigint, vl_origem_p bigint, cd_moeda_origem_p bigint, dt_parametro_p timestamp) RETURNS bigint AS $body$
DECLARE



vl_retorno_w		cotacao_moeda.vl_cotacao%type	:= 0;
vl_cotacao_origem_w	cotacao_moeda.vl_cotacao%type	:= 0;
cd_moeda_padrao_w	integer;
dt_cotacao_w		timestamp;


BEGIN

select	max(dt_cotacao)
into STRICT	dt_cotacao_w
from	cotacao_moeda
where	dt_cotacao	<= dt_parametro_p
and	cd_moeda	= cd_moeda_origem_p;

select	coalesce(max(vl_cotacao),0)
into STRICT	vl_cotacao_origem_w
from	cotacao_moeda
where	cd_moeda	= cd_moeda_origem_p
and	dt_cotacao	= dt_cotacao_w;

select	dividir(vl_origem_p, vl_cotacao_origem_w)
into STRICT	vl_retorno_w
;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_moeda_nac (cd_estabelecimento_p bigint, vl_origem_p bigint, cd_moeda_origem_p bigint, dt_parametro_p timestamp) FROM PUBLIC;

