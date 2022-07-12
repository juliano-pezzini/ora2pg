-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_contab_onl_lote_fin_pck.contab_prov_copart ( doc_p INOUT ctb_documento, nm_usuario_p text) AS $body$
DECLARE

	
	dados_contab_w			dados_contab;
	vet_contas_contabeis_w		vet_contas_contabeis;
	nr_seq_protocolo_w		pls_protocolo_conta.nr_sequencia%type;
	cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
	cd_cgc_prest_cong_w		pessoa_juridica.cd_cgc%type;
	cd_cpf_prestador_w		pessoa_fisica.nr_cpf%type;
	nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
	nm_prest_cong_w			pessoa_fisica.nm_pessoa_fisica%type := '';
	nr_titulo_w			titulo_pagar.nr_titulo%type;
	cd_conta_cred_w			pls_conta.cd_conta_cred%type;
	cd_conta_deb_w			pls_conta.cd_conta_deb%type;
	nr_seq_regra_cc_w		pls_regra_centro_custo.nr_sequencia%type;
	cd_centro_custo_w		centro_custo.cd_centro_custo%type;
	cd_historico_w			pls_conta_proc.cd_historico%type;
	nr_seq_conta_w			pls_conta.nr_sequencia%type;
	nr_seq_copartic_contab_w	pls_conta_copartic_contab.nr_sequencia%type;
	nr_seq_prest_cong_w		pls_prestador.nr_sequencia%type;
	nr_nota_fiscal_w		pls_prot_conta_titulo.nr_nota_fiscal%type;
	nr_seq_pagador_w		pls_segurado.nr_seq_pagador%type;
	nm_prestador_pgto_w		pls_conta_medica_resumo.nm_prestador_pgto%type;
	ie_regulamentacao_w		pls_plano.ie_regulamentacao%type;
	nr_seq_prot_conta_w		pls_protocolo_conta.nr_sequencia%type;
	nm_agrupador_w			varchar(30);
	nm_pagador_w			varchar(80);
	nm_segurado_w			varchar(255);
	ds_conteudo_w			varchar(4000);
	ds_compl_historico_w		varchar(255);
	nr_seq_plano_w			bigint;
	ie_centro_custo_w		varchar(1);
	qt_atrib_hist_pad_w		integer;

	
BEGIN
		begin
		select	c.nr_sequencia,
			coalesce(c.cd_conta_deb_provisao, 'X'),
			coalesce(c.cd_conta_cred_provisao, 'X'),
			coalesce(c.cd_historico_provisao, 0),
			a.nr_sequencia,
			a.nr_seq_segurado,
			a.nr_seq_protocolo,
			a.nr_seq_prestador_exec,
			d.ie_regulamentacao,
			d.nr_sequencia,
			coalesce(a.nr_seq_prot_conta, 0),
			(select	nm_prestador_pgto
			 from	pls_conta_medica_resumo		r
			 where	r.nr_sequencia	= c.nr_seq_conta_resumo
			 and	r.nr_seq_conta	= a.nr_sequencia) nm_prestador_pgto,
			substr(pls_obter_dados_segurado(a.nr_seq_segurado,'N'),1,255) nm_segurado
		into STRICT	nr_seq_copartic_contab_w,
			cd_conta_deb_w,
			cd_conta_cred_w,
			cd_historico_w,
			nr_seq_conta_w,
			nr_seq_segurado_w,
			nr_seq_protocolo_w,
			nr_seq_prest_cong_w,
			ie_regulamentacao_w,
			nr_seq_plano_w,
			nr_seq_prot_conta_w,
			nm_prestador_pgto_w,
			nm_segurado_w
		from	pls_conta 			a,
			pls_conta_coparticipacao	b,
			pls_conta_copartic_contab	c,
			pls_plano			d
		where	a.nr_sequencia			= b.nr_seq_conta
		and	b.nr_sequencia			= c.nr_seq_conta_copartic
		and	a.nr_sequencia			= b.nr_seq_conta
		and	d.nr_sequencia			= a.nr_seq_plano
		and     a.nr_sequencia          	= doc_p.nr_seq_doc_compl
		and     c.nr_sequencia          	= doc_p.nr_doc_analitico;
	exception when no_data_found then
	/* Salva a inconsistencia: "Nao foi possivel identificar o movimento de origem." */

	select 	obter_desc_expressao(950251)
	into STRICT	doc_p.ds_inconsistencia
	;
	return;
	end;

	/* Se nao houver informacoes de contas contabeis ou de historico, nao segue o processo */

	if (cd_conta_cred_w= 'X' or cd_conta_deb_w = 'X' or cd_historico_w = 0) then
		/* Salva a inconsistencia: "Conta nao encontrada" */

		select 	obter_desc_expressao(330747)
		into STRICT	doc_p.ds_inconsistencia
		;
		return;
	end if;

	/* Informacoes presentes no doc_p */

	dados_contab_w.dt_movimento             := doc_p.dt_competencia;
	dados_contab_w.vl_movimento             := doc_p.vl_movimento;
	dados_contab_w.cd_tipo_lote_contabil    := doc_p.cd_tipo_lote_contabil;
	dados_contab_w.cd_estabelecimento       := doc_p.cd_estabelecimento;

	/* Salva as contas contabeis em um vetor, pois sera feito um insert com cada uma delas*/

	vet_contas_contabeis_w := vet_contas_contabeis();
	vet_contas_contabeis_w.extend(2);
	vet_contas_contabeis_w(1) := cd_conta_cred_w;
	vet_contas_contabeis_w(2) := cd_conta_deb_w;
	dados_contab_w.cd_historico := cd_historico_w;

	/* Numero de agrupamento */

	nm_agrupador_w	:= coalesce(trim(both obter_agrupador_contabil(doc_p.cd_tipo_lote_contabil)),'NR_SEQ_CONTA');

	if (nm_agrupador_w = 'NR_SEQ_PROTOCOLO') then
		dados_contab_w.nr_seq_agrupamento	:= somente_numero(substr(nr_seq_protocolo_w, 1, 10));
	else
		dados_contab_w.nr_seq_agrupamento	:= somente_numero(substr(nr_seq_conta_w, 1, 10));
	end if;

	/* Verifica se existe algum atributo cadastrado para aquele historico, levando em consideracao o tipo de lote contabil e estabelecimento/empresa */

	select  count(1)
	into STRICT    qt_atrib_hist_pad_w
	from    historico_padrao_atributo   c,
		historico_padrao            b,
		estabelecimento             a
	where   a.cd_estabelecimento    = doc_p.cd_estabelecimento
	and     a.cd_empresa            = b.cd_empresa
	and     b.cd_historico          = c.cd_historico
	and     c.cd_historico          = cd_historico_w
	and     c.cd_tipo_lote_contabil = doc_p.cd_tipo_lote_contabil;

	if (qt_atrib_hist_pad_w > 0) then
		/* Numero do titulo*/

		select	max(g.nr_titulo)
		into STRICT	nr_titulo_w
		from  	pls_conta			a,
			pls_conta_coparticipacao	b,
			pls_conta_copartic_contab	c,
			pls_mensalidade_seg_item	d,
			pls_mensalidade_segurado	e,
			pls_mensalidade			f,
			titulo_receber			g
		where	a.nr_sequencia	= b.nr_seq_conta
		and	b.nr_sequencia	= c.nr_seq_conta_copartic
		and	e.nr_sequencia	= d.nr_seq_mensalidade_seg
		and	f.nr_sequencia	= e.nr_seq_mensalidade
		and	f.nr_sequencia	= g.nr_seq_mensalidade
		and	e.nr_sequencia	= b.nr_seq_mensalidade_seg
		and	a.nr_sequencia	= nr_seq_conta_w
		and	c.nr_sequencia	= nr_seq_copartic_contab_w;

		/* Nota fiscal*/

		select	max(nr_nota_fiscal)
		into STRICT	nr_nota_fiscal_w
		from	pls_prot_conta_titulo
		where	nr_sequencia	= nr_seq_prot_conta_w;

		/* Informacoes do pagador */

		select	max(obter_nome_pf_pj(a.cd_pessoa_fisica,a.cd_cgc)),
			max(b.nr_seq_pagador)
		into STRICT	nm_pagador_w,
			nr_seq_pagador_w
		from	pls_contrato_pagador a,
			pls_segurado b
		where	a.nr_sequencia	= b.nr_seq_pagador
		and	b.nr_sequencia	= nr_seq_segurado_w;

		/* Obtem as informacoes da pessoa fisica ou juridica */

		if (coalesce(nr_seq_prest_cong_w,0) > 0) then
			select	a.cd_pessoa_fisica,
				a.cd_cgc,
				substr(obter_nome_pf_pj(a.cd_pessoa_fisica,a.cd_cgc),1,255)
			into STRICT	cd_pessoa_fisica_w,
				cd_cgc_prest_cong_w,
				nm_prest_cong_w
			from	pls_prestador	a
			where	a.nr_sequencia	= nr_seq_prest_cong_w;

			select	max(nr_cpf)
			into STRICT	cd_cpf_prestador_w
			from	pessoa_fisica
			where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
		else					
			select	substr(max(pls_obter_nome_congenere(a.nr_sequencia)),1,255),
				max(a.cd_cgc),
				max(a.nr_sequencia)
			into STRICT	nm_prest_cong_w,
				cd_cgc_prest_cong_w,
				nr_seq_prest_cong_w
			from	pls_congenere		a,
				pls_protocolo_conta	b,
				pls_conta		c
			where	a.nr_sequencia	= b.nr_seq_congenere
			and	b.nr_sequencia	= c.nr_seq_protocolo
			and	c.nr_sequencia	= nr_seq_conta_w;
		end if;

		/* Montagem do complemento historico */

		ds_conteudo_w	:= substr(	nr_seq_prest_cong_w		|| '#@' ||
						nm_prest_cong_w 		|| '#@' ||
						nr_seq_protocolo_w		|| '#@' ||
						nr_seq_conta_w			|| '#@' ||
						cd_cgc_prest_cong_w		|| '#@' ||
						cd_cpf_prestador_w		|| '#@' ||
						nr_nota_fiscal_w		|| '#@' ||
						nr_seq_pagador_w		|| '#@' ||
						nm_prestador_pgto_w		|| '#@' ||
						nm_segurado_w			|| '#@' ||
						nm_pagador_w			|| '#@' ||
						nr_titulo_w, 1,4000);

		begin
		ds_compl_historico_w	:= substr(obter_compl_historico(doc_p.cd_tipo_lote_contabil, dados_contab_w.cd_historico, ds_conteudo_w),1,255);
		exception
		when others then
			ds_compl_historico_w	:= null;
		end;
		dados_contab_w.ds_compl_historico	:= substr(ds_compl_historico_w,1,255);
	end if;

	/* Para cada conta conta contabil no vetor, verifica o centro de custo */

	for i in 1..vet_contas_contabeis_w.count loop
		dados_contab_w.cd_centro_custo := null;
		dados_contab_w.cd_conta_cred := null;
		dados_contab_w.cd_conta_deb := null;
		cd_centro_custo_w := null;

		/* Centro de custo */

		SELECT * FROM pls_contab_onl_lote_fin_pck.verifica_centro_custo(  'D', nr_seq_plano_w, doc_p.cd_estabelecimento, '', '', ie_regulamentacao_w, nr_seq_segurado_w, '', cd_centro_custo_w, nr_seq_regra_cc_w, coalesce(vet_contas_contabeis_w(i), 'X')) INTO STRICT cd_centro_custo_w, nr_seq_regra_cc_w;
		dados_contab_w.cd_centro_custo := cd_centro_custo_w;

		/* Segue a ordem das atribuicoes feitas no vetor */

		if (i = 1) then
			dados_contab_w.cd_conta_cred := vet_contas_contabeis_w(i);
		elsif (i = 2) then
			dados_contab_w.cd_conta_deb := vet_contas_contabeis_w(i);
		end if;

		dados_contab_w := pls_contab_onl_lote_fin_pck.contabiliza_movimento(dados_contab_w, nm_usuario_p);
		doc_p.nr_lote_contabil := dados_contab_w.nr_lote_contabil;
	end loop;

   /*  Atualiza o movimento de origem com a informacao do numero do lote contabil 
		Ao gravar os movimentos de coparticipacao na CTB_DOCUMENTO, a informacao referente a ser/nao ser estorno e gravada no campo ds_origem.
		Utiliza o valor doc_p.nr_lote_contabil para verificar se foi feita a contabilizacao.  */
	if (coalesce(doc_p.nr_lote_contabil, 0) <> 0) then
		-- Nao se trata de um estorno da contabilidade instantanea. (Gerado ao desfazer o fechamento da conta)
		-- Tambem nao se trata de um movimento do tipo estorno 
		if (coalesce(doc_p.ds_origem, 'X') = 'X') then
			update	pls_conta_copartic_contab a
			set	a.nr_lote_contabil_prov	= doc_p.nr_lote_contabil
			where	a.nr_sequencia			= doc_p.nr_doc_analitico;

			update	pls_conta_coparticipacao a
			set	a.nr_lote_contabil_prov	= doc_p.nr_lote_contabil
			where	a.nr_sequencia	= (	SELECT   b.nr_seq_conta_copartic
							from     pls_conta_copartic_contab b
							where    b.nr_sequencia  = doc_p.nr_doc_analitico);

			update	pls_protocolo_conta a
			set 	a.nr_lote_prov_copartic	= doc_p.nr_lote_contabil
			where	a.nr_sequencia		= doc_p.nr_documento;

		-- Se trata de um estorno da contabilidade instantanea. (Gerado ao desfazer o fechamento da conta)
		-- Nao se trata de um movimento do tipo estorno
		elsif (coalesce(doc_p.ds_origem, 'X') = 'CTB_ONLINE_ESTORNO') then

			update	pls_protocolo_conta a
			set 	a.nr_lote_prov_copartic	= 0
			where	a.nr_sequencia			= doc_p.nr_documento
			and     not exists (   	SELECT  1
								from    pls_conta_copartic_contab b,
									pls_conta c
								where   b.nr_seq_conta          = c.nr_sequencia
								and     c.nr_seq_protocolo      = a.nr_sequencia
								and     b.nr_lote_contabil_prov = doc_p.nr_lote_contabil);

		-- Nao se trata de um estorno da contabilidade instantanea (Gerado ao desfazer o fechamento da conta)
		-- Se trata de um movimento do tipo estorno
		elsif (coalesce(doc_p.ds_origem, 'X') = 'MOVIMENTO_ESTORNO') then
			update	pls_conta_copartic_contab a
			set	a.nr_lote_contabil_estorno	= doc_p.nr_lote_contabil
			where	a.nr_sequencia			= doc_p.nr_doc_analitico;

			update	pls_conta_coparticipacao a
			set	a.nr_lote_contabil_estorno 	= doc_p.nr_lote_contabil
			where	a.nr_sequencia			= ( 	SELECT  b.nr_seq_conta_copartic
									from    pls_conta_copartic_contab b
									where   b.nr_sequencia  = doc_p.nr_doc_analitico);
		-- Se trata de um estorno da contabilidade instantanea. (Gerado ao desfazer o fechamento da conta)
		-- Se trata de um movimento do tipo estorno
		elsif (coalesce(doc_p.ds_origem, 'X') =  'MOVIMENTO_ESTORNO CTB_ONLINE_ESTORNO') then

				update	pls_conta_copartic_contab a
				set	a.nr_lote_contabil_estorno	= 0
				where	a.nr_sequencia			= doc_p.nr_doc_analitico;

				update	pls_conta_coparticipacao a
				set	a.nr_lote_contabil_estorno 	= 0
				where	a.nr_sequencia			= ( 	SELECT  b.nr_seq_conta_copartic
										from    pls_conta_copartic_contab b
										where   b.nr_sequencia  = doc_p.nr_doc_analitico)
				and 	not exists ( 	SELECT 	1
										from 	pls_conta_copartic_contab b
										where	a.nr_sequencia 	= b.nr_Seq_conta_copartic
										and	b.nr_sequencia  <> doc_p.nr_doc_analitico);
		end if;
	end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_contab_onl_lote_fin_pck.contab_prov_copart ( doc_p INOUT ctb_documento, nm_usuario_p text) FROM PUBLIC;