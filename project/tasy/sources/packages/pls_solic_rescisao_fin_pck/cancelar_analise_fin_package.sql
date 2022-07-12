-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_solic_rescisao_fin_pck.cancelar_analise_fin (nr_seq_solic_resc_fin_p pls_solic_rescisao_fin.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_commit_p text) AS $body$
DECLARE


nr_seq_solic_rescisao_fin_w	pls_solic_rescisao_fin.nr_sequencia%type;
qt_mensalidade_w		bigint;
qt_baixa_w			bigint;
qt_titulo_dmed_w		bigint;

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	table(pls_obj_dados_rescisao_pck.obter_dados_rescisao(nr_seq_solic_resc_fin_p,cd_estabelecimento_p)) a
	where	a.ie_tipo_item = 1;

c02 CURSOR FOR
	SELECT	nr_seq_nota_credito
	from	pls_solic_resc_fin_venc
	where	nr_seq_solic_resc_fin = nr_seq_solic_resc_fin_p;

C03 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_titulo
	from	titulo_receber_liq a
	where	a.nr_seq_resc_fin = nr_seq_solic_resc_fin_p;

BEGIN

select	count(1)
into STRICT	qt_titulo_dmed_w
from	tax_dmed_dados_gerais a,
	fis_dados_dmed b,
	pls_solic_resc_fin_item c
where	b.nr_sequencia = a.nr_seq_dados_dmed
and	c.nr_sequencia = b.nr_seq_resc_fin_item
and	c.nr_seq_solic_resc_fin = nr_seq_solic_resc_fin_p;

if (qt_titulo_dmed_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1152283);
end if;

select	count(1)
into STRICT	qt_mensalidade_w
from	pls_lote_mensalidade a,
	pls_mensalidade b
where	a.nr_sequencia		= b.nr_seq_lote
and	a.nr_seq_solic_resc_fin = nr_seq_solic_resc_fin_p
and	coalesce(b.ie_cancelamento::text, '') = '';

if (qt_mensalidade_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1128656);
end if;

select	count(1)
into STRICT	qt_baixa_w
from	pls_solic_resc_fin_venc a,
	nota_credito b
where	b.nr_sequencia = a.nr_seq_nota_credito
and	a.nr_seq_solic_resc_fin = nr_seq_solic_resc_fin_p
and	b.vl_nota_credito <> b.vl_saldo;

if (qt_baixa_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1128655);
end if;

for r_c02_w in c02 loop
	begin
	CALL cancelar_nota_credito(r_c02_w.nr_seq_nota_credito, clock_timestamp(), nm_usuario_p);
	end;
end loop;

for r_c03_w in c03 loop
	begin
	CALL estornar_tit_receber_liq(r_c03_w.nr_titulo,r_c03_w.nr_sequencia,clock_timestamp(),nm_usuario_p,'N',wheb_mensagem_pck.get_texto(1128657),null);
	end;
end loop;

select	nextval('pls_solic_rescisao_fin_seq')
into STRICT	nr_seq_solic_rescisao_fin_w
;

insert into pls_solic_rescisao_fin(nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
	nm_usuario, nm_usuario_nrec, dt_fim_analise,
	dt_inicio_analise, nr_seq_pagador, ie_status,
	nr_seq_solicitacao)
SELECT	nr_seq_solic_rescisao_fin_w, clock_timestamp(), clock_timestamp(),
	nm_usuario_p, nm_usuario_p, dt_fim_analise,
	dt_inicio_analise, nr_seq_pagador, 8,
	nr_seq_solicitacao
from	pls_solic_rescisao_fin
where	nr_sequencia = nr_seq_solic_resc_fin_p;

for r_c01_w in c01 loop
	begin
	insert into pls_solic_resc_fin_item(nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
		nm_usuario, nm_usuario_nrec, nr_seq_solic_resc_fin,
		ie_tipo_item, ie_tipo_valor, nr_seq_segurado, 
		vl_item, vl_devolucao_mens, dt_referencia,
		qt_dias_cobertura, qt_dias_devolucao, nr_seq_mensalidade,
		nr_seq_item_mensalidade, ie_acao, nr_titulo,
		vl_pro_rata_dia, vl_antecipacao, vl_ato_auxiliar,
		vl_ato_auxiliar_antec, vl_ato_auxiliar_pro_rata, vl_ato_cooperado,
		vl_ato_cooperado_antec, vl_ato_cooperado_pro_rata, vl_ato_nao_cooperado,
		vl_ato_nao_coop_antec, vl_ato_nao_coop_pro_rata, vl_devolver,
		vl_cancelar, dt_contabil, nr_seq_item_cancel)
	SELECT	nextval('pls_solic_resc_fin_item_seq'), clock_timestamp(), clock_timestamp(),
		nm_usuario_p, nm_usuario_p, nr_seq_solic_rescisao_fin_w,
		ie_tipo_item, ie_tipo_valor, nr_seq_segurado, 
		vl_item*-1, vl_devolucao_mens*-1, dt_referencia,
		qt_dias_cobertura, qt_dias_devolucao, nr_seq_mensalidade,
		nr_seq_item_mensalidade, ie_acao, nr_titulo,
		vl_pro_rata_dia*-1, vl_antecipacao*-1, vl_ato_auxiliar*-1,
		vl_ato_auxiliar_antec*-1, vl_ato_auxiliar_pro_rata*-1, vl_ato_cooperado*-1,
		vl_ato_cooperado_antec*-1, vl_ato_cooperado_pro_rata, vl_ato_nao_cooperado*-1,
		vl_ato_nao_coop_antec*-1, vl_ato_nao_coop_pro_rata*-1, vl_devolver*-1,
		vl_cancelar*-1, dt_contabil, nr_sequencia
	from	pls_solic_resc_fin_item
	where	nr_sequencia = r_c01_w.nr_sequencia;
	end;
end loop;

CALL pls_fiscal_dados_dmed_pck.deletar_devolucao(nr_seq_solic_resc_fin_p);

update	pls_solic_rescisao_fin
set	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p,
	ie_status = 7
where	nr_sequencia = nr_seq_solic_resc_fin_p;

if (coalesce(ie_commit_p, 'N') = 'S') then
	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_solic_rescisao_fin_pck.cancelar_analise_fin (nr_seq_solic_resc_fin_p pls_solic_rescisao_fin.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_commit_p text) FROM PUBLIC;
