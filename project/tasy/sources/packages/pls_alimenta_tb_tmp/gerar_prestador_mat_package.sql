-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Obter prestador por material (fornecedor)
CREATE OR REPLACE PROCEDURE pls_alimenta_tb_tmp.gerar_prestador_mat (nr_seq_lote_p pls_lote_protocolo.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type) AS $body$
DECLARE


_ora2pg_r RECORD;
nr_contador_w			integer := 0;
tb_nr_seq_prestador_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_lote_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_protocolo_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_conta_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_conta_proc_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_conta_mat_w		pls_util_cta_pck.t_number_table;
tb_cd_prestador_w		pls_util_cta_pck.t_varchar2_table_50;
tb_ie_tipo_pessoa_prest_w	pls_util_cta_pck.t_varchar2_table_5;
tb_nr_seq_classificacao_w	pls_util_cta_pck.t_number_table;
tb_ie_tipo_prestador_w		pls_util_cta_pck.t_varchar2_table_5;
tb_nr_seq_prest_inter_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_proc_partic_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_analise_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_lote_processo_w	pls_util_cta_pck.t_number_table;
tb_null_w			pls_util_cta_pck.t_number_table;

-- Material por lote de protocolo
c01 CURSOR(	nr_seq_lote_pc		pls_lote_protocolo.nr_sequencia%type) FOR
	SELECT	p.nr_sequencia nr_seq_prestador,
		p.cd_prestador,
		CASE WHEN coalesce(p.cd_cgc::text, '') = '' THEN 'PF'  ELSE 'PJ' END  ie_tipo_pessoa_prest,
		p.nr_seq_classificacao,
		'PF' ie_tipo_prestador,
		c.nr_seq_protocolo,
		c.nr_sequencia nr_seq_conta,
		m.nr_sequencia nr_seq_conta_mat,
		c.nr_seq_analise,
		null
	from	pls_conta_mat		m,
		pls_conta		c,
		pls_protocolo_conta	l,
		pls_prestador		p
	where	l.nr_sequencia	= c.nr_seq_protocolo
	and	c.nr_sequencia	= m.nr_seq_conta
	and	p.nr_sequencia	= m.nr_seq_prest_fornec
	and	l.nr_seq_lote	= nr_seq_lote_pc;

-- Material por protocolo
c02 CURSOR(	nr_seq_protocolo_pc	pls_protocolo_conta.nr_sequencia%type) FOR
	SELECT	p.nr_sequencia nr_seq_prestador,
		p.cd_prestador,
		CASE WHEN coalesce(p.cd_cgc::text, '') = '' THEN 'PF'  ELSE 'PJ' END  ie_tipo_pessoa_prest,
		p.nr_seq_classificacao,
		'PF' ie_tipo_prestador,
		c.nr_seq_protocolo,
		c.nr_sequencia nr_seq_conta,
		m.nr_sequencia nr_seq_conta_mat,
		c.nr_seq_analise,
		null
	from	pls_conta_mat		m,
		pls_conta		c,
		pls_protocolo_conta	l,
		pls_prestador		p
	where	l.nr_sequencia	= c.nr_seq_protocolo
	and	c.nr_sequencia	= m.nr_seq_conta
	and	p.nr_sequencia	= m.nr_seq_prest_fornec
	and	l.nr_sequencia	= nr_seq_protocolo_pc;

-- Material por conta
c03 CURSOR(	nr_seq_conta_pc		pls_conta.nr_sequencia%type) FOR
	SELECT	p.nr_sequencia nr_seq_prestador,
		p.cd_prestador,
		CASE WHEN coalesce(p.cd_cgc::text, '') = '' THEN 'PF'  ELSE 'PJ' END  ie_tipo_pessoa_prest,
		p.nr_seq_classificacao,
		'PF' ie_tipo_prestador,
		c.nr_seq_protocolo,
		c.nr_sequencia nr_seq_conta,
		m.nr_sequencia nr_seq_conta_mat,
		c.nr_seq_analise,
		null
	from	pls_conta_mat		m,
		pls_conta		c,
		pls_prestador		p
	where	c.nr_sequencia	= m.nr_seq_conta
	and	p.nr_sequencia	= m.nr_seq_prest_fornec
	and	c.nr_sequencia	= nr_seq_conta_pc;

-- Material por analise
c04 CURSOR(	nr_seq_analise_pc	pls_analise_conta.nr_sequencia%type) FOR
	SELECT	p.nr_sequencia nr_seq_prestador,
		p.cd_prestador,
		CASE WHEN coalesce(p.cd_cgc::text, '') = '' THEN 'PF'  ELSE 'PJ' END  ie_tipo_pessoa_prest,
		p.nr_seq_classificacao,
		'PF' ie_tipo_prestador,
		c.nr_seq_protocolo,
		c.nr_sequencia nr_seq_conta,
		m.nr_sequencia nr_seq_conta_mat,
		c.nr_seq_analise,
		null
	from	pls_conta_mat		m,
		pls_conta		c,
		pls_prestador		p
	where	c.nr_sequencia		= m.nr_seq_conta
	and	p.nr_sequencia		= m.nr_seq_prest_fornec
	and	c.nr_seq_analise	= nr_seq_analise_pc;

-- Material por lote de processos
c05 CURSOR(	nr_seq_lote_processo_pc		pls_cta_lote_processo.nr_sequencia%type) FOR
	SELECT	p.cd_prestador,
		CASE WHEN coalesce(p.cd_cgc::text, '') = '' THEN 'PF'  ELSE 'PJ' END  ie_tipo_pessoa_prest,
		t.nr_seq_prestador,
		p.nr_seq_classificacao,
		t.ie_tipo_prestador,
		t.nr_seq_protocolo,
		t.nr_seq_conta,
		t.nr_seq_conta_mat,
		t.nr_seq_analise,
		nr_seq_lote_processo_pc nr_seq_lote_processo_p,
		null
	from (	SELECT	m.nr_seq_prest_fornec nr_seq_prestador,
			'PF' ie_tipo_prestador,
			c.nr_seq_protocolo,
			c.nr_sequencia nr_seq_conta,
			m.nr_sequencia nr_seq_conta_mat,
			c.nr_seq_analise
		from	pls_cta_lote_proc_conta	y,
			pls_conta_mat		m,
			pls_conta		c
		where	y.nr_seq_conta		= m.nr_seq_conta
		and	c.nr_sequencia		= m.nr_seq_conta
		and	c.nr_sequencia		= y.nr_seq_conta
		and	y.nr_seq_lote_processo	= nr_seq_lote_processo_pc)	t,
		pls_prestador	p
	where p.nr_sequencia	= t.nr_seq_prestador;


BEGIN

-- Materiais = Fornecedores
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	-- Por Lote de Protocolo
	open c01(nr_seq_lote_p);
	loop
	fetch c01 bulk collect into	tb_nr_seq_prestador_w,
					tb_cd_prestador_w,
					tb_ie_tipo_pessoa_prest_w,
					tb_nr_seq_classificacao_w,
					tb_ie_tipo_prestador_w,
					tb_nr_seq_protocolo_w,
					tb_nr_seq_conta_w,
					tb_nr_seq_conta_mat_w,
					tb_nr_seq_analise_w,
					tb_null_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_prestador_w.count = 0;

		SELECT * FROM pls_alimenta_tb_tmp.inserir_prestador(	nr_contador_w, tb_nr_seq_prestador_w, tb_nr_seq_lote_w, tb_nr_seq_protocolo_w, tb_nr_seq_conta_w, tb_null_w, tb_nr_seq_conta_mat_w, tb_cd_prestador_w, tb_ie_tipo_pessoa_prest_w, tb_nr_seq_classificacao_w, tb_ie_tipo_prestador_w, tb_null_w, tb_null_w, tb_nr_seq_analise_w, tb_null_w) INTO STRICT _ora2pg_r;
 	nr_contador_w := _ora2pg_r.nr_contador_p; tb_nr_seq_prestador_w := _ora2pg_r.tb_nr_seq_prestador_p; tb_nr_seq_lote_w := _ora2pg_r.tb_nr_seq_lote_p; tb_nr_seq_protocolo_w := _ora2pg_r.tb_nr_seq_protocolo_p; tb_nr_seq_conta_w := _ora2pg_r.tb_nr_seq_conta_p; tb_null_w := _ora2pg_r.tb_nr_seq_conta_proc_p; tb_nr_seq_conta_mat_w := _ora2pg_r.tb_nr_seq_conta_mat_p; tb_cd_prestador_w := _ora2pg_r.tb_cd_prestador_p; tb_ie_tipo_pessoa_prest_w := _ora2pg_r.tb_ie_tipo_pessoa_prest_p; tb_nr_seq_classificacao_w := _ora2pg_r.tb_nr_seq_classificacao_p; tb_ie_tipo_prestador_w := _ora2pg_r.tb_ie_tipo_prestador_p; tb_null_w := _ora2pg_r.tb_nr_seq_prest_inter_p; tb_null_w := _ora2pg_r.tb_nr_seq_proc_partic_p; tb_nr_seq_analise_w := _ora2pg_r.tb_nr_seq_analise_p; tb_null_w := _ora2pg_r.tb_nr_seq_lote_processo_p;
	end loop;

elsif (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then
	-- Por protocolo
	open c02( nr_seq_protocolo_p );
	loop
	fetch c02 bulk collect into	tb_nr_seq_prestador_w,
					tb_cd_prestador_w,
					tb_ie_tipo_pessoa_prest_w,
					tb_nr_seq_classificacao_w,
					tb_ie_tipo_prestador_w,
					tb_nr_seq_protocolo_w,
					tb_nr_seq_conta_w,
					tb_nr_seq_conta_mat_w,
					tb_nr_seq_analise_w,
					tb_null_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_prestador_w.count = 0;

		SELECT * FROM pls_alimenta_tb_tmp.inserir_prestador(	nr_contador_w, tb_nr_seq_prestador_w, tb_null_w, tb_nr_seq_protocolo_w, tb_nr_seq_conta_w, tb_null_w, tb_nr_seq_conta_mat_w, tb_cd_prestador_w, tb_ie_tipo_pessoa_prest_w, tb_nr_seq_classificacao_w, tb_ie_tipo_prestador_w, tb_null_w, tb_null_w, tb_nr_seq_analise_w, tb_null_w) INTO STRICT _ora2pg_r;
 	nr_contador_w := _ora2pg_r.nr_contador_p; tb_nr_seq_prestador_w := _ora2pg_r.tb_nr_seq_prestador_p; tb_null_w := _ora2pg_r.tb_nr_seq_lote_p; tb_nr_seq_protocolo_w := _ora2pg_r.tb_nr_seq_protocolo_p; tb_nr_seq_conta_w := _ora2pg_r.tb_nr_seq_conta_p; tb_null_w := _ora2pg_r.tb_nr_seq_conta_proc_p; tb_nr_seq_conta_mat_w := _ora2pg_r.tb_nr_seq_conta_mat_p; tb_cd_prestador_w := _ora2pg_r.tb_cd_prestador_p; tb_ie_tipo_pessoa_prest_w := _ora2pg_r.tb_ie_tipo_pessoa_prest_p; tb_nr_seq_classificacao_w := _ora2pg_r.tb_nr_seq_classificacao_p; tb_ie_tipo_prestador_w := _ora2pg_r.tb_ie_tipo_prestador_p; tb_null_w := _ora2pg_r.tb_nr_seq_prest_inter_p; tb_null_w := _ora2pg_r.tb_nr_seq_proc_partic_p; tb_nr_seq_analise_w := _ora2pg_r.tb_nr_seq_analise_p; tb_null_w := _ora2pg_r.tb_nr_seq_lote_processo_p;
	end loop;

elsif (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
	-- Por conta
	open c03( nr_seq_conta_p );
	loop
	fetch c03 bulk collect into	tb_nr_seq_prestador_w,
					tb_cd_prestador_w,
					tb_ie_tipo_pessoa_prest_w,
					tb_nr_seq_classificacao_w,
					tb_ie_tipo_prestador_w,
					tb_nr_seq_protocolo_w,
					tb_nr_seq_conta_w,
					tb_nr_seq_conta_mat_w,
					tb_nr_seq_analise_w,
					tb_null_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_prestador_w.count = 0;

		SELECT * FROM pls_alimenta_tb_tmp.inserir_prestador(	nr_contador_w, tb_nr_seq_prestador_w, tb_null_w, tb_nr_seq_protocolo_w, tb_nr_seq_conta_w, tb_null_w, tb_nr_seq_conta_mat_w, tb_cd_prestador_w, tb_ie_tipo_pessoa_prest_w, tb_nr_seq_classificacao_w, tb_ie_tipo_prestador_w, tb_null_w, tb_null_w, tb_nr_seq_analise_w, tb_null_w) INTO STRICT _ora2pg_r;
 	nr_contador_w := _ora2pg_r.nr_contador_p; tb_nr_seq_prestador_w := _ora2pg_r.tb_nr_seq_prestador_p; tb_null_w := _ora2pg_r.tb_nr_seq_lote_p; tb_nr_seq_protocolo_w := _ora2pg_r.tb_nr_seq_protocolo_p; tb_nr_seq_conta_w := _ora2pg_r.tb_nr_seq_conta_p; tb_null_w := _ora2pg_r.tb_nr_seq_conta_proc_p; tb_nr_seq_conta_mat_w := _ora2pg_r.tb_nr_seq_conta_mat_p; tb_cd_prestador_w := _ora2pg_r.tb_cd_prestador_p; tb_ie_tipo_pessoa_prest_w := _ora2pg_r.tb_ie_tipo_pessoa_prest_p; tb_nr_seq_classificacao_w := _ora2pg_r.tb_nr_seq_classificacao_p; tb_ie_tipo_prestador_w := _ora2pg_r.tb_ie_tipo_prestador_p; tb_null_w := _ora2pg_r.tb_nr_seq_prest_inter_p; tb_null_w := _ora2pg_r.tb_nr_seq_proc_partic_p; tb_nr_seq_analise_w := _ora2pg_r.tb_nr_seq_analise_p; tb_null_w := _ora2pg_r.tb_nr_seq_lote_processo_p;
	end loop;

elsif (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') then
	-- Por analise
	open c04(nr_seq_analise_p);
	loop

	fetch c04 bulk collect into	tb_nr_seq_prestador_w,
					tb_cd_prestador_w,
					tb_ie_tipo_pessoa_prest_w,
					tb_nr_seq_classificacao_w,
					tb_ie_tipo_prestador_w,
					tb_nr_seq_protocolo_w,
					tb_nr_seq_conta_w,
					tb_nr_seq_conta_mat_w,
					tb_nr_seq_analise_w,
					tb_null_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_prestador_w.count = 0;

		SELECT * FROM pls_alimenta_tb_tmp.inserir_prestador(	nr_contador_w, tb_nr_seq_prestador_w, tb_null_w, tb_nr_seq_protocolo_w, tb_nr_seq_conta_w, tb_null_w, tb_nr_seq_conta_mat_w, tb_cd_prestador_w, tb_ie_tipo_pessoa_prest_w, tb_nr_seq_classificacao_w, tb_ie_tipo_prestador_w, tb_null_w, tb_null_w, tb_nr_seq_analise_w, tb_null_w) INTO STRICT _ora2pg_r;
 	nr_contador_w := _ora2pg_r.nr_contador_p; tb_nr_seq_prestador_w := _ora2pg_r.tb_nr_seq_prestador_p; tb_null_w := _ora2pg_r.tb_nr_seq_lote_p; tb_nr_seq_protocolo_w := _ora2pg_r.tb_nr_seq_protocolo_p; tb_nr_seq_conta_w := _ora2pg_r.tb_nr_seq_conta_p; tb_null_w := _ora2pg_r.tb_nr_seq_conta_proc_p; tb_nr_seq_conta_mat_w := _ora2pg_r.tb_nr_seq_conta_mat_p; tb_cd_prestador_w := _ora2pg_r.tb_cd_prestador_p; tb_ie_tipo_pessoa_prest_w := _ora2pg_r.tb_ie_tipo_pessoa_prest_p; tb_nr_seq_classificacao_w := _ora2pg_r.tb_nr_seq_classificacao_p; tb_ie_tipo_prestador_w := _ora2pg_r.tb_ie_tipo_prestador_p; tb_null_w := _ora2pg_r.tb_nr_seq_prest_inter_p; tb_null_w := _ora2pg_r.tb_nr_seq_proc_partic_p; tb_nr_seq_analise_w := _ora2pg_r.tb_nr_seq_analise_p; tb_null_w := _ora2pg_r.tb_nr_seq_lote_processo_p;
	end loop;

elsif (nr_seq_lote_processo_p IS NOT NULL AND nr_seq_lote_processo_p::text <> '') then
	-- Por lote de processos
	open c05( nr_seq_lote_processo_p );
	loop
	fetch c05 bulk collect into	tb_cd_prestador_w,
					tb_ie_tipo_pessoa_prest_w,
					tb_nr_seq_prestador_w,
					tb_nr_seq_classificacao_w,
					tb_ie_tipo_prestador_w,
					tb_nr_seq_protocolo_w,
					tb_nr_seq_conta_w,
					tb_nr_seq_conta_mat_w,
					tb_nr_seq_analise_w,
					tb_nr_seq_lote_processo_w,
					tb_null_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_prestador_w.count = 0;

		SELECT * FROM pls_alimenta_tb_tmp.inserir_prestador(	nr_contador_w, tb_nr_seq_prestador_w, tb_null_w, tb_nr_seq_protocolo_w, tb_nr_seq_conta_w, tb_null_w, tb_nr_seq_conta_mat_w, tb_cd_prestador_w, tb_ie_tipo_pessoa_prest_w, tb_nr_seq_classificacao_w, tb_ie_tipo_prestador_w, tb_null_w, tb_null_w, tb_nr_seq_analise_w, tb_nr_seq_lote_processo_w) INTO STRICT _ora2pg_r;
 	nr_contador_w := _ora2pg_r.nr_contador_p; tb_nr_seq_prestador_w := _ora2pg_r.tb_nr_seq_prestador_p; tb_null_w := _ora2pg_r.tb_nr_seq_lote_p; tb_nr_seq_protocolo_w := _ora2pg_r.tb_nr_seq_protocolo_p; tb_nr_seq_conta_w := _ora2pg_r.tb_nr_seq_conta_p; tb_null_w := _ora2pg_r.tb_nr_seq_conta_proc_p; tb_nr_seq_conta_mat_w := _ora2pg_r.tb_nr_seq_conta_mat_p; tb_cd_prestador_w := _ora2pg_r.tb_cd_prestador_p; tb_ie_tipo_pessoa_prest_w := _ora2pg_r.tb_ie_tipo_pessoa_prest_p; tb_nr_seq_classificacao_w := _ora2pg_r.tb_nr_seq_classificacao_p; tb_ie_tipo_prestador_w := _ora2pg_r.tb_ie_tipo_prestador_p; tb_null_w := _ora2pg_r.tb_nr_seq_prest_inter_p; tb_null_w := _ora2pg_r.tb_nr_seq_proc_partic_p; tb_nr_seq_analise_w := _ora2pg_r.tb_nr_seq_analise_p; tb_nr_seq_lote_processo_w := _ora2pg_r.tb_nr_seq_lote_processo_p;
	end loop;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alimenta_tb_tmp.gerar_prestador_mat (nr_seq_lote_p pls_lote_protocolo.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type) FROM PUBLIC;