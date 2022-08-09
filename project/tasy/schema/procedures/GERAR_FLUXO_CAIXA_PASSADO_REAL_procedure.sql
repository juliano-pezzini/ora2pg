-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_fluxo_caixa_passado_real (cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_final_p timestamp, dt_referencia_p timestamp, nm_usuario_p text, cd_empresa_p bigint, ie_restringe_estab_p text, ie_data_atual_p text, ie_todas_contas_p text, ie_periodo_p text, vl_saldo_anterior_p bigint, ie_operacao_p text, ie_regra_atraso_p text, ie_somente_ativa_p text, nr_seq_regra_p bigint default null) AS $body$
DECLARE

 
/*--------------------------------------------------------------- ATENÇÃO ----------------------------------------------------------------*/
 
/* Cuidado ao realizar alterações no fluxo de caixa. Toda e qualquer alteração realizada em qualquer uma das    */
 
/* procedures do fluxo de caixa deve ser cuidadosamente verificada e realizada no fluxo de caixa em lote.      */
 
/* Devemos garantir que os dois fluxos de caixa tragam os mesmos valores no resultado, evitando assim que      */
 
/* existam diferenças entre os fluxos de caixa.                                                        */
 
/*--------------- AO ALTERAR O FLUXO DE CAIXA ALTERAR TAMBÉM O FLUXO DE CAIXA EM LOTE ---------------*/
 
 
IE_PASSADO_REAL_w	varchar(20);
dt_referencia_w		timestamp;


BEGIN 
 
 
if (ie_data_atual_p = 'R') then 
	dt_referencia_w		:= trunc(coalesce(dt_referencia_p, clock_timestamp()), 'dd');
else 
	dt_referencia_w		:= trunc(coalesce(dt_referencia_p, clock_timestamp()), 'dd') + 1;
end if;
 
select	coalesce(max(IE_PASSADO_REAL), 'N') 
into STRICT	IE_PASSADO_REAL_w 
from	parametro_fluxo_caixa 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
if (IE_PASSADO_REAL_w = 'S') then -- Edgar 04/12/2007 , OS 74953, tratar duas coluna no mesmo dia 
	if (ie_periodo_p = 'M') then 
		CALL gerar_fluxo_caixa_passado(cd_estabelecimento_p, dt_inicio_p, fim_mes(dt_referencia_w), nm_usuario_p, cd_empresa_p, ie_restringe_estab_p, vl_saldo_anterior_p, coalesce(ie_periodo_p, 'D'),'N',ie_todas_contas_p, ie_operacao_p,ie_somente_ativa_p,nr_seq_regra_p);
		CALL gerar_fluxo_caixa_real(cd_estabelecimento_p, vl_saldo_anterior_p, trunc(dt_referencia_w, 'month'), dt_final_p, nm_usuario_p, cd_empresa_p, ie_restringe_estab_p, coalesce(ie_periodo_p, 'D'),ie_todas_contas_p, 'S', 'S','S','S','S','S','S','S','S','S','S',coalesce(ie_regra_atraso_p,'N'), ie_operacao_p,'N','N',ie_somente_ativa_p,'R',nr_seq_regra_p);
	else 
		CALL gerar_fluxo_caixa_passado(cd_estabelecimento_p, dt_inicio_p, dt_referencia_w, nm_usuario_p, cd_empresa_p, ie_restringe_estab_p, vl_saldo_anterior_p, coalesce(ie_periodo_p, 'D'),'N',ie_todas_contas_p, ie_operacao_p,ie_somente_ativa_p,nr_seq_regra_p);
		CALL gerar_fluxo_caixa_real(cd_estabelecimento_p, vl_saldo_anterior_p, dt_referencia_w, dt_final_p, nm_usuario_p, cd_empresa_p, ie_restringe_estab_p, coalesce(ie_periodo_p, 'D'),ie_todas_contas_p, 'S', 'S','S','S','S','S','S','S','S','S','S',coalesce(ie_regra_atraso_p,'N'), ie_operacao_p,'N','N',ie_somente_ativa_p,'R',nr_seq_regra_p);
	end if;
else 
	CALL gerar_fluxo_caixa_passado(cd_estabelecimento_p, dt_inicio_p, dt_referencia_w - 1, nm_usuario_p, cd_empresa_p, ie_restringe_estab_p, vl_saldo_anterior_p, coalesce(ie_periodo_p, 'D'),'N',ie_todas_contas_p, ie_operacao_p,ie_somente_ativa_p,nr_seq_regra_p);
	CALL gerar_fluxo_caixa_real(cd_estabelecimento_p, vl_saldo_anterior_p, dt_referencia_w, dt_final_p, nm_usuario_p, cd_empresa_p, ie_restringe_estab_p, coalesce(ie_periodo_p, 'D'),ie_todas_contas_p, 'S', 'S','S','S','S','S','S','S','S','S','S',coalesce(ie_regra_atraso_p,'N'), ie_operacao_p,'N','N',ie_somente_ativa_p,nr_seq_regra_p);
end if;
 
-- calcular_fluxo_caixa(cd_estabelecimento_p, 0, dt_inicio_p, dt_referencia_w - 1, 'D', 'P', nm_usuario_p, cd_empresa_p, ie_restringe_estab_p); 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_fluxo_caixa_passado_real (cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_final_p timestamp, dt_referencia_p timestamp, nm_usuario_p text, cd_empresa_p bigint, ie_restringe_estab_p text, ie_data_atual_p text, ie_todas_contas_p text, ie_periodo_p text, vl_saldo_anterior_p bigint, ie_operacao_p text, ie_regra_atraso_p text, ie_somente_ativa_p text, nr_seq_regra_p bigint default null) FROM PUBLIC;
