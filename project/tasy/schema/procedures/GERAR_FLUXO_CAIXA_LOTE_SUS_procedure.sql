-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_fluxo_caixa_lote_sus ( nr_seq_lote_fluxo_p bigint, nr_seq_regra_p bigint, cd_estabelecimento_p bigint, cd_conta_financ_p bigint, ie_regra_data_p text, nr_dia_fixo_p bigint, qt_mes_anterior_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text, cd_empresa_p bigint) AS $body$
DECLARE

 
/*--------------------------------------------------------------- ATENÇÃO ----------------------------------------------------------------*/
 
/* Cuidado ao realizar alterações no fluxo de caixa em lote. Toda e qualquer alteração realizada em qualquer uma */
 
/* das procedures do fluxo de caixa em lote deve ser cuidadosamente verificada e realizada no fluxo de caixa   */
 
/* convencional. Devemos garantir que os dois fluxos de caixa tragam os mesmos valores no resultado, evitando   */
 
/* assim que existam diferenças entre os fluxos de caixa.                                                */
 
/*--------------- AO ALTERAR O FLUXO DE CAIXA EM LOTE ALTERAR TAMBÉM O FLUXO DE CAIXA ---------------*/
 
 
vl_fluxo_w		double precision;
dt_mes_w		timestamp;
dt_referencia_w		timestamp;
ie_tratar_fim_semana_w	varchar(2);
nr_interno_conta_w	conta_paciente.nr_interno_conta%type;
dt_inicial_w		timestamp;
dt_final_w		timestamp;

c01 CURSOR FOR 
SELECT	sum(a.vl_conta), 
	a.nr_interno_conta, 
	add_months(trunc(a.dt_acerto_conta, 'dd'), qt_mes_anterior_p) 
from	convenio b, 
	conta_paciente a 
where	a.cd_convenio_parametro	= b.cd_convenio 
and	a.cd_estabelecimento	= cd_estabelecimento_p 
and	coalesce(a.ie_cancelamento, ' ') not in ('C', 'E') 
and	b.ie_tipo_convenio	= 3 
and	a.ie_status_acerto	= 2 
and	trunc(a.dt_acerto_conta, 'dd') between dt_inicial_w and dt_final_w 
group by nr_interno_conta, 
	add_months(trunc(a.dt_acerto_conta, 'dd'), qt_mes_anterior_p);


BEGIN 
 
dt_inicial_w	:= add_months(dt_inicial_p, qt_mes_anterior_p * -1);
dt_final_w	:= add_months(dt_final_p, qt_mes_anterior_p * -1);
 
select	ie_tratar_fim_semana 
into STRICT	ie_tratar_fim_semana_w 
from	parametro_fluxo_caixa 
where	cd_estabelecimento = cd_estabelecimento_p;
 
if (ie_regra_data_p = 'F') then 
 
	dt_mes_w := trunc(dt_inicial_p,'month');
 
	while(dt_mes_w <= trunc(dt_final_p, 'month')) loop 
 
		if (nr_dia_fixo_p > (to_char(last_day(dt_mes_w), 'dd'))::numeric ) then 
			dt_referencia_w	:= last_day(dt_mes_w);
		else 
			dt_referencia_w	:= to_date(to_char(nr_dia_fixo_p,'00') || '/' || to_char(dt_mes_w, 'mm/yyyy'), 'dd/mm/yyyy');
		end if;
 
		if (dt_referencia_w between dt_inicial_p and dt_final_p) then 
 
			if (ie_tratar_fim_semana_w = 'S') then 
				dt_referencia_w	:= obter_proximo_dia_util(cd_estabelecimento_p, dt_referencia_w);
			end if;
 
			select	sum(a.vl_conta) 
			into STRICT	vl_fluxo_w 
			from	convenio b, 
				conta_paciente a 
			where	a.cd_convenio_parametro	= b.cd_convenio 
			and	a.cd_estabelecimento	= cd_estabelecimento_p 
			and	coalesce(a.ie_cancelamento, ' ') not in ('C', 'E') 
			and	b.ie_tipo_convenio	= 3 
			and	a.ie_status_acerto	= 2 
			and	trunc(a.dt_acerto_conta, 'dd') between dt_inicial_w and dt_final_w;
 
			CALL GERAR_FLUXO_CAIXA_LOTE(	dt_referencia_w, 
						cd_conta_financ_p, 
						'', 
						'19-1', 
						'RE', 
						nm_usuario_p, 
						null, 
						null, 
						null, 
						null, 
						null, 
						null, 
						null, 
						null, 
						nr_seq_lote_fluxo_p, 
						null, 
						null, 
						null, 
						null, 
						nr_seq_regra_p, 
						null, 
						null, 
						coalesce(vl_fluxo_w,0));
		end if;
		dt_mes_w := add_months(dt_mes_w, 1);
	end loop;
 
elsif (ie_regra_data_p = 'MA') then 
 
	open c01;
	loop 
	fetch c01 into 
		vl_fluxo_w, 
		nr_interno_conta_w, 
		dt_referencia_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		if (ie_tratar_fim_semana_w = 'S') then 
			dt_referencia_w	:= obter_proximo_dia_util(cd_estabelecimento_p, dt_referencia_w);
		end if;
		 
		CALL GERAR_FLUXO_CAIXA_LOTE(	dt_referencia_w, 
					cd_conta_financ_p, 
					'', 
					'19-2', 
					'RE', 
					nm_usuario_p, 
					null, 
					nr_interno_conta_w, 
					null, 
					null, 
					null, 
					null, 
					null, 
					null, 
					nr_seq_lote_fluxo_p, 
					null, 
					null, 
					null, 
					null, 
					nr_seq_regra_p, 
					null, 
					null, 
					coalesce(vl_fluxo_w,0));
	end loop;
	close c01;
 
end if;
 
/*NAO COLOCAR COMMIT NESTA PROCEDURE*/
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_fluxo_caixa_lote_sus ( nr_seq_lote_fluxo_p bigint, nr_seq_regra_p bigint, cd_estabelecimento_p bigint, cd_conta_financ_p bigint, ie_regra_data_p text, nr_dia_fixo_p bigint, qt_mes_anterior_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text, cd_empresa_p bigint) FROM PUBLIC;
