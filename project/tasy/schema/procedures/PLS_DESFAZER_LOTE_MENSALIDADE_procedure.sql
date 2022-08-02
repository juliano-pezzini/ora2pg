-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_lote_mensalidade ( nr_seq_lote_p pls_lote_mensalidade.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


qt_adicionais_w			integer;
nr_seq_lote_ted_w		pls_lote_mensalidade_ted.nr_sequencia%type;
ie_status_w			pls_lote_mensalidade.ie_status%type;
qt_comissao_w			bigint;
nr_seq_lote_mov_w		bigint;
nr_seq_lote_mens_w		bigint;
ie_atualizar_pagador_conta_w	varchar(1);

tb_nr_seq_item_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_nota_credito_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_lancamento_prog_w	pls_util_cta_pck.t_number_table;

tb_nr_seq_seg_item_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_pos_proc_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_pos_mat_w		pls_util_cta_pck.t_number_table;

tb_nota_credito_w		pls_util_cta_pck.t_number_table;
indice_nc_w			integer;

tb_lancamento_programado_w	pls_util_cta_pck.t_number_table;
indice_lanc_prog_w		integer;

tb_nr_seq_mensalidade_seg_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_mensalidade_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_segurado_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_segurado_mens_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_pagador_w		pls_util_cta_pck.t_number_table;
tb_ie_existe_conta_w		pls_util_cta_pck.t_varchar2_table_1;
tb_qt_alt_pagador_w		pls_util_cta_pck.t_number_table;

dt_geracao_lote_w		timestamp;
dt_contabilizacao_lote_w	timestamp;
ie_limpar_dt_contabilizacao_w	varchar(1);
ie_antecipacao_geracao_w	varchar(1);

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_nota_credito,
		a.nr_seq_lancamento_mens
	from	pls_mensalidade_seg_item	a,
		pls_mensalidade_segurado	b,
		pls_mensalidade			c
	where	b.nr_sequencia	= a.nr_seq_mensalidade_seg
	and	c.nr_sequencia	= b.nr_seq_mensalidade
	and	c.nr_seq_lote	= nr_seq_lote_p
	order by
		coalesce(c.ie_cancelamento,' ') desc,
		a.nr_seq_item_estorno;

C02 CURSOR FOR
	SELECT	a.nr_seq_segurado
	from	pls_mensalidade_segurado	a,
		pls_mensalidade			b
	where	b.nr_sequencia	= a.nr_seq_mensalidade
	and	a.nr_parcela	= 1
	and	b.nr_seq_lote	= nr_seq_lote_p;

C03 CURSOR FOR
	SELECT	a.nr_sequencia,
		c.nr_sequencia nr_seq_segurado,
		c.nr_seq_pagador,
		coalesce((	SELECT	'S'
			from	pls_conta_coparticipacao x
			where	a.nr_sequencia = x.nr_seq_mensalidade_seg
			
union

			select	'S'
			from	pls_conta_pos_estabelecido x
			where	a.nr_sequencia = x.nr_seq_mensalidade_seg
			
union
	
			select	'S'
			from	pls_conta_co x
			where	a.nr_sequencia = x.nr_seq_mensalidade_seg), 'N') ie_existe_conta,
		(select	count(1)
		from	pls_segurado_pagador x
		where	c.nr_sequencia = x.nr_seq_segurado) qt_alt_pagador
	from	pls_mensalidade_segurado	a,
		pls_mensalidade			b,
		pls_segurado 			c
	where	b.nr_sequencia	= a.nr_seq_mensalidade
	and	c.nr_sequencia	= a.nr_seq_segurado
	and	b.nr_seq_lote	= nr_seq_lote_p;

C04 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_mensalidade
	where	nr_seq_lote	= nr_seq_lote_p;

C05 CURSOR(nr_seq_mensalidade_pc	pls_mensalidade.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		nr_seq_nota_credito
	from	nota_credito_baixa
	where	nr_seq_mensalidade	= nr_seq_mensalidade_pc;

C06 CURSOR FOR
	SELECT	b.nr_sequencia,
		a.nr_seq_pos_proc,
		a.nr_seq_pos_mat
	from	pls_mensalidade_item_conta a,
		pls_mensalidade_seg_item b,
		pls_mensalidade_segurado c,
		pls_mensalidade d
	where	b.nr_sequencia = a.nr_seq_item
	and	c.nr_sequencia = b.nr_seq_mensalidade_seg
	and	d.nr_sequencia = c.nr_seq_mensalidade
	and	d.nr_seq_lote = nr_seq_lote_p
	and	((a.nr_seq_pos_mat IS NOT NULL AND a.nr_seq_pos_mat::text <> '') or (a.nr_seq_pos_proc IS NOT NULL AND a.nr_seq_pos_proc::text <> ''))
	order by
		coalesce(d.ie_cancelamento,' ') desc;

BEGIN

ie_atualizar_pagador_conta_w	:= coalesce(obter_valor_param_usuario(1205, 47, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p), 'N');

select	ie_status,
	dt_geracao,
	dt_contabilizacao
into STRICT	ie_status_w,
	dt_geracao_lote_w,
	dt_contabilizacao_lote_w
from	pls_lote_mensalidade
where	nr_sequencia	= nr_seq_lote_p;

if (ie_status_w = '2') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 199071, null);
	/* O lote de mensalidades ja esta fechado, nao pode ser desfeito! */

end if;

select	count(1)
into STRICT	qt_adicionais_w
from	pls_mensalidade_seg_adic a,
	pls_mensalidade_segurado b,
	pls_mensalidade c
where	b.nr_sequencia	= a.nr_seq_mensalidade_seg
and	c.nr_sequencia	= b.nr_seq_mensalidade
and	c.nr_seq_lote	= nr_seq_lote_p;

if (qt_adicionais_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 199069, null);
	/* Nao e possivel desfazer a geracao do lote pois existem lancamentos adicionais. Verifique! */

end if;

select	count(1)
into STRICT	qt_adicionais_w
from	pls_ame_lote_rem_valor	a,
	pls_mensalidade_segurado b,
	pls_mensalidade		c
where	b.nr_sequencia	= a.nr_seq_mensalidade_seg
and	c.nr_sequencia	= b.nr_seq_mensalidade
and	c.nr_seq_lote	= nr_seq_lote_p;

if (qt_adicionais_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 318281, null);
	/*Nao e possivel desfazer a geracao do lote pois existem lote de arquivos de mensalidade empresariais gerados. Verifique!*/

end if;

select	max(a.nr_seq_lote_ted)
into STRICT	nr_seq_lote_ted_w
from	pls_mensalidade_ted a
where	exists (SELECT	1
		from	pls_mensalidade x
		where	x.nr_sequencia	= a.nr_seq_mensalidade
		and	x.nr_seq_lote	= nr_seq_lote_p);

if (coalesce(nr_seq_lote_ted_w,0) > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 334742, 'NR_SEQ_LOTE='||nr_seq_lote_ted_w);
	/* Nao e possivel desfazer a geracao do lote, pois ja existe mensalidade no lote TED #@NR_SEQ_LOTE#@. Favor verifique. */

end if;

select	max(c.nr_sequencia)
into STRICT	nr_seq_lote_mov_w
from	pls_mov_mens_benef_item a,
	pls_mov_mens_benef b,
	pls_mov_mens_lote c
where	c.nr_sequencia = b.nr_seq_lote
and	b.nr_sequencia = a.nr_seq_mov_benef
and	a.nr_seq_item_mens in (	SELECT	x.nr_sequencia
				from	pls_mensalidade_seg_item x,
					pls_mensalidade_Segurado y,
					pls_mensalidade w
				where	w.nr_sequencia = y.nr_seq_mensalidade
				and	y.nr_sequencia = x.nr_seq_mensalidade_seg
				and	w.nr_seq_lote = nr_seq_lote_p);
				
if (coalesce(nr_seq_lote_mov_w,0) > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1080588, 'NR_SEQ_LOTE='||nr_seq_lote_mov_w);
	/* Nao e possivel desfazer a geracao do lote, pois existem itens de mensalidade no lote de movimentacao #@NR_SEQ_LOTE#@. Favor verificar. */

end if;

select	count(1)
into STRICT	qt_comissao_w
from	pls_mensalidade a,
	pls_mensalidade_segurado b,
	pls_comissao_beneficiario c
where	a.nr_sequencia	= b.nr_seq_mensalidade
and	b.nr_sequencia	= c.nr_seq_segurado_mens
and	a.nr_seq_lote	= nr_seq_lote_p;

if (coalesce(qt_comissao_w,0) > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 762543, null);
	/* Nao e possivel desfazer a geracao do lote pois existem comissoes geradas para os beneficiarios. Verifique! */

end if;

select	max(a.nr_sequencia)
into STRICT	nr_seq_lote_mens_w
from	pls_lote_mensalidade a,
	pls_mensalidade b,
	pls_mensalidade_segurado c,
	pls_mensalidade_seg_item d
where	a.nr_sequencia = b.nr_seq_lote
and	coalesce(b.ie_cancelamento::text, '') = ''
and	a.nr_sequencia <> nr_seq_lote_p
and	b.nr_sequencia = c.nr_seq_mensalidade
and	c.nr_sequencia = d.nr_seq_mensalidade_seg
and	exists (SELECT	1
		from	pls_mensalidade_segurado y,
			pls_mensalidade w,
			pls_segurado_mensalidade x
		where	w.nr_sequencia = y.nr_seq_mensalidade
		and	y.nr_sequencia = x.nr_seq_mens_seg_gerado
		and	w.nr_seq_lote = nr_seq_lote_p
		and	x.nr_sequencia = d.nr_seq_segurado_mens);

if (coalesce(nr_seq_lote_mens_w,0) > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1080760, 'NR_SEQ_LOTE='||nr_seq_lote_mens_w);
	/*Nao e possivel desfazer a geracao do lote, pois existem lancamentos automaticos ja cobrados no lote de mensalidade #@NR_SEQ_LOTE#@. */

end if;

CALL pls_gravar_historico_lote_mens(nr_seq_lote_p, 2, null, nm_usuario_p, 'N');

open C06;
loop
fetch C06 bulk collect into tb_nr_seq_seg_item_w, tb_nr_seq_pos_proc_w, tb_nr_seq_pos_mat_w limit 1000;
exit when tb_nr_seq_seg_item_w.count = 0;
	for i in tb_nr_seq_seg_item_w.first..tb_nr_seq_seg_item_w.last loop
		if ((tb_nr_seq_pos_proc_w(i) IS NOT NULL AND (tb_nr_seq_pos_proc_w(i))::text <> '')) then
			update	pls_conta_pos_proc
			set	ie_status_faturamento		= 'L',
				nr_seq_regra_limite_mens	 = NULL,
				nm_usuario			= nm_usuario_p,
				dt_atualizacao			= clock_timestamp()
			where	nr_sequencia			= tb_nr_seq_pos_proc_w(i);
		elsif ((tb_nr_seq_pos_mat_w(i) IS NOT NULL AND (tb_nr_seq_pos_mat_w(i))::text <> '')) then
			update	pls_conta_pos_mat
			set	ie_status_faturamento		= 'L',
				nr_seq_regra_limite_mens	 = NULL,
				nm_usuario			= nm_usuario_p,
				dt_atualizacao			= clock_timestamp()
			where	nr_sequencia			= tb_nr_seq_pos_mat_w(i);
		end if;
	end loop;
end loop;
close C06;

update	pls_conta_coparticipacao t
set	t.ie_iniciou_cobranca	= 0,
	t.dt_atualizacao	= clock_timestamp(),
	t.nm_usuario		= nm_usuario_p
where	t.ie_iniciou_cobranca	= 1
and	t.nr_sequencia in (
			SELECT	a.nr_seq_conta_copartic
			from	pls_mensalidade_item_conta a,
				pls_mensalidade_seg_item b,
				pls_mensalidade_segurado c,
				pls_mensalidade d
			where	b.nr_sequencia	= a.nr_seq_item
			and	c.nr_sequencia	= b.nr_seq_mensalidade_seg
			and	d.nr_sequencia	= c.nr_seq_mensalidade
			and	b.ie_tipo_item	= '3'
			and (  SELECT	coalesce(sum(x.vl_item),0)
				from	pls_mensalidade_item_conta x
				where	x.nr_seq_conta_copartic = a.nr_seq_conta_copartic
				and	x.nr_seq_item <> b.nr_sequencia) = 0
			and	d.nr_seq_lote	= nr_seq_lote_p);

open C01;
loop
	fetch C01 bulk collect into tb_nr_seq_item_w, tb_nr_seq_nota_credito_w, tb_nr_seq_lancamento_prog_w limit 1000;
	exit when tb_nr_seq_item_w.count = 0;
	
	forall i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last
		delete	FROM pls_mens_seg_item_aprop
		where	nr_seq_item = tb_nr_seq_item_w(i);
	commit;
	
	forall i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last
		update	pls_segurado_agravo_parc
		set	nr_seq_mensalidade_item	 = NULL
		where	nr_seq_mensalidade_item	= tb_nr_seq_item_w(i);
	commit;
	
	forall i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last
		delete	FROM pls_mensalidade_sca
		where	nr_seq_item_mens	= tb_nr_seq_item_w(i);
	commit;
	
	forall i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last
		delete	FROM pls_mensalidade_trib
		where	nr_seq_item_mens	= tb_nr_seq_item_w(i);
	commit;

	forall i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last
		update	pls_lancamento_mensalidade
		set	nr_seq_mensalidade_item	 = NULL,
			nr_seq_mensalidade	 = NULL
		where	nr_seq_mensalidade_item	= tb_nr_seq_item_w(i);
	commit;
	
	forall i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last
		update	pls_segurado_mensalidade
		set	nr_seq_item_mensalidade	 = NULL,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p,
			ie_situacao		= CASE WHEN ie_acao_desfazer='I' THEN  ie_acao_desfazer  ELSE 'A' END
		where	nr_seq_item_mensalidade	= tb_nr_seq_item_w(i)
		and	coalesce(ie_acao_desfazer,'A') in ('A', 'I');
	commit;
	
	forall i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last
		delete	FROM pls_segurado_mensalidade
		where	nr_seq_item_mensalidade	= tb_nr_seq_item_w(i)
		and	ie_acao_desfazer	= 'E';
	commit;
	
	forall i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last
		delete	FROM pls_repasse_mens_item
		where	nr_seq_mensalidade_seg_item = tb_nr_seq_item_w(i);
	commit;
	
	tb_nota_credito_w.delete;
	indice_nc_w	:= 0;
	for i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last loop
		if ((tb_nr_seq_nota_credito_w(i) IS NOT NULL AND (tb_nr_seq_nota_credito_w(i))::text <> '')) then
			tb_nota_credito_w(indice_nc_w)	:= tb_nr_seq_nota_credito_w(i);
			indice_nc_w	:= indice_nc_w + 1;
		end if;
	end loop;
	
	tb_lancamento_programado_w.delete;
	indice_lanc_prog_w	:= 0;

	for i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last loop
		if ((tb_nr_seq_lancamento_prog_w(i) IS NOT NULL AND (tb_nr_seq_lancamento_prog_w(i))::text <> '')) then
			tb_lancamento_programado_w(indice_lanc_prog_w) := tb_nr_seq_lancamento_prog_w(i);
			indice_lanc_prog_w	:= indice_lanc_prog_w + 1;
		end if;
	end loop;

	forall i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last
		delete from pls_mensalidade_seg_item where nr_sequencia = tb_nr_seq_item_w(i);
	commit;
	
	if (tb_lancamento_programado_w.count > 0) then
		for i in tb_lancamento_programado_w.first..tb_lancamento_programado_w.last loop
			CALL pls_atualizar_saldo_lanc_prog(tb_lancamento_programado_w(i),'N');
		end loop;
	end if;
	
	if (tb_nota_credito_w.count > 0) then
		for i in tb_nota_credito_w.first..tb_nota_credito_w.last loop
			CALL atualizar_saldo_nota_credito(tb_nota_credito_w(i),nm_usuario_p);
		end loop;
	end if;
end loop;
close C01;

open C02;
loop
	fetch C02 bulk collect into tb_nr_seq_segurado_w limit 1000;
	exit when tb_nr_seq_segurado_w.count = 0;
	
	forall i in tb_nr_seq_segurado_w.first..tb_nr_seq_segurado_w.last
		update	pls_segurado
		set	ie_mensalidade_proporcional  = NULL
		where	nr_sequencia	= tb_nr_seq_segurado_w(i);
	commit;
end loop;
close C02;


open C03;
loop
	fetch C03 bulk collect into tb_nr_seq_mensalidade_seg_w, tb_nr_seq_segurado_mens_w, tb_nr_seq_pagador_w, tb_ie_existe_conta_w, tb_qt_alt_pagador_w limit 1000;
	exit when tb_nr_seq_mensalidade_seg_w.count = 0;
	
	forall i in tb_nr_seq_mensalidade_seg_w.first..tb_nr_seq_mensalidade_seg_w.last
		delete	FROM pls_segurado_mensalidade
		where	nr_seq_mens_seg_gerado	= tb_nr_seq_mensalidade_seg_w(i);
	commit;
	
	forall i in tb_nr_seq_mensalidade_seg_w.first..tb_nr_seq_mensalidade_seg_w.last
		delete	FROM pls_repasse_mens
		where	nr_seq_mens_seg	= tb_nr_seq_mensalidade_seg_w(i);
	commit;
	
	forall i in tb_nr_seq_mensalidade_seg_w.first..tb_nr_seq_mensalidade_seg_w.last
		delete	FROM pls_mensalidade_critica
		where	nr_seq_mensalidade_seg	= tb_nr_seq_mensalidade_seg_w(i);
	commit;
	
	forall i in tb_nr_seq_mensalidade_seg_w.first..tb_nr_seq_mensalidade_seg_w.last
		update	pls_conta_coparticipacao
		set	nr_seq_mensalidade_seg		 = NULL,
			ie_status_mensalidade		= 'L',
			vl_copartic_mens		 = NULL,
			nr_seq_regra_limite_copartic	 = NULL,
			dt_atualizacao			= clock_timestamp(),
			nm_usuario			= nm_usuario_p
		where	nr_seq_mensalidade_seg		= tb_nr_seq_mensalidade_seg_w(i);
	commit;
	
	forall i in tb_nr_seq_mensalidade_seg_w.first..tb_nr_seq_mensalidade_seg_w.last
		update	pls_conta_pos_estabelecido
		set	nr_seq_mensalidade_seg		 = NULL,
			nr_seq_regra_limite_mens	 = NULL,
			dt_atualizacao			= clock_timestamp(),
			nm_usuario			= nm_usuario_p
		where	nr_seq_mensalidade_seg		= tb_nr_seq_mensalidade_seg_w(i);
	commit;
	
	forall i in tb_nr_seq_mensalidade_seg_w.first..tb_nr_seq_mensalidade_seg_w.last
		update	pls_conta_co
		set	nr_seq_mensalidade_seg		 = NULL,
			nr_seq_regra_limite_mens	 = NULL,
			dt_atualizacao			= clock_timestamp(),
			nm_usuario			= nm_usuario_p
		where	nr_seq_mensalidade_seg		= tb_nr_seq_mensalidade_seg_w(i);
	commit;

	if (ie_atualizar_pagador_conta_w = 'S') then
		for i in tb_nr_seq_mensalidade_seg_w.first..tb_nr_seq_mensalidade_seg_w.last loop
			begin
			if	((tb_ie_existe_conta_w(i) = 'S') and (tb_qt_alt_pagador_w(i) > 1)) then
				CALL pls_alt_pagador_contas_benef(tb_nr_seq_segurado_mens_w(i), tb_nr_seq_pagador_w(i), null, null, null, 'S', nm_usuario_p);
			end if;
			end;
		end loop;
	end if;

	forall i in tb_nr_seq_mensalidade_seg_w.first..tb_nr_seq_mensalidade_seg_w.last
		update	pls_segurado_carteira
		set	nr_seq_mensalidade_seg	 = NULL
		where	nr_seq_mensalidade_seg	= tb_nr_seq_mensalidade_seg_w(i);
	commit;
	
	forall i in tb_nr_seq_mensalidade_seg_w.first..tb_nr_seq_mensalidade_seg_w.last
		update	pls_segurado_cart_ant
		set	nr_seq_mensalidade_seg	 = NULL
		where	nr_seq_mensalidade_seg	= tb_nr_seq_mensalidade_seg_w(i);
	commit;
	
	forall i in tb_nr_seq_mensalidade_seg_w.first..tb_nr_seq_mensalidade_seg_w.last
		delete	FROM pls_repasse_mens
		where	nr_seq_mens_seg	= tb_nr_seq_mensalidade_seg_w(i)
		and	coalesce(nr_seq_repasse::text, '') = '';
	commit;
	
	forall i in tb_nr_seq_mensalidade_seg_w.first..tb_nr_seq_mensalidade_seg_w.last
		update	pls_conta_val_atend
		set	nr_seq_mensalidade_seg  = NULL
		where	nr_seq_mensalidade_seg = tb_nr_seq_mensalidade_seg_w(i);
	commit;
	
	forall i in tb_nr_seq_mensalidade_seg_w.first..tb_nr_seq_mensalidade_seg_w.last
		delete from pls_mensalidade_segurado where nr_sequencia = tb_nr_seq_mensalidade_seg_w(i);
	commit;
end loop;
close C03;

open C04;
loop
	fetch C04 bulk collect into tb_nr_seq_mensalidade_w limit 1000;
	exit when tb_nr_seq_mensalidade_w.count = 0;
	
	forall i in tb_nr_seq_mensalidade_w.first..tb_nr_seq_mensalidade_w.last
		update	pls_lancamento_mensalidade
		set	nr_seq_mensalidade_item	 = NULL,
			nr_seq_mensalidade	 = NULL,
			dt_cobranca_mens	 = NULL
		where	nr_seq_mensalidade	= tb_nr_seq_mensalidade_w(i);
	commit;
	
	forall i in tb_nr_seq_mensalidade_w.first..tb_nr_seq_mensalidade_w.last
		update	pls_pagador_quitacao_anual
		set	nr_seq_mensalidade	 = NULL	
		where	nr_seq_mensalidade	= tb_nr_seq_mensalidade_w(i);
	commit;
	
	forall i in tb_nr_seq_mensalidade_w.first..tb_nr_seq_mensalidade_w.last
		update	pls_pagador_amortizacao
		set	nr_seq_mensalidade	 = NULL
		where	nr_seq_mensalidade	= tb_nr_seq_mensalidade_w(i);
	commit;
	
	forall i in tb_nr_seq_mensalidade_w.first..tb_nr_seq_mensalidade_w.last
		delete	FROM pls_mensalidade_historico
		where	nr_seq_mensalidade	= tb_nr_seq_mensalidade_w(i);
	commit;
	
	forall i in tb_nr_seq_mensalidade_w.first..tb_nr_seq_mensalidade_w.last
		delete	FROM pls_mensalidade_log
		where	nr_seq_mensalidade	= tb_nr_seq_mensalidade_w(i);
	commit;
	
	forall i in tb_nr_seq_mensalidade_w.first..tb_nr_seq_mensalidade_w.last
		delete	FROM pls_mensalidade_ato_coop
		where	nr_seq_mensalidade	= tb_nr_seq_mensalidade_w(i);
	commit;
	
	forall i in tb_nr_seq_mensalidade_w.first..tb_nr_seq_mensalidade_w.last
		delete	FROM pls_mensalidade_trib
		where	nr_seq_mensalidade	= tb_nr_seq_mensalidade_w(i);
	commit;
	
	for i in tb_nr_seq_mensalidade_w.first..tb_nr_seq_mensalidade_w.last loop
		for r_c05_w in C05(tb_nr_seq_mensalidade_w(i)) loop
			begin
			delete	from	nota_credito_baixa
			where	nr_sequencia	= r_c05_w.nr_sequencia;
			
			CALL atualizar_saldo_nota_credito(r_c05_w.nr_seq_nota_credito,nm_usuario_p);
			end;
		end loop;
	end loop;
	
	forall i in tb_nr_seq_mensalidade_w.first..tb_nr_seq_mensalidade_w.last
		delete from pls_mensalidade where nr_sequencia = tb_nr_seq_mensalidade_w(i);
	commit;
end loop;
close C04;

delete	FROM pls_mens_log_geracao
where	nr_seq_lote	= nr_seq_lote_p;

delete	FROM pls_mensalidade_log
where	nr_seq_lote	= nr_seq_lote_p;

select	max(ie_antecipacao_geracao)
into STRICT	ie_antecipacao_geracao_w
from	pls_parametro_contabil
where	cd_estabelecimento	= cd_estabelecimento_p;
ie_antecipacao_geracao_w	:= coalesce(ie_antecipacao_geracao_w,'N');

ie_limpar_dt_contabilizacao_w	:= 'N';
if (ie_antecipacao_geracao_w = 'S') and (trunc(dt_geracao_lote_w,'dd') = trunc(dt_contabilizacao_lote_w,'dd')) then
	ie_limpar_dt_contabilizacao_w	:= 'S';
end if;

update	pls_lote_mensalidade
set	ie_status		= '1',
	dt_geracao		 = NULL,
	dt_liberacao		 = NULL,
	vl_lote			= 0,
	vl_coparticipacao	= 0,
	vl_pos_estabelecido	= 0,
	vl_pre_estabelecido	= 0,
	vl_outros		= 0,
	vl_adicionais		= 0,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp(),
	dt_rescisao_programada	 = NULL,
	vl_pro_rata_dia		= 0,
	vl_antecipacao		= 0,
	qt_pagadores_lote	= 0,
	qt_beneficiario_lote	= 0,
	dt_contabilizacao	= CASE WHEN ie_limpar_dt_contabilizacao_w='S' THEN null  ELSE dt_contabilizacao END ,
	ie_mensalidade_mes_anterior = 'N',
	dt_inicio_geracao	 = NULL,
	dt_fim_geracao		 = NULL,
	nm_usuario_geracao	 = NULL
where	nr_sequencia		= nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_lote_mensalidade ( nr_seq_lote_p pls_lote_mensalidade.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

