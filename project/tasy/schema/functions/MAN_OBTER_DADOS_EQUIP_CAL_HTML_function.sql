-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_dados_equip_cal_html ( nr_seq_equip_calib_p bigint, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE


ds_retorno_w		timestamp;
dt_primeira_calib_w		timestamp;
dt_ultima_calib_w		timestamp;
ie_frequencia_w		varchar(15);
qt_dias_freq_w		integer;

/*
1 - Primeira calibração
2 - Ultima calibração
3 - Próxima calibração
*/
BEGIN

select	min(a.dt_calibracao),
	max(a.dt_calibracao),
	max(b.ie_frequencia),
	coalesce(max(c.qt_dia),0)
into STRICT	dt_primeira_calib_w,
	dt_ultima_calib_w,
	ie_frequencia_w,
	qt_dias_freq_w
from	man_freq_calib c,
	man_equip_calibracao b,
	man_calibracao a
where	a.nr_seq_equip_calib 	= b.nr_sequencia
and	c.nr_sequencia 		= b.nr_seq_frequencia
and	b.nr_sequencia		= nr_seq_equip_calib_p;

if (ie_opcao_p = '1') then
	ds_retorno_w		:= dt_primeira_calib_w;
elsif (ie_opcao_p = '2') then
	ds_retorno_w		:= dt_ultima_calib_w;
elsif (ie_opcao_p = '3') then
	ds_retorno_w		:= dt_ultima_calib_w + qt_dias_freq_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_dados_equip_cal_html ( nr_seq_equip_calib_p bigint, ie_opcao_p text) FROM PUBLIC;
