-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_venc_titulo (nr_titulo_p bigint, dt_vencimento_p timestamp, ie_tipo_titulo_p text, dt_referencia_p timestamp, cd_conta_financ_p bigint, ie_classif_fluxo_p text, cd_estabelecimento_p bigint, ie_periodo_p text, vl_fluxo_p bigint, nm_usuario_p text, ds_observacao_p text) AS $body$
DECLARE


/*
ie_tipo_titulo_p:
'CR' : TITULO_RECEBER
'CP' : TITULO_PAGAR
'D' : FLUXO_CAIXA (Digitado)
*/
dt_vencimento_atual_w		timestamp;


BEGIN
if (ie_tipo_titulo_p = 'CR') then
	update	titulo_receber
	set	dt_pagamento_previsto = dt_vencimento_p,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_titulo = nr_titulo_p;
elsif (ie_tipo_titulo_p = 'CP') then

	select	max(dt_vencimento_atual)
	into STRICT	dt_vencimento_atual_w
	from	titulo_pagar
	where	nr_titulo = nr_titulo_p;

	update	titulo_pagar
	set	dt_vencimento_atual = dt_vencimento_p,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_titulo = nr_titulo_p;

	insert into titulo_pagar_alt_venc(
				NR_TITULO      ,
				NR_SEQUENCIA   ,
				DT_ANTERIOR    ,
				DT_VENCIMENTO  ,
				DT_ATUALIZACAO ,
				NM_USUARIO     ,
				DT_ALTERACAO   ,
				DS_OBSERVACAO)
		(SELECT	nr_titulo_p,
				coalesce(max(nr_sequencia),0)+1,
				dt_vencimento_atual_w,
				dt_vencimento_p,
				clock_timestamp(),
				nm_usuario_p,
				trunc(clock_timestamp(),'dd'),
				substr(ds_observacao_p,1,255)
			from	titulo_pagar_alt_venc
			where	nr_titulo = nr_titulo_p);

elsif (ie_tipo_titulo_p = 'D') then
	update	fluxo_caixa
	set	dt_referencia 	= dt_vencimento_p,
		nm_usuario 		= nm_usuario_p,
		dt_atualizacao 	= clock_timestamp(),
		vl_fluxo 		= vl_fluxo_p
	where	dt_referencia 	= dt_referencia_p
	and	cd_conta_financ 	= cd_conta_financ_p
	and	ie_classif_fluxo 	= ie_classif_fluxo_p
	and	cd_estabelecimento 	= cd_estabelecimento_p
	and	ie_periodo 		= ie_periodo_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_venc_titulo (nr_titulo_p bigint, dt_vencimento_p timestamp, ie_tipo_titulo_p text, dt_referencia_p timestamp, cd_conta_financ_p bigint, ie_classif_fluxo_p text, cd_estabelecimento_p bigint, ie_periodo_p text, vl_fluxo_p bigint, nm_usuario_p text, ds_observacao_p text) FROM PUBLIC;
