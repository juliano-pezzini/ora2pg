-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_baixa_bem (nr_seq_bem_p bigint, dt_referencia_p timestamp, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/* ie_opcao

QTP 	- percentual ultima baixa
VLC 	- valor contabi
DA	- depresciação acumulada
VLR	-valor residual
VLH	-valor historico
VLB	-valor baixa*/
vl_retorno_w 	double precision;
qt_bem_w		smallint;
dt_historico_w		timestamp;
inicio_mes_w		timestamp;
fim_mes_w		timestamp;


BEGIN

select 	count(*)
into STRICT	qt_bem_w
from 	pat_bem
where 	nr_sequencia = nr_seq_bem_p;

if (qt_bem_w <> 0) then

	select 	last_day(coalesce(dt_referencia_p,clock_timestamp()))
	into STRICT	fim_mes_w
	;

	select 	(trunc(fim_mes_w,'month') - (obter_qt_dias_mes(dt_referencia_p) - 1))
	into STRICT	inicio_mes_w
	;

	select 	max(dt_historico)
	into STRICT 	dt_historico_w
	from  	pat_historico_bem
	where	nr_seq_bem = nr_seq_bem_p
	and	dt_historico between  inicio_mes_w and fim_mes_w;

	if (upper(ie_opcao_p) = 'QTP') then
		select 	max(qt_percentual)
		into STRICT	vl_retorno_w
		from	pat_historico_bem
		where	dt_historico = dt_historico_w
		and	nr_seq_bem = nr_seq_bem_p;
	elsif (upper(ie_opcao_p) = 'VLC') then
		select 	max(vl_contabil)
		into STRICT	vl_retorno_w
		from	pat_valor_bem
		where	dt_valor = dt_referencia_p
		and	nr_seq_bem = nr_seq_bem_p;
	elsif (upper(ie_opcao_p) = 'DA') then
		select 	max(vl_deprec_acum)
		into STRICT	vl_retorno_w
		from	pat_valor_bem
		where	dt_valor = dt_referencia_p
		and	nr_seq_bem = nr_seq_bem_p;
	elsif (upper(ie_opcao_p) = 'VLR') then
		select 	max(vl_base_deprec) - max(vl_deprec_acum)
		into STRICT	vl_retorno_w
		from	pat_valor_bem
		where	dt_valor = dt_referencia_p
		and	nr_seq_bem = nr_seq_bem_p;
	elsif (upper(ie_opcao_p) = 'VLH') then
		select 	max(vl_historico)
		into STRICT	vl_retorno_w
		from 	pat_historico_bem
		where	dt_historico = dt_historico_w
		and	nr_seq_bem = nr_seq_bem_p;
	elsif (upper(ie_opcao_p) = 'VLB') then
		select 	max(coalesce(vl_baixa_bem,0))
		into STRICT	vl_retorno_w
		from	pat_valor_bem
		where	dt_valor = dt_referencia_p
		and	nr_seq_bem = nr_seq_bem_p;
	end if;

end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_baixa_bem (nr_seq_bem_p bigint, dt_referencia_p timestamp, ie_opcao_p text) FROM PUBLIC;
