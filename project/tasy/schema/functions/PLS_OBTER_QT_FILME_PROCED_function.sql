-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qt_filme_proced ( nr_seq_regra_p bigint, nr_seq_prestador_p bigint, dt_atendimento_p timestamp, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_filme_w		double precision;
ie_origem_proced_w	smallint;
cd_edicao_amb_w		integer;
dt_inicio_vigencia_w	timestamp;
vl_ch_honorarios_w	double precision;
vl_ch_custo_oper_w	double precision;
cd_moeda_ch_medico_w	smallint;
cd_moeda_ch_co_w	smallint;
cd_moeda_filme_w	smallint;
cd_moeda_anestesista_w	smallint;
tx_ajuste_geral_w	double precision;
vl_filme_w		double precision;
tx_ajuste_filme_w	double precision;
tx_ajuste_custo_oper_w	double precision;
tx_ajuste_partic_w	double precision;
tx_ajuste_ch_honor_w	double precision;
vl_proc_negociado_w	double precision;
vl_medico_neg_w		double precision;
vl_auxiliares_neg_w	double precision;
vl_anestesista_neg_w	double precision;
vl_custo_oper_neg_w	double precision;
ie_preco_informado_w	varchar(1);
ie_autogerado_w		varchar(1);
nr_seq_cbhpm_edicao_w	bigint;
ie_calculo_tuss_w	varchar(1);
dt_inicio_vig_edicao_w	timestamp;
ds_retorno_w		varchar(15);
nr_seq_edicao_tuss_w	pls_edicao_preco_tuss.nr_sequencia%type;

BEGIN
if (coalesce(nr_seq_regra_p,0) > 0) then
	select	a.cd_edicao_amb,
		a.dt_inicio_vigencia,
		coalesce(a.vl_ch_honorarios,1),
		coalesce(a.vl_ch_custo_oper,1),
		cd_moeda_ch_medico,
		cd_moeda_ch_co,
		cd_moeda_filme,
		cd_moeda_anestesista,
		a.tx_ajuste_geral,
		a.vl_filme,
		a.tx_ajuste_filme,
		a.tx_ajuste_custo_oper,
		a.tx_ajuste_partic,
		a.tx_ajuste_ch_honor,
		coalesce(a.vl_proc_negociado,0),
		coalesce(a.vl_medico,0),
		coalesce(a.vl_auxiliares,0),
		coalesce(a.vl_anestesista,0),
		coalesce(a.vl_custo_operacional,0),
		coalesce(a.ie_preco_informado,'N'),
		ie_autogerado,
		coalesce(a.nr_seq_cbhpm_edicao,0),
		nr_seq_edicao_tuss
	into STRICT	cd_edicao_amb_w,
		dt_inicio_vigencia_w,
		vl_ch_honorarios_w,
		vl_ch_custo_oper_w,
		cd_moeda_ch_medico_w,
		cd_moeda_ch_co_w,
		cd_moeda_filme_w,
		cd_moeda_anestesista_w,
		tx_ajuste_geral_w,
		vl_filme_w,
		tx_ajuste_filme_w,
		tx_ajuste_custo_oper_w,
		tx_ajuste_partic_w,
		tx_ajuste_ch_honor_w,
		vl_proc_negociado_w,
		vl_medico_neg_w,
		vl_auxiliares_neg_w,
		vl_anestesista_neg_w,
		vl_custo_oper_neg_w,
		ie_preco_informado_w,
		ie_autogerado_w,
		nr_seq_cbhpm_edicao_w,
		nr_seq_edicao_tuss_w
	from	pls_regra_preco_proc a
	where	a.nr_sequencia	= nr_seq_regra_p;

	begin
	select	coalesce(ie_origem_proced, ie_origem_proced_w),
		ie_calculo_tuss
	into STRICT	ie_origem_proced_w,
		ie_calculo_tuss_w
	from	edicao_amb
	where	cd_edicao_amb	= cd_edicao_amb_w;
	exception
	when others then
		ie_origem_proced_w	:= ie_origem_proced_w;
	end;

	if (ie_origem_proced_w = 1) or (ie_origem_proced_w = 4) or
		(ie_origem_proced_w = 8 AND ie_calculo_tuss_w = 'A') then
		if (ie_origem_proced_w = 8) then
			SELECT * FROM pls_define_preco_tuss(ie_calculo_tuss_w, cd_edicao_amb_w, cd_procedimento_p, ie_origem_proced_p, dt_atendimento_p, cd_estabelecimento_p, nr_seq_prestador_p, nr_seq_edicao_tuss_w, null, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, qt_filme_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w) INTO STRICT ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, qt_filme_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w;
		else
			/* obter os valores da tabela AMB   */

			begin
			select	coalesce(a.qt_filme,0)
			into STRICT	qt_filme_w
			from	preco_amb a
			where	a.cd_edicao_amb		= cd_edicao_amb_w
			and	a.cd_procedimento	= cd_procedimento_p
			and	coalesce(a.dt_inicio_vigencia, clock_timestamp() - interval '3650 days')	=
					(	SELECT	max(coalesce(b.dt_inicio_vigencia, clock_timestamp() - interval '3650 days'))
						from	preco_amb b
						where	b.cd_edicao_amb		= cd_edicao_amb_w
						and	b.cd_procedimento	= cd_procedimento_p
						and	trunc(dt_atendimento_p,'dd') between coalesce(b.dt_inicio_vigencia,clock_timestamp() - interval '3650 days') and coalesce(b.dt_final_vigencia, dt_atendimento_p));
						-- and	nvl(b.dt_inicio_vigencia, sysdate - 3650) <= dt_guia_p);
			exception
				when others then
					begin
					qt_filme_w := 0;
					end;
			end;
		end if;


	elsif (ie_origem_proced_w = 5) or
		(ie_origem_proced_w = 8 AND ie_calculo_tuss_w = 'C') then
		if (ie_origem_proced_w = 8) then
			SELECT * FROM pls_define_preco_tuss(ie_calculo_tuss_w, cd_edicao_amb_w, cd_procedimento_p, ie_origem_proced_p, dt_atendimento_p, cd_estabelecimento_p, nr_seq_prestador_p, nr_seq_edicao_tuss_w, null, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, qt_filme_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w) INTO STRICT ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, qt_filme_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w;
		else
			/* obter os valores da tabela CBHPM */

			begin
			select	dt_vigencia
			into STRICT	dt_inicio_vig_edicao_w
			from	cbhpm_edicao
			where	nr_sequencia	= nr_seq_cbhpm_edicao_w;
			exception
			when others then
				dt_inicio_vig_edicao_w	:= dt_inicio_vigencia_w;
			end;

			SELECT * FROM pls_obter_preco_cbhpm(
					cd_estabelecimento_p, dt_atendimento_p, cd_procedimento_p, ie_origem_proced_w, dt_inicio_vig_edicao_w, nr_seq_prestador_p, null, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, qt_filme_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, null) INTO STRICT ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, qt_filme_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w, ds_retorno_w;
		end if;
	end if;
end if;

return	qt_filme_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qt_filme_proced ( nr_seq_regra_p bigint, nr_seq_prestador_p bigint, dt_atendimento_p timestamp, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

