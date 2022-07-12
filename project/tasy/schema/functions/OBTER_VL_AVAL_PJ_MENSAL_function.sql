-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_aval_pj_mensal (cd_cgc_p text, dt_avaliacao_p timestamp, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


vl_retorno_w		double precision;
qt_aval_mes_w		double precision;
vl_total_aval_mes_w	double precision;
vl_media_aval_w		double precision;


BEGIN

select	count(*) qt_aval_mes,
	sum(vl_media) vl_total_aval_mes,
	(sum(vl_media)/count(*)) vl_media_aval
into STRICT	qt_aval_mes_w,
	vl_total_aval_mes_w,
	vl_media_aval_w
from	avf_resultado a
where	to_char(dt_avaliacao,'mm/yyyy') = to_char(dt_avaliacao_p,'mm/yyyy')
and	((a.cd_cnpj = cd_cgc_p) or (cd_cgc_p = '0'))
and	(a.cd_cnpj IS NOT NULL AND a.cd_cnpj::text <> '')
and	(a.vl_media IS NOT NULL AND a.vl_media::text <> '');

if (ie_opcao_p = 'C') then
	vl_retorno_w := qt_aval_mes_w;
end if;
if (ie_opcao_p = 'V') then
	vl_retorno_w := vl_total_aval_mes_w;
end if;
if (ie_opcao_p = 'M') then
	vl_retorno_w := vl_media_aval_w;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_aval_pj_mensal (cd_cgc_p text, dt_avaliacao_p timestamp, ie_opcao_p text) FROM PUBLIC;

