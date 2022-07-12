-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mens_itens_conta_pck.gerar_vl_manutencao_pos ( nr_seq_mensalidade_seg_p pls_mensalidade_segurado.nr_sequencia%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, nr_seq_plano_p pls_plano.nr_sequencia%type) AS $body$
DECLARE


C01 CURSOR(	dt_referencia_pc	pls_mensalidade_segurado.dt_mesano_referencia%type,
		nr_seq_contrato_pc	pls_contrato.nr_sequencia%type,
		nr_seq_intercambio_pc	pls_intercambio.nr_sequencia%type,
		nr_seq_plano_pc		pls_plano.nr_sequencia%type)FOR
	SELECT	a.tx_administracao,
		a.vl_informado
	from	pls_regra_pos_estabelecido	a,
		pls_contrato			b
	where	a.nr_seq_contrato	= b.nr_sequencia
	and	b.nr_sequencia		= nr_seq_contrato_pc
	and	dt_referencia_pc between trunc(coalesce(a.dt_vigencia_inicio,dt_referencia_pc),'month') and
								fim_dia(trunc(coalesce(a.dt_vigencia_fim,dt_referencia_pc),'month'))
	and	a.ie_cobranca	= 'M'
	
union all

	SELECT	a.tx_administracao,
		a.vl_informado
	from	pls_regra_pos_estabelecido	a,
		pls_intercambio			b
	where	a.nr_seq_intercambio	= b.nr_sequencia
	and	b.nr_sequencia		= nr_seq_intercambio_pc
	and	dt_referencia_pc between trunc(coalesce(a.dt_vigencia_inicio,dt_referencia_pc),'month') and
								fim_dia(trunc(coalesce(a.dt_vigencia_fim,dt_referencia_pc),'month'))
	and	a.ie_cobranca	= 'M'
	
union

	select	a.tx_administracao,
		a.vl_informado
	from	pls_regra_pos_estabelecido	a
	where	a.nr_seq_plano	= nr_seq_plano_pc
	and	trunc(dt_referencia_pc,'month') between trunc(coalesce(a.dt_vigencia_inicio,dt_referencia_pc),'month') and
								fim_dia(trunc(coalesce(a.dt_vigencia_fim,dt_referencia_pc),'month'))
	and	not exists	(select	1
				from	pls_regra_pos_estabelecido x
				where	((x.nr_seq_contrato	= nr_seq_contrato_pc) or (x.nr_seq_intercambio = nr_seq_intercambio_pc)))
	and	a.ie_cobranca	= 'M';

BEGIN

for r_c01_w in C01(dt_referencia_p, nr_seq_contrato_p, nr_seq_intercambio_p, nr_seq_plano_p) loop
	begin
	current_setting('pls_mens_itens_conta_pck.ie_inseriu_item_w')::varchar(1) := pls_mens_itens_pck.add_item_conta(nr_seq_mensalidade_seg_p, '10', r_c01_w.vl_informado, null, null, current_setting('pls_mens_itens_conta_pck.pls_segurado_w')::pls_segurado%rowtype.nr_sequencia, current_setting('pls_mens_itens_conta_pck.pls_segurado_w')::pls_segurado%rowtype.nr_seq_titular, 0, 0, 0, '', null, current_setting('pls_mens_itens_conta_pck.ie_inseriu_item_w')::varchar(1));
	end;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_itens_conta_pck.gerar_vl_manutencao_pos ( nr_seq_mensalidade_seg_p pls_mensalidade_segurado.nr_sequencia%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, nr_seq_plano_p pls_plano.nr_sequencia%type) FROM PUBLIC;