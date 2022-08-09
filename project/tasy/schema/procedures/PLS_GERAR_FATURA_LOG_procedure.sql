-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_fatura_log ( nr_seq_lote_p pls_lote_faturamento.nr_sequencia%type, -- Lote faturamento
 nr_seq_fatura_p pls_fatura.nr_sequencia%type, -- Fatura PLS
 nr_seq_conta_p pls_conta.nr_sequencia%type, -- Conta médica
 ds_observacao_p pls_fatura_log.ds_observacao%type, -- Observação, normalmente nome da rotina que chama esta
 ie_opcao_p text, -- Opção de log
 ie_commit_p text, -- Se deve efetuar commit
 nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Log  OPS - Faturamento
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:	IE_OPCAO
		** Dominio 8098 (Tipos de log da fatura PLS) **

		VA = Valores das faturas do lote
		IM = Conta manual
		RC = Remoção de conta
		FL = Alteração de congênere na conta da fatura
		DL = Desfazer lote faturamento
		GL = Gerar lote faturamento
		TC = Tratar conta fechada
		GT = Geração título
		CT = Cancelamento título
		GN = Geração nota fiscal
		CN = Cancelamento nota fiscal
		CF = Cancelamento fatura
		AT = Atualizar valores do lote
		CX = Contas sendo desvinculadas incorretamente
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_log_w			pls_fatura_log.ds_log%type; -- 4000
qt_conta_w			integer;
nr_seq_fatura_w			pls_fatura.nr_sequencia%type := nr_seq_fatura_p;
nr_titulo_w			pls_fatura.nr_titulo%type;
nr_titulo_ndc_w			pls_fatura.nr_titulo_ndc%type;
nr_nota_fiscal_w		nota_fiscal.nr_nota_fiscal%type;
nr_nota_fiscal_ndc_w		nota_fiscal.nr_nota_fiscal%type;

C01 CURSOR(	nr_seq_lote_pc	pls_lote_faturamento.nr_sequencia%type ) FOR
	SELECT	nr_sequencia nr_seq_fatura,
		coalesce(vl_fatura,0) vl_fatura,
		coalesce(vl_total_ndc,0) vl_ndc
	from	pls_fatura
	where	nr_seq_lote = nr_seq_lote_pc;

BEGIN
-- Log de valores das faturas do lote
if (ie_opcao_p in ('VA')) then
	for r_C01_w in C01(nr_seq_lote_p) loop
		select	count(1)
		into STRICT	qt_conta_w
		from	pls_fatura_conta c,
			pls_fatura_evento b
		where	b.nr_sequencia	= c.nr_seq_fatura_evento
		and	b.nr_seq_fatura	= r_C01_w.nr_seq_fatura;

		ds_log_w := 	'Fatura: '	|| r_C01_w.nr_seq_fatura ||
				' Qtd contas: ' || qt_conta_w ||
				' Vl fatura: ' 	|| r_C01_w.vl_fatura ||
				' Vl ndc: ' 	|| r_C01_w.vl_ndc ||
				' Vl total: '	|| (r_C01_w.vl_ndc + r_C01_w.vl_fatura);

		insert into pls_fatura_log(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_lote,
			ds_log,
			ds_observacao,
			ie_opcao)
		values (nextval('pls_fatura_log_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_lote_p,
			ds_log_w,
			ds_observacao_p,
			ie_opcao_p);
	end loop;

-- Demais logs
elsif (ie_opcao_p not in ('VA')) then

	-- Log de conta manual
	if (coalesce(nr_seq_fatura_w::text, '') = '') and (ie_opcao_p in ('IM')) then
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_fatura_w
		from	pls_fatura_conta c,
			pls_fatura_evento b,
			pls_fatura a
		where	a.nr_sequencia	= b.nr_seq_fatura
		and	b.nr_sequencia	= c.nr_seq_fatura_evento
		and	c.nr_seq_conta	= nr_seq_conta_p
		and	a.nr_seq_lote	= nr_seq_lote_p;
	end if;

	-- Geração título / Cancelamento título
	if (ie_opcao_p in ('GT','CT')) then
		select	max(nr_titulo),
			max(nr_titulo_ndc)
		into STRICT	nr_titulo_w,
			nr_titulo_ndc_w
		from	pls_fatura
		where	nr_sequencia	= nr_seq_fatura_w;
	end if;

	-- Geração nota fiscal / Cancelamento nota fiscal
	if (ie_opcao_p in ('GN','CN')) then
		select	max(nr_nota_fiscal)
		into STRICT	nr_nota_fiscal_w
		from	nota_fiscal
		where	nr_seq_fatura = nr_seq_fatura_w;

		select	max(nr_nota_fiscal)
		into STRICT	nr_nota_fiscal_ndc_w
		from	nota_fiscal
		where	nr_seq_fatura_ndc = nr_seq_fatura_w;
	end if;

	if (ie_opcao_p in ('IM','RC','FL','TC')) then
		ds_log_w := 'Conta: ' || nr_seq_conta_p || ' Fatura: ' || nr_seq_fatura_w;

	elsif (ie_opcao_p in ('DL')) then
		ds_log_w := 'Desfazer lote faturamento.';

	elsif (ie_opcao_p in ('GL')) then
		ds_log_w := 'Gerar lote faturamento.';

	elsif (ie_opcao_p in ('GT')) then
		ds_log_w := 'Geração título fatura. Título: '|| nr_titulo_w ||' Título NDR: '||nr_titulo_ndc_w;

	elsif (ie_opcao_p in ('CT')) then
		ds_log_w := 'Cancelamento título fatura. Título: '|| nr_titulo_w ||' Título NDR: '||nr_titulo_ndc_w;

	elsif (ie_opcao_p in ('GN')) then
		ds_log_w := 'Geração nota fiscal fatura. Nota fiscal: '|| nr_nota_fiscal_w ||' Nota fiscal NDR: '||nr_nota_fiscal_ndc_w;

	elsif (ie_opcao_p in ('CN')) then
		ds_log_w := 'Cancelamento nota fiscal fatura. Nota fiscal: '|| nr_nota_fiscal_w ||' Nota fiscal NDR: '||nr_nota_fiscal_ndc_w;

	elsif (ie_opcao_p in ('CF')) then
		ds_log_w := 'Fatura: ' || nr_seq_fatura_w;

	elsif (ie_opcao_p in ('NF')) then
		ds_log_w := 'Ação - Não faturar: ' || nr_seq_fatura_w;

	elsif (ie_opcao_p in ('BP')) then
		ds_log_w := 'Ação - Baixar por perda: ' || nr_seq_fatura_w;

	elsif (ie_opcao_p in ('AT')) then
		ds_log_w := 'Atualizado os valores do lote.';

	elsif (ie_opcao_p in ('CX')) then
		ds_log_w := 'Conta sendo desvinculada incorretamente.';

	elsif (ie_opcao_p in ('L')) then
		ds_log_w := 'Log geral. Gerado: '||to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss');
	end if;

	insert into pls_fatura_log(nr_sequencia,			dt_atualizacao,		nm_usuario,
		dt_atualizacao_nrec,		nm_usuario_nrec,	nr_seq_lote,
		ds_log,				ds_observacao,		ie_opcao,
		nr_seq_fatura,			nr_seq_conta)
	values (nextval('pls_fatura_log_seq'),	clock_timestamp(),		nm_usuario_p,
		clock_timestamp(),			nm_usuario_p,		nr_seq_lote_p,
		ds_log_w,			ds_observacao_p,	ie_opcao_p,
		nr_seq_fatura_w,		nr_seq_conta_p);
end if;

if (coalesce(ie_commit_p,'N') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_fatura_log ( nr_seq_lote_p pls_lote_faturamento.nr_sequencia%type, nr_seq_fatura_p pls_fatura.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, ds_observacao_p pls_fatura_log.ds_observacao%type, ie_opcao_p text, ie_commit_p text, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
