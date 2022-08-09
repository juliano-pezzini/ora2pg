-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_resumo_fluxo_caixa (dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text, cd_empresa_p bigint) AS $body$
DECLARE

 
cd_conta_financ_w	bigint;
cd_conta_saldo_w	bigint;
cd_conta_saldo_ant_w	bigint;
vl_amanha_w		double precision;
vl_semana_1_w		double precision;
vl_semana_2_w		double precision;
vl_semana_3_w		double precision;
vl_semana_4_w		double precision;
vl_semana_5_w		double precision;
vl_fluxo_semana_w	double precision;
vl_fluxo_w		double precision;
dt_inicio_semana_w	timestamp;
dt_final_semana_w	timestamp;
qt_semana_w		smallint;
nr_seq_regra_comp_w	parametro_fluxo_caixa.nr_seq_regra_comp%type;

 
c01 CURSOR FOR 
SELECT	distinct cd_conta_financ 
from	fluxo_caixa 
where	cd_estabelecimento	= cd_estabelecimento_p 
and	ie_classif_fluxo	= 'R' 
and	ie_periodo		= 'D';

 
c02 CURSOR FOR 
SELECT	vl_fluxo 
from	fluxo_caixa 
where	cd_estabelecimento	= cd_estabelecimento_p 
and	ie_classif_fluxo	= 'R' 
and	ie_periodo		= 'D' 
and	cd_conta_financ		= cd_conta_financ_w 
and	(((trunc(dt_referencia, 'dd')	between dt_inicio_semana_w and dt_final_semana_w) and 	-- tratar contas normais 
	cd_conta_financ not in (cd_conta_saldo_w, cd_conta_saldo_ant_w)) 
	or 
	((cd_conta_financ = cd_conta_saldo_ant_w and  		-- pegar o saldo anterior da semana selecionada 
	trunc(dt_referencia, 'dd') = dt_inicio_semana_w) 
	or (cd_conta_financ = cd_conta_saldo_w and 			-- pegar o saldo atual da semana selecionada 
	trunc(dt_referencia, 'dd') = dt_final_semana_w))) 
order	by dt_referencia;


BEGIN 
 
select	max(cd_conta_financ_saldo), 
	max(cd_conta_financ_sant), 
	max(nr_seq_regra_comp) 
into STRICT 	cd_conta_saldo_w, 
	cd_conta_saldo_ant_w, 
	nr_seq_regra_comp_w 
from 	Parametro_Fluxo_caixa 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
CALL gerar_fluxo_caixa_real(cd_estabelecimento_p, 
	null, 
	trunc(dt_referencia_p, 'month'), 
	last_day(dt_referencia_p), 
	nm_usuario_p, 
	cd_empresa_p, 
	'S', 
	'D', 
	'N', 
	'N', 
	'S', 
	'S', 
	'S', 
	'S', 
	'S', 
	'S', 
	'S', 
	'S', 
	'S', 
	'S', 
	'N', 
	'', 
	'N', 
	'N', 
	'N', 
	'R', 
	nr_seq_regra_comp_w);
 
CALL Calcular_Fluxo_Caixa(CD_ESTABELECIMENTO_P, 
	null, 
	trunc(dt_referencia_p, 'month'), 
	last_day(dt_referencia_p), 
	'D', 
	'R', 
	NM_USUARIO_P, 
	cd_empresa_p, 
	'S', 
	'N', 
	'N', 
	nr_seq_regra_comp_w);
 
delete	from W_RESUMO_FLUXO_CAIXA 
where	dt_atualizacao < clock_timestamp() - interval '30 days';
 
delete	from W_RESUMO_FLUXO_CAIXA 
where	nm_usuario = nm_usuario_p;
 
open c01;
loop 
fetch c01 into 
	cd_conta_financ_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
	select	coalesce(sum(vl_fluxo),0) 
	into STRICT	vl_amanha_w 
	from	fluxo_caixa 
	where	cd_estabelecimento		= cd_estabelecimento_p 
	and	trunc(dt_referencia, 'dd')	= trunc(dt_referencia_p, 'dd') + 1 
	and	cd_conta_financ		= cd_conta_financ_w 
	and	ie_classif_fluxo	= 'R' 
	and	ie_periodo		= 'D';
 
	dt_inicio_semana_w	:= trunc(dt_referencia_p, 'month');
	dt_final_semana_w	:= dt_inicio_semana_w + 6;
	qt_semana_w		:= 1;
 
	vl_semana_1_w		:= 0;
	vl_semana_2_w		:= 0;
	vl_semana_3_w		:= 0;
	vl_semana_4_w		:= 0;
	vl_semana_5_w		:= 0;
 
	while	trunc(dt_inicio_semana_w,'month') = trunc(dt_referencia_p, 'month') loop 
 
		vl_fluxo_semana_w	:= 0;
 
		open c02;
		loop 
		fetch c02 into 
			vl_fluxo_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			vl_fluxo_semana_w	:= vl_fluxo_w + vl_fluxo_semana_w;
		end loop;
		close c02;
 
		if (qt_semana_w = 1) then 
			vl_semana_1_w	:= vl_fluxo_semana_w;
		elsif (qt_semana_w = 2) then 
			vl_semana_2_w	:= vl_fluxo_semana_w;
		elsif (qt_semana_w = 3) then 
			vl_semana_3_w	:= vl_fluxo_semana_w;
		elsif (qt_semana_w = 4) then 
			vl_semana_4_w	:= vl_fluxo_semana_w;
		elsif (qt_semana_w = 5) then 
			vl_semana_5_w	:= vl_fluxo_semana_w;
		end if;
 
		qt_semana_w	:= qt_semana_w + 1;
 
		dt_inicio_semana_w	:= dt_final_semana_w + 1;
		dt_final_semana_w	:= dt_final_semana_w + 7;
 
		if (trunc(dt_final_semana_w, 'month') <> trunc(dt_referencia_p, 'month')) then 
			dt_final_semana_w	:= last_day(dt_referencia_p);
		end if;
 
	end loop;
 
	insert	into w_resumo_fluxo_caixa(nr_sequencia, 
		cd_estabelecimento, 
		cd_conta_financ, 
		vl_amanha, 
		vl_semana_1, 
		vl_semana_2, 
		vl_semana_3, 
		vl_semana_4, 
		vl_semana_5, 
		dt_atualizacao, 
		nm_usuario) 
	values (nextval('w_resumo_fluxo_caixa_seq'), 
		cd_estabelecimento_p, 
		cd_conta_financ_w, 
		vl_amanha_w, 
		vl_semana_1_w, 
		vl_semana_2_w, 
		vl_semana_3_w, 
		vl_semana_4_w, 
		vl_semana_5_w, 
		clock_timestamp(), 
		nm_usuario_p);
end loop;
close c01;
 
commit;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_resumo_fluxo_caixa (dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text, cd_empresa_p bigint) FROM PUBLIC;
