-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_dt_prev_estim ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(50);
qt_hora_w				double precision;
vl_indice_dia_w			double precision;
cd_consultor_w			varchar(10);
nr_seq_proposta_w		bigint;
nr_seq_mod_impl_w		bigint;
qt_dis_previsao_w		bigint;
nr_predecessora_w		bigint;
dt_prevista_w			timestamp;
dt_vencimento_w			timestamp;
dt_previsao_w			timestamp;
dt_ini_previsto			timestamp;
dt_fim_previsto			timestamp;
dt_ini_implantacao_w	timestamp;
cd_estabelecimento_w	smallint;
dias_uteis_w			bigint;


BEGIN

-- Informações da estimativa
select	a.nr_seq_proposta,
	a.qt_hora,
	a.cd_consultor,
	a.nr_predecessora,
	a.nr_seq_mod_impl
into STRICT	nr_seq_proposta_w,
	qt_hora_w,
	cd_consultor_w,
	nr_predecessora_w,
	nr_seq_mod_impl_w
from	com_cliente_prop_estim a
where	a.nr_sequencia = nr_sequencia_p;

-- Informações da proposta
select (coalesce(a.dt_prev_fechamento,clock_timestamp())+30), -- obter data de previsão de início de implantação
		dt_ini_implantacao
into STRICT	dt_vencimento_w,
		dt_ini_implantacao_w
from	com_cliente_proposta a
where	a.nr_sequencia = nr_seq_proposta_w;

-- Estabelecimento do Cliente
select	a.cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	com_cliente a,
		com_cliente_proposta b
where	a.nr_sequencia = b.nr_seq_cliente
and		b.nr_sequencia = nr_seq_proposta_w;

-- Dias úteis de acordo com a data de fechamento + 30 dias ou com a data de implantação
if (coalesce(dt_ini_implantacao_w::text, '') = '') then
	begin
	select	CASE WHEN obter_dias_uteis_periodo(dt_vencimento_w, fim_mes(dt_vencimento_w), cd_estabelecimento_w)=0 THEN 1  ELSE obter_dias_uteis_periodo(dt_vencimento_w, fim_mes(dt_vencimento_w), cd_estabelecimento_w) END
	into STRICT	dias_uteis_w
	;

	update 	com_cliente_proposta
	set		dt_ini_implantacao = dt_vencimento_w
	where	nr_sequencia = nr_seq_proposta_w;
	end;
else
	select 	CASE WHEN obter_dias_uteis_periodo(dt_ini_implantacao_w, fim_mes(dt_ini_implantacao_w), cd_estabelecimento_w)=0 THEN 1  ELSE obter_dias_uteis_periodo(dt_ini_implantacao_w, fim_mes(dt_ini_implantacao_w), cd_estabelecimento_w) END
	into STRICT	dias_uteis_w
	;
end if;

-- Média de horas por dia no período
vl_indice_dia_w:= qt_hora_w / dias_uteis_w;

if (nr_predecessora_w = 1) then
	begin
	qt_hora_w := qt_hora_w / vl_indice_dia_w;
	if (coalesce(dt_ini_implantacao_w::text, '') = '') then
		dt_ini_previsto := dt_vencimento_w;
	else
		dt_ini_previsto := dt_ini_implantacao_w;
	end if;

	dt_fim_previsto := dt_ini_previsto + qt_hora_w;

	while(obter_dias_uteis_periodo(dt_ini_previsto,dt_fim_previsto,cd_estabelecimento_w) < qt_hora_w) loop
		begin
		dt_fim_previsto := dt_fim_previsto + 1;
		end;
	end loop;

	end;
elsif (nr_predecessora_w > 1) then
	begin
	select	max(dt_fim_prev_estim)
	into STRICT	dt_ini_previsto
	from	com_cliente_prop_estim a
	where	a.nr_seq_proposta = nr_seq_proposta_w
	and	a.cd_consultor = cd_consultor_w
	and	a.nr_predecessora = nr_predecessora_w -1;

	select	sum(a.qt_hora)
	into STRICT	qt_hora_w
	from	com_cliente_prop_estim a
	where	a.nr_seq_proposta = nr_seq_proposta_w
	and	a.cd_consultor = cd_consultor_w
	and	a.nr_predecessora = nr_predecessora_w;
	qt_hora_w := qt_hora_w / vl_indice_dia_w;

	dt_fim_previsto := dt_ini_previsto + qt_hora_w;

	while(obter_dias_uteis_periodo(dt_ini_previsto,dt_fim_previsto,cd_estabelecimento_w) < qt_hora_w) loop
		dt_fim_previsto := dt_fim_previsto + 1;
	end loop;

	end;
end if;

if (ie_opcao_p = 'I') then
	dt_prevista_w := dt_ini_previsto;
elsif (ie_opcao_p = 'F') then
	dt_prevista_w := dt_fim_previsto;
end if;

ds_retorno_w	:= to_char(dt_prevista_w,'dd/mm/yyyy');
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION proj_obter_dt_prev_estim ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

