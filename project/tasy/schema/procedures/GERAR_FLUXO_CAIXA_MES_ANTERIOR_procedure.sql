-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_fluxo_caixa_mes_anterior (cd_estabelecimento_p bigint, cd_conta_financ_p bigint, ie_regra_data_p text, nr_dia_fixo_p bigint, qt_mes_anterior_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, IE_ACUMULAR_FLUXO_p text, nm_usuario_p text, cd_empresa_p bigint, nr_seq_regra_p bigint) AS $body$
DECLARE


/*--------------------------------------------------------------- ATENÇÃO ----------------------------------------------------------------*/

/* Cuidado ao realizar alterações no fluxo de caixa. Toda e qualquer alteração realizada em qualquer uma das       */

/* procedures do fluxo de caixa deve ser cuidadosamente verificada e realizada no fluxo de caixa em lote.           */

/* Devemos garantir que os dois fluxos de caixa tragam os mesmos valores no resultado, evitando assim que           */

/* existam diferenças entre os fluxos de caixa.                                                                                                                */

/*--------------- AO ALTERAR O FLUXO DE CAIXA ALTERAR TAMBÉM O FLUXO DE CAIXA EM LOTE ---------------*/

vl_fluxo_w		double precision;
vl_deducao_w		double precision;
dt_referencia_w		timestamp;
dt_mes_w		timestamp;
ie_tratar_fim_semana_w	varchar(2);
cd_moeda_empresa_w	integer;
cd_moeda_w		integer;

c02 CURSOR FOR
SELECT	sum(vl_fluxo),
	PKG_DATE_UTILS.ADD_MONTH(dt_referencia,QT_MES_ANTERIOR_p,0),
	cd_moeda
from	fluxo_caixa
where	cd_estabelecimento	= cd_estabelecimento_p
and	cd_conta_financ		= cd_conta_financ_p
and	PKG_DATE_UTILS.start_of(dt_referencia, 'DD',0) between 	PKG_DATE_UTILS.ADD_MONTH(dt_inicial_p, -1 * QT_MES_ANTERIOR_p,0) and
						PKG_DATE_UTILS.ADD_MONTH(dt_final_p, -1 * QT_MES_ANTERIOR_p,0)
and	ie_periodo		= 'D'
and	ie_classif_fluxo	= 'P'
group	by PKG_DATE_UTILS.ADD_MONTH(dt_referencia,QT_MES_ANTERIOR_p,0), cd_moeda;



BEGIN

select	ie_tratar_fim_semana
into STRICT	ie_tratar_fim_semana_w
from	parametro_fluxo_caixa
where	cd_estabelecimento	= cd_estabelecimento_p;

/* Projeto Multimoeda - Busca a moeda padrão da empresa para gravar no fluxo. */

select	obter_moeda_padrao_empresa(cd_estabelecimento_p,'E')
into STRICT	cd_moeda_empresa_w
;

if (ie_regra_data_p = 'F') then

	dt_mes_w	:= PKG_DATE_UTILS.start_of(dt_inicial_p,'MONTH',0);

	select	coalesce(sum(vl_fluxo),0),
		max(cd_moeda)
	into STRICT	vl_fluxo_w,
		cd_moeda_w
	from	fluxo_caixa
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	ie_periodo		= 'D'
	and	ie_classif_fluxo	= 'P'
	and	cd_conta_financ		= cd_conta_financ_p
	and	PKG_DATE_UTILS.start_of(dt_referencia, 'MONTH',0) = PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.ADD_MONTH(dt_inicial_p,-1 * QT_MES_ANTERIOR_p,0), 'MONTH', 0);

	while(dt_mes_w <= PKG_DATE_UTILS.start_of(dt_final_p, 'MONTH',0)) loop

		if (nr_dia_fixo_p > (PKG_DATE_UTILS.extract_field('DAY',PKG_DATE_UTILS.end_of(dt_mes_w,'MONTH',0),0))::numeric ) then
			dt_referencia_w		:= pkg_date_utils.get_datetime(PKG_DATE_UTILS.end_of(dt_mes_w,'MONTH',0), coalesce(dt_mes_w, PKG_DATE_UTILS.GET_TIME('00:00:00')));
		elsif (nr_dia_fixo_p = 0) then
			dt_referencia_w		:= pkg_date_utils.get_date(1,dt_mes_w,0);
		else
			dt_referencia_w		:= pkg_date_utils.get_date(nr_dia_fixo_p, dt_mes_w, 0);
		end if;

		if (dt_referencia_w between dt_inicial_p and dt_final_p) then

			if (ie_tratar_fim_semana_w = 'S') then
				dt_referencia_w			:= obter_proximo_dia_util(cd_estabelecimento_p, dt_referencia_w);
			end if;

			if (OBTER_SE_FLUXO_ESP(cd_estabelecimento_p, cd_conta_financ_p, dt_referencia_w) = 'S') and (obter_se_fluxo_caixa_regra(nr_seq_regra_p, dt_referencia_w, cd_estabelecimento_p, 'E') = 'S') then
				begin
				vl_deducao_w		:= coalesce(obter_se_fluxo_caixa_regra(nr_seq_regra_p, dt_referencia_w, cd_estabelecimento_p, 'VL'), 0);
				insert into fluxo_caixa(cd_estabelecimento,
					dt_referencia,
					cd_conta_financ,
					ie_classif_fluxo,
					dt_atualizacao,
					nm_usuario,
					vl_fluxo,
					ie_origem,
					ie_periodo,
					ie_integracao,
					cd_empresa,
					cd_moeda)
				values (cd_estabelecimento_p,
					dt_referencia_w,
					cd_conta_financ_p,
					'R',
					clock_timestamp(),
					nm_usuario_p,
					vl_fluxo_w - vl_deducao_w,
					'I',
					'D',
					'RE',
					cd_empresa_p,
					coalesce(cd_moeda_w,cd_moeda_empresa_w));
				exception
					when unique_violation then
						update	fluxo_caixa
						set	vl_fluxo		= CASE WHEN IE_ACUMULAR_FLUXO_p='S' THEN  vl_fluxo_w + vl_fluxo  ELSE vl_fluxo_w END  - vl_deducao_w
						where	cd_estabelecimento	= cd_estabelecimento_p
						and	cd_conta_financ	= cd_conta_financ_p
						and	dt_referencia		= dt_referencia_w
						and	ie_periodo		= 'D'
						and	ie_classif_fluxo	= 'R'
						and	ie_integracao		= 'RE'
						and	cd_empresa		= cd_empresa_p;
				end;
			end if;
		end if;

		dt_mes_w	:= PKG_DATE_UTILS.ADD_MONTH(dt_mes_w, 1,0);

		end loop;

elsif (ie_regra_data_p = 'MA') then

	open c02;
	loop
	fetch c02 into
		vl_fluxo_w,
		dt_referencia_w,
		cd_moeda_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		if (ie_tratar_fim_semana_w = 'S') then
			dt_referencia_w			:= obter_proximo_dia_util(cd_estabelecimento_p, dt_referencia_w);
		end if;

		if (OBTER_SE_FLUXO_ESP(cd_estabelecimento_p, cd_conta_financ_p, dt_referencia_w) = 'S') then
			begin
			vl_deducao_w		:= coalesce(obter_se_fluxo_caixa_regra(nr_seq_regra_p, dt_referencia_w, cd_estabelecimento_p, 'VL'), 0);
			insert into fluxo_caixa(cd_estabelecimento,
				dt_referencia,
				cd_conta_financ,
				ie_classif_fluxo,
				dt_atualizacao,
				nm_usuario,
				vl_fluxo,
				ie_origem,
				ie_periodo,
				ie_integracao,
				cd_empresa,
				cd_moeda)
			values (cd_estabelecimento_p,
				dt_referencia_w,
				cd_conta_financ_p,
				'R',
				clock_timestamp(),
				nm_usuario_p,
				vl_fluxo_w - vl_deducao_w,
				'I',
				'D',
				'RE',
				cd_empresa_p,
				coalesce(cd_moeda_w,cd_moeda_empresa_w));
			exception
				when unique_violation then
					update	fluxo_caixa
					set	vl_fluxo		= CASE WHEN IE_ACUMULAR_FLUXO_p='S' THEN  vl_fluxo_w + vl_fluxo  ELSE vl_fluxo_w END  - vl_deducao_w
					where	cd_estabelecimento	= cd_estabelecimento_p
					and	cd_conta_financ	= cd_conta_financ_p
					and	dt_referencia		= dt_referencia_w
					and	ie_periodo		= 'D'
					and	ie_classif_fluxo	= 'R'
					and	ie_integracao		= 'RE'
					and	cd_empresa		= cd_empresa_p;
			end;
		end if;
	end loop;
	close c02;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_fluxo_caixa_mes_anterior (cd_estabelecimento_p bigint, cd_conta_financ_p bigint, ie_regra_data_p text, nr_dia_fixo_p bigint, qt_mes_anterior_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, IE_ACUMULAR_FLUXO_p text, nm_usuario_p text, cd_empresa_p bigint, nr_seq_regra_p bigint) FROM PUBLIC;

