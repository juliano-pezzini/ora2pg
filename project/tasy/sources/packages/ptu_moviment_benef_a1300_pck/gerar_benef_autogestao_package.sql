-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


CREATE TYPE ptu_mov_benef_autogestao AS (	nr_seq_segurado		dbms_sql.number_table,
							cd_unimed		dbms_sql.varchar2_table,
							cd_usuario_plano	dbms_sql.varchar2_table,
							nm_beneficiario		dbms_sql.varchar2_table,
							dt_nascimento		dbms_sql.date_table,
							ie_sexo			dbms_sql.varchar2_table,
							nr_cartao_nac_sus	dbms_sql.varchar2_table,
							nr_cpf			dbms_sql.varchar2_table,
							dt_contratacao		dbms_sql.date_table,
							dt_rescisao		dbms_sql.date_table,
							cd_cgc			dbms_sql.varchar2_table,
							cd_ans			dbms_sql.varchar2_table,
							ie_tipo_movimentacao	dbms_sql.varchar2_table);


CREATE OR REPLACE PROCEDURE ptu_moviment_benef_a1300_pck.gerar_benef_autogestao ( nr_seq_lote_p ptu_mov_benef_lote.nr_sequencia%type, ie_tipo_movimentacao_p ptu_mov_benef_lote.ie_tipo_movimentacao%type, dt_inicio_p timestamp, dt_fim_p timestamp) AS $body$
DECLARE

			
	ptu_mov_autogestao_w	ptu_mov_benef_autogestao;
	qt_benef_excluido_w	integer;
	index_w			integer := 1;
	
	C01 CURSOR FOR
		SELECT	a.nr_sequencia nr_seq_segurado,
			d.cd_usuario_plano,
			e.nm_pessoa_fisica,
			e.dt_nascimento,
			e.ie_sexo,
			e.nr_cartao_nac_sus,
			e.nr_cpf,
			a.dt_contratacao,
			a.dt_rescisao,
			c.cd_cgc,
			c.cd_ans,
			'A' ie_tipo_movimentacao
		from	pls_segurado	a,
			pls_intercambio	b,
			pls_congenere	c,
			pls_segurado_carteira d,
			pessoa_fisica	e
		where	b.nr_sequencia	= a.nr_seq_intercambio
		and	c.nr_sequencia	= b.nr_seq_oper_congenere
		and	a.nr_sequencia	= d.nr_seq_segurado
		and	e.cd_pessoa_fisica	= a.cd_pessoa_fisica
		and	c.ie_tipo_outorgante	= '2'
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and	coalesce(a.dt_cancelamento::text, '') = ''
		and	b.cd_estabelecimento = get_cd_estabelecimento
		and	a.dt_contratacao <= dt_fim_p
		and	ie_tipo_movimentacao_p = 'M' --Cadastro completo

		
union all

		SELECT	a.nr_sequencia nr_seq_segurado,
			d.cd_usuario_plano,
			e.nm_pessoa_fisica,
			e.dt_nascimento,
			e.ie_sexo,
			e.nr_cartao_nac_sus,
			e.nr_cpf,
			a.dt_contratacao,
			a.dt_rescisao,
			c.cd_cgc,
			c.cd_ans,
			'A' ie_tipo_movimentacao
		from	pls_segurado	a,
			pls_intercambio	b,
			pls_congenere	c,
			pls_segurado_carteira d,
			pessoa_fisica	e
		where	b.nr_sequencia	= a.nr_seq_intercambio
		and	c.nr_sequencia	= b.nr_seq_oper_congenere
		and	a.nr_sequencia	= d.nr_seq_segurado
		and	e.cd_pessoa_fisica	= a.cd_pessoa_fisica
		and	c.ie_tipo_outorgante	= '2'
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and	coalesce(a.dt_cancelamento::text, '') = ''
		and	b.cd_estabelecimento = get_cd_estabelecimento
		and	a.dt_contratacao <= dt_fim_p
		and (coalesce(a.dt_rescisao::text, '') = '' or a.dt_rescisao > dt_fim_p)
		and	ie_tipo_movimentacao_p = 'A' --Cadastro ativo

		
union all

		select	a.nr_sequencia nr_seq_segurado,
			d.cd_usuario_plano,
			e.nm_pessoa_fisica,
			e.dt_nascimento,
			e.ie_sexo,
			e.nr_cartao_nac_sus,
			e.nr_cpf,
			a.dt_contratacao,
			a.dt_rescisao,
			c.cd_cgc,
			c.cd_ans,
			'I' ie_tipo_movimentacao
		from	pls_segurado	a,
			pls_intercambio	b,
			pls_congenere	c,
			pls_segurado_carteira d,
			pessoa_fisica	e
		where	b.nr_sequencia	= a.nr_seq_intercambio
		and	c.nr_sequencia	= b.nr_seq_oper_congenere
		and	a.nr_sequencia	= d.nr_seq_segurado
		and	e.cd_pessoa_fisica	= a.cd_pessoa_fisica
		and	c.ie_tipo_outorgante	= '2'
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and	coalesce(a.dt_cancelamento::text, '') = ''
		and	b.cd_estabelecimento = get_cd_estabelecimento
		and	a.dt_contratacao between dt_inicio_p and dt_fim_p
		and	ie_tipo_movimentacao_p = 'P' --Movimentacao periodica - Inclusao

		
union all

		select	a.nr_sequencia nr_seq_segurado,
			d.cd_usuario_plano,
			e.nm_pessoa_fisica,
			e.dt_nascimento,
			e.ie_sexo,
			e.nr_cartao_nac_sus,
			e.nr_cpf,
			a.dt_contratacao,
			a.dt_rescisao,
			c.cd_cgc,
			c.cd_ans,
			'E' ie_tipo_movimentacao
		from	pls_segurado	a,
			pls_intercambio	b,
			pls_congenere	c,
			pls_segurado_carteira d,
			pessoa_fisica	e
		where	b.nr_sequencia	= a.nr_seq_intercambio
		and	c.nr_sequencia	= b.nr_seq_oper_congenere
		and	a.nr_sequencia	= d.nr_seq_segurado
		and	e.cd_pessoa_fisica	= a.cd_pessoa_fisica
		and	c.ie_tipo_outorgante	= '2'
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and	coalesce(a.dt_cancelamento::text, '') = ''
		and	b.cd_estabelecimento = get_cd_estabelecimento
		and	a.dt_rescisao between dt_inicio_p and dt_fim_p
		and	ie_tipo_movimentacao_p = 'P' --Movimentacao periodica - Rescisao

		
union all

		select	a.nr_sequencia nr_seq_segurado,
			d.cd_usuario_plano,
			f.nm_pessoa_fisica,
			f.dt_nascimento,
			f.ie_sexo,
			f.nr_cartao_nac_sus,
			f.nr_cpf,
			a.dt_contratacao,
			a.dt_rescisao,
			e.cd_cgc,
			e.cd_ans,
			'A' ie_tipo_movimentacao
		from	pls_segurado 		a,
			pls_intercambio		b,
			pls_segurado_carteira	d,
			pls_congenere		e,
			pessoa_fisica		f
		where	b.nr_sequencia		= a.nr_seq_intercambio
		and	a.nr_sequencia		= d.nr_seq_segurado
		and	e.nr_sequencia		= b.nr_seq_oper_congenere
		and	f.cd_pessoa_fisica	= a.cd_pessoa_fisica
		and	e.ie_tipo_outorgante	= '2'
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and	coalesce(a.dt_cancelamento::text, '') = ''
		and	((coalesce(a.dt_rescisao::text, '') = '') or (a.dt_rescisao > dt_fim_p))
		and	exists (select	1
				from	pls_pessoa_fisica_sib	c
				where	c.cd_pessoa_fisica	= a.cd_pessoa_fisica
				and	c.ie_atributo in ('8', '1', '3', '2') --CPF. nome, sexo e data de nascimento
				and	c.dt_ocorrencia_sib between dt_inicio_p and dt_fim_p)
		and 	a.dt_contratacao < dt_inicio_p
		and	b.cd_estabelecimento	= get_cd_estabelecimento
		and	ie_tipo_movimentacao_p = 'P'; --Movimentacao periodica - Alteracao	
		
	
BEGIN

	for r_c01_w in C01 loop
		begin
		ptu_mov_autogestao_w.nr_seq_segurado(index_w)	:= r_c01_w.nr_seq_segurado;
		ptu_mov_autogestao_w.cd_unimed(index_w)		:= substr(r_c01_w.cd_usuario_plano,1,4);
		ptu_mov_autogestao_w.cd_usuario_plano(index_w)	:= substr(r_c01_w.cd_usuario_plano,5,13);
		ptu_mov_autogestao_w.nm_beneficiario(index_w)	:= ptu_somente_caracter_permitido(r_c01_w.nm_pessoa_fisica,'ANS');
		ptu_mov_autogestao_w.dt_nascimento(index_w)	:= r_c01_w.dt_nascimento;
		ptu_mov_autogestao_w.ie_sexo(index_w)		:= r_c01_w.ie_sexo;
		ptu_mov_autogestao_w.nr_cartao_nac_sus(index_w)	:= r_c01_w.nr_cartao_nac_sus;
		ptu_mov_autogestao_w.nr_cpf(index_w)		:= r_c01_w.nr_cpf;
		ptu_mov_autogestao_w.dt_contratacao(index_w)	:= r_c01_w.dt_contratacao;
		ptu_mov_autogestao_w.dt_rescisao(index_w)	:= r_c01_w.dt_rescisao;
		ptu_mov_autogestao_w.cd_cgc(index_w)		:= r_c01_w.cd_cgc;
		ptu_mov_autogestao_w.cd_ans(index_w)		:= r_c01_w.cd_ans;
		ptu_mov_autogestao_w.ie_tipo_movimentacao(index_w) := r_c01_w.ie_tipo_movimentacao;
		index_w	:= index_w + 1;
		end;
	end loop;
	
	forall i in ptu_mov_autogestao_w.nr_seq_segurado.first .. ptu_mov_autogestao_w.nr_seq_segurado.last
		insert into ptu_mov_benef_autogestao(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
				nr_seq_segurado, cd_unimed, cd_usuario_plano,
				nm_beneficiario, dt_nascimento, ie_sexo,
				cd_cns, nr_cpf, dt_inclusao,
				dt_exclusao, cd_cnpj, cd_auto_gestao_ans,
				nr_seq_lote, ie_tipo_movimentacao)
		values (	nextval('ptu_mov_benef_autogestao_seq'),clock_timestamp(),get_nm_usuario,clock_timestamp(),get_nm_usuario,
				ptu_mov_autogestao_w.nr_seq_segurado(i), ptu_mov_autogestao_w.cd_unimed(i), ptu_mov_autogestao_w.cd_usuario_plano(i),
				ptu_mov_autogestao_w.nm_beneficiario(i), ptu_mov_autogestao_w.dt_nascimento(i), ptu_mov_autogestao_w.ie_sexo(i),
				ptu_mov_autogestao_w.nr_cartao_nac_sus(i), ptu_mov_autogestao_w.nr_cpf(i), ptu_mov_autogestao_w.dt_contratacao(i),
				ptu_mov_autogestao_w.dt_rescisao(i), ptu_mov_autogestao_w.cd_cgc(i), ptu_mov_autogestao_w.cd_ans(i),				
				nr_seq_lote_p, ptu_mov_autogestao_w.ie_tipo_movimentacao(i));
	
	qt_benef_excluido_w	:= 0;
	
	select	count(1)
	into STRICT	qt_benef_excluido_w
	from	ptu_mov_benef_autogestao a
	where	exists (	SELECT	1
			from	ptu_mov_benef_autogestao x
			where	a.nr_seq_lote = x.nr_seq_lote
			and	a.cd_unimed = x.cd_unimed
			and	a.cd_usuario_plano = x.cd_usuario_plano
			and	x.ie_tipo_movimentacao = 'I')
	and	a.ie_tipo_movimentacao in ('A', 'E')
	and	a.nr_seq_lote = nr_seq_lote_p;
	
	delete from ptu_mov_benef_autogestao
	where nr_sequencia in (	SELECT	a.nr_sequencia
				from	ptu_mov_benef_autogestao a
				where	exists (	select	1
						from	ptu_mov_benef_autogestao x
						where	a.nr_seq_lote = x.nr_seq_lote
						and	a.cd_unimed = x.cd_unimed
						and	a.cd_usuario_plano = x.cd_usuario_plano
						and	x.ie_tipo_movimentacao = 'I')
				and	a.ie_tipo_movimentacao in ('A', 'E')
				and	a.nr_seq_lote = nr_seq_lote_p);
	
	PERFORM set_config('ptu_moviment_benef_a1300_pck.qt_total_r317_w', (current_setting('ptu_moviment_benef_a1300_pck.qt_total_r317_w')::ptu_mov_benef_trailer.qt_total_r317%type + ptu_mov_autogestao_w.nr_seq_segurado.count) - qt_benef_excluido_w, false);
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_moviment_benef_a1300_pck.gerar_benef_autogestao ( nr_seq_lote_p ptu_mov_benef_lote.nr_sequencia%type, ie_tipo_movimentacao_p ptu_mov_benef_lote.ie_tipo_movimentacao%type, dt_inicio_p timestamp, dt_fim_p timestamp) FROM PUBLIC;
