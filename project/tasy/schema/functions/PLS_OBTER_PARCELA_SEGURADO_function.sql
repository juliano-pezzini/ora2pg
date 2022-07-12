-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_parcela_segurado ( nr_seq_segurado_p bigint, dt_mes_mensalidade_p timestamp, dt_mes_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


ds_retorno_w			varchar(255);
dt_limite_movimentacao_w	varchar(5);
dt_inicio_movimentacao_w	timestamp;
dt_fim_movimentacao_w		timestamp;
dt_adesao_w			timestamp;
dt_adesao_mov_w			timestamp;
nr_parcela_w			bigint;
vl_variacao_mes_w		smallint;
qt_meses_w			bigint;
nr_seq_regra_mens_w		bigint;
dt_primeira_mens_w		timestamp;
dt_dia_adesao_w			varchar(2);
nr_seq_contrato_w		bigint;
nr_seq_intercambio_w		bigint;
ie_tipo_data_limite_w		varchar(2);


BEGIN

select	coalesce(dt_contratacao,dt_inclusao_operadora),
	nr_seq_contrato,
	nr_seq_intercambio
into STRICT	dt_adesao_w,
	nr_seq_contrato_w,
	nr_seq_intercambio_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

if (coalesce(nr_seq_contrato_w,0) <> 0) then
	select	max(nr_sequencia)
	into STRICT	nr_seq_regra_mens_w
	from	pls_regra_mens_contrato
	where	nr_seq_contrato	= nr_seq_contrato_w
	and	ie_tipo_regra	= 'L'
	and	(dt_limite_movimentacao IS NOT NULL AND dt_limite_movimentacao::text <> '');
elsif (coalesce(nr_seq_intercambio_w,0) <> 0) then
	select	max(nr_sequencia)
	into STRICT	nr_seq_regra_mens_w
	from	pls_regra_mens_contrato
	where	nr_seq_intercambio	= nr_seq_intercambio_w
	and	ie_tipo_regra	= 'L'
	and	(dt_limite_movimentacao IS NOT NULL AND dt_limite_movimentacao::text <> '');
end if;

if (coalesce(nr_seq_regra_mens_w,0) = 0) then
	select	max(nr_sequencia)
	into STRICT	nr_seq_regra_mens_w
	from	pls_regra_mens_contrato
	where	coalesce(nr_seq_contrato::text, '') = ''
	and	coalesce(nr_seq_intercambio::text, '') = ''
	and	ie_tipo_regra	= 'L'
	and	(dt_limite_movimentacao IS NOT NULL AND dt_limite_movimentacao::text <> '');
end if;

if (coalesce(nr_seq_regra_mens_w,0) <> 0) then
	select	lpad(to_char(coalesce(a.dt_limite_movimentacao,'0')),2,0),
		a.ie_tipo_data_limite /*decode(a.ie_tipo_data_limite,'C',0,'A',-1)*/
	into STRICT	dt_limite_movimentacao_w,
		ie_tipo_data_limite_w
	from	pls_regra_mens_contrato a
	where	a.nr_sequencia	= nr_seq_regra_mens_w;

	if (ie_tipo_data_limite_w = 'C') then
		vl_variacao_mes_w	:= 0;
	elsif (ie_tipo_data_limite_w = 'A') then
		vl_variacao_mes_w	:= -1;
	end if;

	begin
	dt_fim_movimentacao_w		:= add_months(to_date(dt_limite_movimentacao_w || to_char(dt_mes_mensalidade_p,'mm/yyyy')),vl_variacao_mes_w);
	exception
	when others then
		dt_fim_movimentacao_w	:= add_months(last_day(dt_mes_mensalidade_p),vl_variacao_mes_w);
	end;
	dt_inicio_movimentacao_w	:= add_months(dt_fim_movimentacao_w,-1) + 1;

	/* Obter a data da primeira mensalidade do beneficiário */

	dt_dia_adesao_w	:= to_char(dt_adesao_w,'dd');

	if ((dt_dia_adesao_w)::numeric 	> (dt_limite_movimentacao_w)::numeric ) then
		dt_primeira_mens_w	:= trunc(add_months(to_date(dt_limite_movimentacao_w || to_char(dt_adesao_w,'mm/yyyy')),+1),'month');
	else
		dt_primeira_mens_w	:= trunc(dt_adesao_w,'month');
	end if;

	if (dt_limite_movimentacao_w IS NOT NULL AND dt_limite_movimentacao_w::text <> '') then
		if (trunc(dt_adesao_w,'month') < dt_primeira_mens_w) then
			dt_primeira_mens_w	:= trunc(add_months(dt_primeira_mens_w,-1),'month');
		end if;

		if (trunc(dt_mes_referencia_p,'month') = trunc(dt_adesao_w,'month')) then
			nr_parcela_w	:= 1;
		elsif (trunc(dt_inicio_movimentacao_w,'month') = trunc(dt_mes_referencia_p,'month')) and (trunc(dt_adesao_w,'dd') between trunc(dt_inicio_movimentacao_w,'dd') and trunc(dt_fim_movimentacao_w,'dd')) then
			nr_parcela_w	:= 1;
		elsif (trunc(dt_fim_movimentacao_w,'month') = trunc(dt_mes_referencia_p,'month')) and (trunc(dt_adesao_w,'dd') between trunc(dt_inicio_movimentacao_w,'dd') and trunc(dt_fim_movimentacao_w,'dd')) then
			nr_parcela_w	:= 2;
		else
			qt_meses_w	:= months_between(trunc(dt_mes_mensalidade_p,'month'),dt_primeira_mens_w);

			nr_parcela_w	:= qt_meses_w + 1;
		end if;
	else
		if (trunc(dt_fim_movimentacao_w,'month') = trunc(dt_mes_referencia_p,'month')) and (trunc(dt_adesao_w,'dd') between trunc(dt_inicio_movimentacao_w,'dd') and trunc(dt_fim_movimentacao_w,'dd')) then
			nr_parcela_w	:= 1;
		else
			select	months_between(trunc(dt_mes_mensalidade_p,'month'),trunc(dt_primeira_mens_w,'month'))
			into STRICT	qt_meses_w
			;

			if (qt_meses_w = 0) then
				qt_meses_w	:= 1;
			end if;

			nr_parcela_w	:= qt_meses_w + 1;
		end if;
	end if;
else
	select (trunc(months_between(trunc(dt_mes_mensalidade_p,'month'),trunc(dt_adesao_w,'month'))) + 1)
	into STRICT	nr_parcela_w
	;
end if;

return	nr_parcela_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_parcela_segurado ( nr_seq_segurado_p bigint, dt_mes_mensalidade_p timestamp, dt_mes_referencia_p timestamp) FROM PUBLIC;
