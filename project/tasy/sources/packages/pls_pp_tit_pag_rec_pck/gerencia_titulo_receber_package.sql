-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_tit_pag_rec_pck.gerencia_titulo_receber ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

					
_ora2pg_r RECORD;
ie_regra_valida_w		varchar(1);
nr_contador_w			integer;

ds_restricao_regra_w 		varchar(32000);
ds_restricao_regra_externa_w	varchar(32000);
ds_select_w			varchar(32000);
valor_bind_w			sql_pck.t_dado_bind;
cursor_w			sql_pck.t_cursor;
ds_alias_tit_rec_w		varchar(60);
ds_alias_tit_rec_filtr_w	varchar(60);
ds_alias_pp_item_lote_w		varchar(60);
ds_alias_lote_prest_event_w	varchar(60);

nr_titulo_w			titulo_pagar.nr_titulo%type;
vl_saldo_titulo_w		titulo_pagar.vl_saldo_titulo%type;
cd_pessoa_fisica_w		titulo_pagar.cd_pessoa_fisica%type;
cd_cgc_w			titulo_pagar.cd_cgc%type;
qt_tit_rec_w			integer;
nr_seq_prestador_w		pls_prestador.nr_sequencia%type;

tb_nr_titulo_receber_w		pls_util_cta_pck.t_number_table;
tb_vl_saldo_titulo_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_evento_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_regra_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_prestador_w		pls_util_cta_pck.t_number_table;
tb_cd_centro_custo_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_lote_w		pls_util_cta_pck.t_number_table;
tb_nm_usuario			pls_util_cta_pck.t_varchar2_table_15;
tb_cd_estabelecimento_w		pls_util_cta_pck.t_number_table;

c_regra CURSOR( nr_seq_lote_pc		pls_pp_lote.nr_sequencia%type ) FOR
	SELECT 	b.nr_sequencia nr_seq_regra,
		b.nr_seq_evento,
		b.nr_ordem_execucao,
		b.dt_inicio_vigencia_ref,
		b.dt_fim_vigencia_ref,
		b.ie_tipo_pessoa,
		b.cd_pessoa_fisica,
		b.cd_cgc,
		b.nr_seq_trans_fin_contab,
		b.ie_tipo_titulo,
		b.ie_origem_titulo,
		b.nr_seq_classe_tit_rec,
		b.nr_seq_prestador_dest,
		b.cd_centro_custo,
		b.nr_seq_pagador
	from	pls_evento_regra_tit_rec b,
		pls_evento a
	where	a.nr_sequencia = b.nr_seq_evento
	and	a.ie_situacao = 'A'
	order by nr_ordem_execucao desc,
		nr_seq_evento,
		nr_seq_regra;
		
BEGIN

-- obtém alguns dados do lote
CALL pls_pp_lote_pagamento_pck.carrega_parametros(nr_seq_lote_p, cd_estabelecimento_p);

ds_alias_tit_rec_w := pls_pp_tit_pag_rec_pck.obter_alias_tabela('titulo_receber');
ds_alias_tit_rec_filtr_w := pls_pp_tit_pag_rec_pck.obter_alias_tabela('titulo_receber_filtr');
ds_alias_pp_item_lote_w := pls_pp_tit_pag_rec_pck.obter_alias_tabela('pls_pp_item_lote');
ds_alias_lote_prest_event_w := pls_pp_tit_pag_rec_pck.obter_alias_tabela('pls_pp_lote_prest_event');

-- abre o cursor com as regras de título a receber
for r_c_regra_w in c_regra( nr_seq_lote_p ) loop

	-- inicia a regra como não válida antes de verifica-la
	ie_regra_valida_w := 'N';
	
	-- se a data de início estiver entre o período do lote é válida
	if (r_c_regra_w.dt_inicio_vigencia_ref between pls_pp_lote_pagamento_pck.dt_referencia_lote_ini_w and pls_pp_lote_pagamento_pck.dt_referencia_lote_fim_w)  then
		ie_regra_valida_w := 'S';
		
	-- se a data de fim estiver entre o período do lote é válida
	elsif (r_c_regra_w.dt_fim_vigencia_ref between pls_pp_lote_pagamento_pck.dt_referencia_lote_ini_w and pls_pp_lote_pagamento_pck.dt_referencia_lote_fim_w) then
		ie_regra_valida_w := 'S';
		
	-- se a data inicio for menor que a data inicial do lote e a data fim for maior que a data de fim do lote
	elsif (r_c_regra_w.dt_inicio_vigencia_ref <= pls_pp_lote_pagamento_pck.dt_referencia_lote_ini_w) and (r_c_regra_w.dt_fim_vigencia_ref >= pls_pp_lote_pagamento_pck.dt_referencia_lote_fim_w) then
		ie_regra_valida_w := 'S';
	end if;
	
	-- se a vigência da regra for válida para o lote
	if (ie_regra_valida_w = 'S') then
		-- inicia a variável com null
		ds_restricao_regra_w := null;
		ds_select_w := null;
		
		-- obtém as restrições da regra do prestador e também valida algumas exceções
		valor_bind_w := pls_pp_tit_pag_rec_pck.obter_restr_titulo_receber(
				pls_pp_lote_pagamento_pck.dt_referencia_lote_ini_w, pls_pp_lote_pagamento_pck.dt_referencia_lote_fim_w, r_c_regra_w.ie_tipo_pessoa, r_c_regra_w.cd_pessoa_fisica, r_c_regra_w.cd_cgc, r_c_regra_w.nr_seq_trans_fin_contab, r_c_regra_w.ie_tipo_titulo, r_c_regra_w.ie_origem_titulo, r_c_regra_w.nr_seq_classe_tit_rec, r_c_regra_w.nr_seq_pagador, cd_estabelecimento_p, valor_bind_w);
				
		ds_select_w := 	'select	' || ds_alias_tit_rec_filtr_w || '.nr_titulo,' || pls_util_pck.enter_w ||
				'	' || ds_alias_tit_rec_filtr_w || '.vl_saldo_titulo,' || pls_util_pck.enter_w ||
				'	' || ds_alias_tit_rec_filtr_w || '.cd_pessoa_fisica,' || pls_util_pck.enter_w ||
				'	' || ds_alias_tit_rec_filtr_w || '.cd_cgc,' || pls_util_pck.enter_w ||
				'	' || ds_alias_tit_rec_filtr_w || '.qt_tit_rec,' || pls_util_pck.enter_w ||
				'	z.nr_seq_prestador_pgto' || pls_util_pck.enter_w ||
				'from	(select	' || ds_alias_tit_rec_w || '.nr_titulo, ' || pls_util_pck.enter_w ||
				'		' || ds_alias_tit_rec_w || '.vl_saldo_titulo, ' || pls_util_pck.enter_w ||
				'		' || ds_alias_tit_rec_w || '.cd_pessoa_fisica, ' || pls_util_pck.enter_w ||
				'		' || ds_alias_tit_rec_w || '.cd_cgc, ' || pls_util_pck.enter_w ||
				'		(select	count(1) ' || pls_util_pck.enter_w ||
				'		from	pls_pp_item_lote ' || ds_alias_pp_item_lote_w || pls_util_pck.enter_w ||
				'		where	' || ds_alias_pp_item_lote_w || '.nr_titulo_receber = ' || ds_alias_tit_rec_w || '.nr_titulo) qt_tit_rec,' || pls_util_pck.enter_w ||
				'		pls_pp_tit_pag_rec_pck.obter_prestador_tmp_pf_pj(:nr_seq_prestador_dest_pc, ' || ds_alias_tit_rec_w || '.cd_pessoa_fisica, ' || ds_alias_tit_rec_w || '.cd_cgc) nr_seq_prestador' || pls_util_pck.enter_w ||
				'	from	titulo_receber ' || ds_alias_tit_rec_w || pls_util_pck.enter_w ||
				'	where	1 = 1 ' || pls_util_pck.enter_w ||
					ds_restricao_regra_w || ') ' || ds_alias_tit_rec_filtr_w || ',' || pls_util_pck.enter_w ||
				'	pls_pp_prestador_tmp z' || pls_util_pck.enter_w ||
				'where z.nr_seq_prestador = ' || ds_alias_tit_rec_filtr_w || '.nr_seq_prestador' || pls_util_pck.enter_w ||
				'  and exists(	select	1 ' || pls_util_pck.enter_w ||
				'		from	pls_pp_lote_prest_event ' || ds_alias_lote_prest_event_w || pls_util_pck.enter_w ||
				'		where	' || ds_alias_lote_prest_event_w || '.nr_seq_lote = :nr_seq_lote_pc ' || pls_util_pck.enter_w ||
				'		and	' || ds_alias_lote_prest_event_w || '.nr_seq_evento = :nr_seq_evento_pc ' || pls_util_pck.enter_w ||
				'		and	' || ds_alias_lote_prest_event_w || '.nr_seq_prestador = z.nr_seq_prestador_pgto)';
				valor_bind_w := sql_pck.bind_variable(':nr_seq_prestador_dest_pc', r_c_regra_w.nr_seq_prestador_dest, valor_bind_w);
				valor_bind_w := sql_pck.bind_variable(':nr_seq_lote_pc', nr_seq_lote_p, valor_bind_w);
				valor_bind_w := sql_pck.bind_variable(':nr_seq_evento_pc', r_c_regra_w.nr_seq_evento, valor_bind_w);
		
		-- executa o comando sql com os respectivos binds
		valor_bind_w := sql_pck.executa_sql_cursor(ds_select_w, valor_bind_w);
		
		-- chama para inicializar as variáveis
		SELECT * FROM pls_pp_tit_pag_rec_pck.insere_titulo_receber_item(	nr_contador_w, tb_nr_titulo_receber_w, tb_vl_saldo_titulo_w, tb_nr_seq_evento_w, tb_nr_seq_regra_w, tb_nr_seq_prestador_w, tb_cd_centro_custo_w, tb_nr_seq_lote_w, tb_nm_usuario, tb_cd_estabelecimento_w) INTO STRICT _ora2pg_r;
 	nr_contador_w := _ora2pg_r.nr_contador_p; tb_nr_titulo_receber_w := _ora2pg_r.tb_nr_titulo_receber_p; tb_vl_saldo_titulo_w := _ora2pg_r.tb_vl_saldo_titulo_p; tb_nr_seq_evento_w := _ora2pg_r.tb_nr_seq_evento_p; tb_nr_seq_regra_w := _ora2pg_r.tb_nr_seq_regra_p; tb_nr_seq_prestador_w := _ora2pg_r.tb_nr_seq_prestador_p; tb_cd_centro_custo_w := _ora2pg_r.tb_cd_centro_custo_p; tb_nr_seq_lote_w := _ora2pg_r.tb_nr_seq_lote_p; tb_nm_usuario := _ora2pg_r.tb_nm_usuario_p; tb_cd_estabelecimento_w := _ora2pg_r.tb_cd_estabelecimento_p;
		
		loop
			fetch cursor_w into nr_titulo_w, vl_saldo_titulo_w, cd_pessoa_fisica_w, cd_cgc_w, qt_tit_rec_w, nr_seq_prestador_w;
			EXIT WHEN NOT FOUND; /* apply on cursor_w */
			
			-- Se o título a receber não está na tabela pls_pp_item_lote então dá continuidade no processo, senão, ignora o título
			if (qt_tit_rec_w = 0) then
				-- armazena em tables para enviar ao banco a cada 'X' registros
				tb_nr_titulo_receber_w(nr_contador_w) := nr_titulo_w;
				tb_vl_saldo_titulo_w(nr_contador_w) := vl_saldo_titulo_w;
				tb_nr_seq_evento_w(nr_contador_w) := r_c_regra_w.nr_seq_evento;
				tb_nr_seq_regra_w(nr_contador_w) := r_c_regra_w.nr_seq_regra;
				tb_nr_seq_prestador_w(nr_contador_w) := nr_seq_prestador_w;
				tb_cd_centro_custo_w(nr_contador_w) := r_c_regra_w.cd_centro_custo;
				tb_nr_seq_lote_w(nr_contador_w) := nr_seq_lote_p;
				tb_nm_usuario(nr_contador_w) := nm_usuario_p;
				tb_cd_estabelecimento_w(nr_contador_w) := cd_estabelecimento_p;
				
				-- se atingiu a quantidade manda para o banco
				if (nr_contador_w >= pls_util_pck.qt_registro_transacao_w) then

					SELECT * FROM pls_pp_tit_pag_rec_pck.insere_titulo_receber_item(	nr_contador_w, tb_nr_titulo_receber_w, tb_vl_saldo_titulo_w, tb_nr_seq_evento_w, tb_nr_seq_regra_w, tb_nr_seq_prestador_w, tb_cd_centro_custo_w, tb_nr_seq_lote_w, tb_nm_usuario, tb_cd_estabelecimento_w) INTO STRICT _ora2pg_r;
 	nr_contador_w := _ora2pg_r.nr_contador_p; tb_nr_titulo_receber_w := _ora2pg_r.tb_nr_titulo_receber_p; tb_vl_saldo_titulo_w := _ora2pg_r.tb_vl_saldo_titulo_p; tb_nr_seq_evento_w := _ora2pg_r.tb_nr_seq_evento_p; tb_nr_seq_regra_w := _ora2pg_r.tb_nr_seq_regra_p; tb_nr_seq_prestador_w := _ora2pg_r.tb_nr_seq_prestador_p; tb_cd_centro_custo_w := _ora2pg_r.tb_cd_centro_custo_p; tb_nr_seq_lote_w := _ora2pg_r.tb_nr_seq_lote_p; tb_nm_usuario := _ora2pg_r.tb_nm_usuario_p; tb_cd_estabelecimento_w := _ora2pg_r.tb_cd_estabelecimento_p;
				else
					nr_contador_w := nr_contador_w + 1;
				end if;
			end if;
		end loop;
		close cursor_w;

		-- insere os itens restantes que no caso totalizam menos que o 'pls_util_pck.qt_registro_transacao_w'
		SELECT * FROM pls_pp_tit_pag_rec_pck.insere_titulo_receber_item(	nr_contador_w, tb_nr_titulo_receber_w, tb_vl_saldo_titulo_w, tb_nr_seq_evento_w, tb_nr_seq_regra_w, tb_nr_seq_prestador_w, tb_cd_centro_custo_w, tb_nr_seq_lote_w, tb_nm_usuario, tb_cd_estabelecimento_w) INTO STRICT _ora2pg_r;
 	nr_contador_w := _ora2pg_r.nr_contador_p; tb_nr_titulo_receber_w := _ora2pg_r.tb_nr_titulo_receber_p; tb_vl_saldo_titulo_w := _ora2pg_r.tb_vl_saldo_titulo_p; tb_nr_seq_evento_w := _ora2pg_r.tb_nr_seq_evento_p; tb_nr_seq_regra_w := _ora2pg_r.tb_nr_seq_regra_p; tb_nr_seq_prestador_w := _ora2pg_r.tb_nr_seq_prestador_p; tb_cd_centro_custo_w := _ora2pg_r.tb_cd_centro_custo_p; tb_nr_seq_lote_w := _ora2pg_r.tb_nr_seq_lote_p; tb_nm_usuario := _ora2pg_r.tb_nm_usuario_p; tb_cd_estabelecimento_w := _ora2pg_r.tb_cd_estabelecimento_p;
	end if;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_tit_pag_rec_pck.gerencia_titulo_receber ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
