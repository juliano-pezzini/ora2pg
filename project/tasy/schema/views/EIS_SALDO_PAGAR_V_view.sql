-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_saldo_pagar_v (dt_referencia, vl_saldo, vl_meta, pr_meta, cd_estabelecimento, cd_empresa) AS select	trunc(a.dt_vencimento, 'month') dt_referencia,
	sum(a.vl_saldo) vl_saldo,
	b.vl_meta,
	(dividir_sem_round(b.vl_meta,sum(a.vl_saldo)) * 100) pr_meta,
	a.cd_estabelecimento,
	substr(obter_empresa_estab(a.cd_estabelecimento),1,255) cd_empresa
FROM	eis_meta_contas_pagar b,
	Eis_Contas_Pagar a
where	DT_VENCIMENTO is not null
and	a.cd_estabelecimento		= b.cd_estabelecimento
and	trunc(a.DT_VENCIMENTO, 'month') = trunc(b.dt_referencia, 'month')
group	by a.dt_vencimento,
	b.vl_meta,
	a.cd_estabelecimento,
	substr(obter_empresa_estab(a.cd_estabelecimento),1,255);

