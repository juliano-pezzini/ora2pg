-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



---------------- INSERE TODOS OS DADOS EM UMA TABELA TEMPORARIA.
CREATE OR REPLACE PROCEDURE pls_mov_mens_pck.gerar_dados_temp () AS $body$
DECLARE


ds_sql_w			varchar(32000);

tb_nr_seq_congenere_w	pls_util_cta_pck.t_number_table;
tb_nr_mensalidade_seg_w	pls_util_cta_pck.t_number_table;

valor_bind_w			sql_pck.t_dado_bind;
cursor_w			sql_pck.t_cursor;


BEGIN

ds_sql_w := '	select	a.nr_seq_congenere,
			c.nr_sequencia nr_seq_mensalidade_seg
		from	pls_segurado_repasse a,
			pls_segurado b,
			pls_mensalidade_segurado c,
			pls_mensalidade d,
			pls_lote_mensalidade e,
			pls_segurado_carteira f
		where	b.nr_sequencia	= a.nr_seq_segurado
		and	b.nr_sequencia	= c.nr_seq_segurado
		and	d.nr_sequencia	= c.nr_seq_mensalidade
		and	e.nr_sequencia	= d.nr_seq_lote
		and	b.nr_sequencia  = f.nr_seq_segurado
		and	a.cd_estabelecimento	= :CD_ESTABELECIMENTO
		and	a.dt_liberacao is not null
		and	f.cd_usuario_plano is not null
		and	a.ie_tipo_repasse = ''P''
		and	d.ie_cancelamento is null
		and	:DT_INICIAL between a.dt_repasse and nvl(a.dt_fim_repasse,:DT_INICIAL)
		and	d.dt_referencia between :DT_INICIAL and :DT_FINAL ';
		
if (current_setting('pls_mov_mens_pck.pls_mov_mens_regra_w')::pls_mov_mens_regra%(rowtype.nr_seq_congenere IS NOT NULL AND rowtype.nr_seq_congenere::text <> '')) then
	ds_sql_w := ds_sql_w || '	and a.nr_seq_congenere	= :NR_SEQ_CONGENERE ';
	valor_bind_w := sql_pck.bind_variable(':NR_SEQ_CONGENERE', current_setting('pls_mov_mens_pck.pls_mov_mens_regra_w')::pls_mov_mens_regra%rowtype.nr_seq_congenere, valor_bind_w);
end if;

valor_bind_w := sql_pck.bind_variable(':DT_INICIAL', current_setting('pls_mov_mens_pck.pls_mov_mens_lote_w')::pls_mov_mens_lote%rowtype.dt_movimento_inicial, valor_bind_w);
valor_bind_w := sql_pck.bind_variable(':DT_FINAL', current_setting('pls_mov_mens_pck.pls_mov_mens_lote_w')::pls_mov_mens_lote%rowtype.dt_movimento_final, valor_bind_w);
valor_bind_w := sql_pck.bind_variable(':CD_ESTABELECIMENTO', current_setting('pls_mov_mens_pck.pls_mov_mens_regra_w')::pls_mov_mens_regra%rowtype.cd_estabelecimento, valor_bind_w);

valor_bind_w := sql_pck.executa_sql_cursor(ds_sql_w, valor_bind_w);

loop
	fetch cursor_w bulk collect into tb_nr_seq_congenere_w, tb_nr_mensalidade_seg_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_mensalidade_seg_w.count = 0;
	
	forall i in tb_nr_mensalidade_seg_w.first .. tb_nr_mensalidade_seg_w.last
	
		insert	into	pls_mov_mens_temp(	nr_seq_congenere,
				nr_seq_mensalidade_seg)
			values (tb_nr_seq_congenere_w(i),
				tb_nr_mensalidade_seg_w(i) );
	commit;
end loop;

close cursor_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mov_mens_pck.gerar_dados_temp () FROM PUBLIC;