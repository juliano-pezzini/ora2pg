-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_programacao_reajuste_pck.inserir_contratos () AS $body$
DECLARE


tx_reajuste_copartic_w		pls_prog_reaj_colet_lote.tx_reajuste_copartic%type;
tx_reajuste_copartic_max_w	pls_prog_reaj_colet_lote.tx_reajuste_copartic_max%type;
tx_reajuste_inscricao_w		pls_prog_reaj_colet_lote.tx_reajuste_inscricao%type;
tx_reajuste_via_cart_w		pls_prog_reaj_colet_lote.tx_reajuste_via_cart%type;
ie_reajustar_copartic_w		pls_prog_reaj_colet_lote.ie_reajustar_copartic%type;
ie_reajustar_inscricao_w	pls_prog_reaj_colet_lote.ie_reajustar_inscricao%type;
ie_reajustar_vl_manutencao_w	pls_prog_reaj_colet_lote.ie_reajustar_vl_manutencao%type;
ie_reajustar_via_adic_w		pls_prog_reaj_colet_lote.ie_reajustar_via_adic%type;

sql_base_w			varchar(32000) := null;
sql_w				varchar(32000) := null;
valor_bind_w			sql_pck.t_dado_bind;
cursor_w			sql_pck.t_cursor;

tb_nr_seq_contrato_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_indice_reajuste_w	pls_util_cta_pck.t_number_table;


BEGIN

select	tx_reajuste_copartic,
	tx_reajuste_copartic_max,
	tx_reajuste_inscricao,
	tx_reajuste_via_cart,
	ie_reajustar_copartic,
	ie_reajustar_inscricao,
	ie_reajustar_vl_manutencao,
	ie_reajustar_via_adic
into STRICT	tx_reajuste_copartic_w,
	tx_reajuste_copartic_max_w,
	tx_reajuste_inscricao_w,
	tx_reajuste_via_cart_w,
	ie_reajustar_copartic_w,
	ie_reajustar_inscricao_w,
	ie_reajustar_vl_manutencao_w,
	ie_reajustar_via_adic_w
from	pls_prog_reaj_colet_lote
where	nr_sequencia = nr_seq_lote_p;

if (current_setting('pls_programacao_reajuste_pck.pls_programacao_lote_w')::pls_prog_reaj_colet_lote%(rowtype.nr_seq_indice_reajuste IS NOT NULL AND rowtype.nr_seq_indice_reajuste::text <> '')) then
	sql_base_w	:= sql_base_w || ' and a.nr_seq_indice_reajuste = :nr_seq_indice_reajuste_pc ';
	valor_bind_w := sql_pck.bind_variable(':nr_seq_indice_reajuste_pc', current_setting('pls_programacao_reajuste_pck.pls_programacao_lote_w')::pls_prog_reaj_colet_lote%rowtype.nr_seq_indice_reajuste, valor_bind_w);
end if;

if (current_setting('pls_programacao_reajuste_pck.pls_programacao_lote_w')::pls_prog_reaj_colet_lote%rowtype.ie_tipo_contratacao <> 'T') or (current_setting('pls_programacao_reajuste_pck.pls_programacao_lote_w')::pls_prog_reaj_colet_lote%(rowtype.ie_regulamentacao IS NOT NULL AND rowtype.ie_regulamentacao::text <> '')) or (current_setting('pls_programacao_reajuste_pck.pls_programacao_lote_w')::pls_prog_reaj_colet_lote%(rowtype.ie_preco IS NOT NULL AND rowtype.ie_preco::text <> '')) then
	sql_base_w	:= sql_base_w || ' and exists (	select	1
							from	pls_contrato_plano x,
								pls_plano y
							where	y.nr_sequencia = x.nr_seq_plano
							and	x.nr_seq_contrato = a.nr_sequencia ';
	if (current_setting('pls_programacao_reajuste_pck.pls_programacao_lote_w')::pls_prog_reaj_colet_lote%rowtype.ie_tipo_contratacao <> 'T') then
		sql_base_w	:= sql_base_w || '	and	y.ie_tipo_contratacao = :ie_tipo_contratacao_pc ';
		valor_bind_w := sql_pck.bind_variable(':ie_tipo_contratacao_pc', current_setting('pls_programacao_reajuste_pck.pls_programacao_lote_w')::pls_prog_reaj_colet_lote%rowtype.ie_tipo_contratacao, valor_bind_w);
	end if;
	if (current_setting('pls_programacao_reajuste_pck.pls_programacao_lote_w')::pls_prog_reaj_colet_lote%(rowtype.ie_regulamentacao IS NOT NULL AND rowtype.ie_regulamentacao::text <> '')) then
		sql_base_w	:= sql_base_w || '	and	y.ie_regulamentacao = :ie_regulamentacao_pc ';
		valor_bind_w := sql_pck.bind_variable(':ie_regulamentacao_pc', current_setting('pls_programacao_reajuste_pck.pls_programacao_lote_w')::pls_prog_reaj_colet_lote%rowtype.ie_regulamentacao, valor_bind_w);
	end if;
	if (current_setting('pls_programacao_reajuste_pck.pls_programacao_lote_w')::pls_prog_reaj_colet_lote%(rowtype.ie_preco IS NOT NULL AND rowtype.ie_preco::text <> '')) then
		sql_base_w	:= sql_base_w || '	and	y.ie_preco = :ie_preco_pc ';
		valor_bind_w := sql_pck.bind_variable(':ie_preco_pc', current_setting('pls_programacao_reajuste_pck.pls_programacao_lote_w')::pls_prog_reaj_colet_lote%rowtype.ie_preco, valor_bind_w);
	end if;
	sql_base_w	:=	sql_base_w || ')';
end if;

sql_w := '	select	a.nr_sequencia nr_seq_contrato,
			a.nr_seq_indice_reajuste
		from	pls_contrato a
		where	a.cd_cgc_estipulante is not null
		and	a.cd_estabelecimento	= :cd_estabelecimento_pc
		and	a.ie_situacao		= ''2''
		and	a.dt_contrato < :dt_programacao_pc
		and	a.nr_mes_reajuste = :nr_mes_reajuste_pc
		and	not exists (	select	1
					from	pls_contrato_grupo x,
						pls_grupo_contrato y
					where	y.nr_sequencia	= x.nr_seq_grupo
					and	x.nr_seq_contrato = a.nr_sequencia
					and	y.ie_tipo_relacionamento = ''4''
					and	:dt_programacao_pc between y.dt_inicio_vigencia and y.dt_fim_vigencia) 
		and	not exists (	select	1
					from	pls_grupo_contrato x
					where	x.nr_sequencia = a.nr_seq_grupo_reajuste
					and	x.dt_primeiro_reajuste > :dt_programacao_pc) ' ||
		sql_base_w || ' union ' ||
	'	select	a.nr_sequencia nr_seq_contrato,
			a.nr_seq_indice_reajuste
		from	pls_contrato a
		where	a.cd_pf_estipulante is not null
		and	a.ie_empresario_individual = ''S''
		and	a.cd_estabelecimento	= :cd_estabelecimento_pc
		and	a.ie_situacao		= ''2''
		and	a.dt_contrato < :dt_programacao_pc
		and	a.nr_mes_reajuste = :nr_mes_reajuste_pc
		and	not exists (	select	1
					from	pls_contrato_grupo x,
						pls_grupo_contrato y
					where	y.nr_sequencia	= x.nr_seq_grupo
					and	x.nr_seq_contrato = a.nr_sequencia
					and	y.ie_tipo_relacionamento = ''4''
					and	:dt_programacao_pc between y.dt_inicio_vigencia and y.dt_fim_vigencia) 
		and	not exists (	select	1
					from	pls_grupo_contrato x
					where	x.nr_sequencia = a.nr_seq_grupo_reajuste
					and	x.dt_primeiro_reajuste > :dt_programacao_pc) ' || sql_base_w;

valor_bind_w := sql_pck.bind_variable(':cd_estabelecimento_pc', cd_estabelecimento_p, valor_bind_w);
valor_bind_w := sql_pck.bind_variable(':dt_programacao_pc', current_setting('pls_programacao_reajuste_pck.pls_programacao_lote_w')::pls_prog_reaj_colet_lote%rowtype.dt_mes_reajuste, valor_bind_w);
valor_bind_w := sql_pck.bind_variable(':nr_mes_reajuste_pc', (to_char(current_setting('pls_programacao_reajuste_pck.pls_programacao_lote_w')::pls_prog_reaj_colet_lote%rowtype.dt_mes_reajuste,'mm'))::numeric , valor_bind_w);
					
valor_bind_w := sql_pck.executa_sql_cursor(sql_w, valor_bind_w);

loop
	fetch cursor_w bulk collect into tb_nr_seq_contrato_w, tb_nr_seq_indice_reajuste_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_contrato_w.count = 0;
	
	forall i in tb_nr_seq_contrato_w.first .. tb_nr_seq_contrato_w.last
		insert	into	pls_prog_reaj_coletivo(	nr_sequencia,
				nr_seq_lote,
				nr_seq_contrato,
				nr_seq_indice_reajuste,
				nm_usuario_nrec,
				nm_usuario,
				dt_atualizacao_nrec,
				dt_atualizacao,
				ie_reajustar_copartic,
				ie_reajustar_tx_inscricao,
				ie_reajustar_via_cart,
				ie_reajustar_vl_manutencao,
				tx_reajuste_copartic,
				tx_reajuste_copartic_max,
				tx_reajuste_inscricao,
				tx_reajuste_via_cart)
			values (nextval('pls_prog_reaj_coletivo_seq'),
				current_setting('pls_programacao_reajuste_pck.pls_programacao_lote_w')::pls_prog_reaj_colet_lote%rowtype.nr_sequencia,
				tb_nr_seq_contrato_w(i),
				tb_nr_seq_indice_reajuste_w(i),
				nm_usuario_p,
				nm_usuario_p,
				clock_timestamp(),
				clock_timestamp(),
				ie_reajustar_copartic_w,
				ie_reajustar_inscricao_w,
				ie_reajustar_via_adic_w,
				ie_reajustar_vl_manutencao_w,
				tx_reajuste_copartic_w,
				tx_reajuste_copartic_max_w,
				tx_reajuste_inscricao_w,
				tx_reajuste_via_cart_w);
	commit;
end loop;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_programacao_reajuste_pck.inserir_contratos () FROM PUBLIC;