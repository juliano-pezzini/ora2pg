-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION eis_obter_media_resumo (nr_seq_indicador_p bigint, cd_estabelecimento_p bigint, dt_ano_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_retorno_w	double precision 	:= 0;
qt_meses_w	bigint 	:= 0;


BEGIN

select	count(trunc(dt_referencia,'month'))
into STRICT	qt_meses_w
from	eis_indicador_gestao
where	nr_seq_indicador			= nr_seq_indicador_p
and	cd_estabelecimento			= cd_estabelecimento_p
and	trunc(dt_referencia,'year')		= dt_ano_referencia_p
and	trunc(dt_referencia,'month')	< trunc(clock_timestamp(), 'month')
and	ie_periodo				= 'M';

select	dividir(coalesce(sum(vl_indicador),0), qt_meses_w)
into STRICT	vl_retorno_w
from	eis_indicador_gestao
where	nr_seq_indicador			= nr_seq_indicador_p
and	cd_estabelecimento			= cd_estabelecimento_p
and	trunc(dt_referencia,'year')		= dt_ano_referencia_p
and	trunc(dt_referencia,'month')	< trunc(clock_timestamp(), 'month')
and	ie_periodo				= 'M';

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION eis_obter_media_resumo (nr_seq_indicador_p bigint, cd_estabelecimento_p bigint, dt_ano_referencia_p timestamp) FROM PUBLIC;
