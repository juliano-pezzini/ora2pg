-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_contab_onl_lote_fin_pck.contab_aviso_cobranca ( doc_p INOUT ctb_documento, nm_usuario_p text) AS $body$
DECLARE


	dados_contab_w			dados_contab;
	vet_contas_contabeis_w		vet_contas_contabeis;
	nr_seq_conta_w			pls_conta.nr_sequencia%type;
	nr_seq_protocolo_w		pls_protocolo_conta.nr_sequencia%type;
	nr_nota_fiscal_w		pls_prot_conta_titulo.nr_nota_fiscal%type;
	cd_conta_cred_w			pls_conta.cd_conta_cred%type;
	cd_conta_deb_w			pls_conta.cd_conta_deb%type;
	cd_cc_aux_w			pls_conta.cd_conta_cred%type;
	cd_historico_w			pls_conta_proc.cd_historico%type;
	cd_centro_custo_w		w_movimento_contabil.cd_centro_custo%type;
	cd_unimed_origem_w		ptu_aviso_arquivo.cd_unimed_origem%type;
	cd_unimed_destino_w		ptu_aviso_arquivo.cd_unimed_destino%type;
	nr_seq_lote_w			ptu_aviso_arquivo.nr_seq_lote%type;
	nr_guia_principal_w		ptu_aviso_conta.nr_guia_principal%type;
	nr_guia_operadora_w		ptu_aviso_conta.nr_guia_operadora%type;
	nr_guia_prestador_w		ptu_aviso_conta.nr_guia_prestador%type;
	nr_seq_prestador_w		pls_prestador.nr_sequencia%type;
	cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
	cd_cgc_prestador_w		pls_prestador.cd_cgc%type;
	cd_cpf_prestador_w		pessoa_fisica.nr_cpf%type;
	nr_seq_prot_conta_w		pls_protocolo_conta.nr_sequencia%type;
	nr_seq_agrupamento_w		ctb_movimento.nr_seq_agrupamento%type;
	nr_seq_plano_w			pls_conta.nr_seq_plano%type;
	ie_regulamentacao_w		pls_plano.ie_regulamentacao%type;
	nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
	nr_lote_contabil_w		lote_contabil.nr_lote_contabil%type;
	ds_glosa_w			varchar(255);
	ds_conteudo_w			varchar(4000);
	ds_compl_historico_w		varchar(255);
	nm_agrupador_w			varchar(255);
	nm_prestador_w			varchar(255);
	nr_seq_regra_cc_w		bigint;
	qt_atrib_hist_pad_w		integer;

	
BEGIN
	begin
	select  x.cd_unimed_origem,
		x.cd_unimed_destino,
		x.nr_seq_lote,
		x.nr_seq_conta,
		x.nr_guia_principal,
		x.nr_guia_operadora,
		x.nr_guia_prestador,
		coalesce(x.cd_conta_credito, 'X'),
		coalesce(x.cd_conta_debito, 'X'),
		coalesce(x.cd_historico, 0),
		x.nr_seq_prot_conta,
		x.nr_seq_plano,
		x.nr_seq_segurado
	into STRICT    cd_unimed_origem_w,
		cd_unimed_destino_w,
		nr_seq_lote_w,
		nr_seq_conta_w,
		nr_guia_principal_w,
		nr_guia_operadora_w,
		nr_guia_prestador_w,
		cd_conta_cred_w,
		cd_conta_deb_w,
		cd_historico_w,
		nr_seq_prot_conta_w,
		nr_seq_plano_w,
		nr_seq_segurado_w
	from (SELECT  	a.cd_unimed_origem    	cd_unimed_origem,
			a.cd_unimed_destino     cd_unimed_destino,
			a.nr_seq_lote           nr_seq_lote, 
			c.nr_seq_conta          nr_seq_conta,
			c.nr_guia_principal     nr_guia_principal,
			c.nr_guia_operadora     nr_guia_operadora,
			c.nr_guia_prestador     nr_guia_prestador,
			d.cd_conta_credito      cd_conta_credito,
			d.cd_conta_debito       cd_conta_debito,
			d.cd_historico          cd_historico,
			null                    nr_seq_prot_conta,
			null                    nr_seq_plano,
			null                    nr_seq_segurado
		from    ptu_aviso_arquivo a,
			ptu_aviso_protocolo b,
			ptu_aviso_conta c,
			ptu_aviso_procedimento d
		where   c.nr_sequencia			= d.nr_seq_aviso_conta
		and     c.nr_seq_aviso_protocolo	= b.nr_sequencia
		and     a.nr_sequencia			= b.nr_seq_arquivo
		and     doc_p.nm_tabela			= 'PTU_AVISO_PROCEDIMENTO'
		and	doc_p.nr_documento		= a.nr_seq_lote
		and	doc_p.nr_seq_doc_compl		= a.nr_sequencia
		and	doc_p.nr_doc_analitico		= d.nr_sequencia
		
union all

		SELECT  a.cd_unimed_origem      cd_unimed_origem,
			a.cd_unimed_destino     cd_unimed_destino, 
			a.nr_seq_lote           nr_seq_lote, 
			c.nr_seq_conta          nr_seq_conta,
			c.nr_guia_principal     nr_guia_principal,
			c.nr_guia_operadora     nr_guia_operadora,
			c.nr_guia_prestador     nr_guia_prestador,
			d.cd_conta_credito      cd_conta_credito,
			d.cd_conta_debito       cd_conta_debito,
			d.cd_historico          cd_historico,
			null                    nr_seq_prot_conta,
			null                    nr_seq_plano,
			null                    nr_seq_segurado
		from    ptu_aviso_arquivo a,
			ptu_aviso_protocolo b,
			ptu_aviso_conta c,
			ptu_aviso_material d
		where   c.nr_sequencia			= d.nr_seq_aviso_conta
		and     c.nr_seq_aviso_protocolo	= b.nr_sequencia
		and     a.nr_sequencia			= b.nr_seq_arquivo
		and     doc_p.nm_tabela			= 'PTU_AVISO_MATERIAL'
		and	doc_p.nr_documento		= a.nr_seq_lote
		and	doc_p.nr_seq_doc_compl		= a.nr_sequencia
		and	doc_p.nr_doc_analitico		= d.nr_sequencia
		
union all

		select  a.cd_unimed_origem      cd_unimed_origem,
			a.cd_unimed_destino     cd_unimed_destino,
			a.nr_seq_lote           nr_seq_lote, 
			c.nr_seq_conta          nr_seq_conta,
			c.nr_guia_principal     nr_guia_principal,
			c.nr_guia_operadora     nr_guia_operadora,
			c.nr_guia_prestador     nr_guia_prestador,
			e.cd_conta_credito      cd_conta_credito,
			e.cd_conta_debito       cd_conta_debito,
			e.cd_historico          cd_historico,
			f.nr_seq_prot_conta     nr_seq_prot_conta,
			f.nr_seq_plano          nr_seq_plano,
			f.nr_seq_segurado       nr_seq_segurado
		from    ptu_aviso_arquivo a,
			ptu_aviso_protocolo b,
			ptu_aviso_conta c,
			ptu_aviso_procedimento d,
			ptu_aviso_proc_item e,
			pls_conta f
		where   c.nr_sequencia			= d.nr_seq_aviso_conta
		and     c.nr_seq_aviso_protocolo	= b.nr_sequencia
		and     a.nr_sequencia			= b.nr_seq_arquivo
		and     d.nr_sequencia			= e.nr_seq_aviso_procedimento
		and     c.nr_seq_conta			= f.nr_sequencia
		and     doc_p.nm_tabela			= 'PTU_AVISO_PROC_ITEM'
		and	doc_p.nr_documento		= a.nr_seq_lote
		and	doc_p.nr_seq_doc_compl		= a.nr_sequencia
		and	doc_p.nr_doc_analitico		= e.nr_sequencia
		
union all

		select  a.cd_unimed_origem      cd_unimed_origem,
			a.cd_unimed_destino     cd_unimed_destino,
			a.nr_seq_lote           nr_seq_lote, 
			c.nr_seq_conta          nr_seq_conta,
			c.nr_guia_principal     nr_guia_principal,
			c.nr_guia_operadora     nr_guia_operadora,
			c.nr_guia_prestador     nr_guia_prestador,
			e.cd_conta_credito      cd_conta_credito,
			e.cd_conta_debito       cd_conta_debito,
			e.cd_historico          cd_historico,
			f.nr_seq_prot_conta     nr_seq_prot_conta,
			f.nr_seq_plano          nr_seq_plano,
			f.nr_seq_segurado       nr_seq_segurado
		from    ptu_aviso_arquivo a,
			ptu_aviso_protocolo b,
			ptu_aviso_conta c,
			ptu_aviso_material d,
			ptu_aviso_mat_item e,
			pls_conta f
		where   c.nr_sequencia			= d.nr_seq_aviso_conta
		and     c.nr_seq_aviso_protocolo	= b.nr_sequencia
		and     a.nr_sequencia			= b.nr_seq_arquivo
		and     d.nr_sequencia			= e.nr_seq_aviso_material
		and     c.nr_seq_conta			= f.nr_sequencia
		and     doc_p.nm_tabela			= 'PTU_AVISO_MAT_ITEM'
		and	doc_p.nr_documento		= a.nr_seq_lote
		and	doc_p.nr_seq_doc_compl		= a.nr_sequencia
		and	doc_p.nr_doc_analitico		= e.nr_sequencia) x;
	exception when no_data_found then
	/* Salva a inconsistencia: "Nao foi possivel identificar o movimento de origem." */

	select 	obter_desc_expressao(950251)
	into STRICT	doc_p.ds_inconsistencia
	;
	return;
	end;

	/* Se nao houver informacoes de contas contabeis ou de historico, nao segue o processo */

	if (cd_conta_deb_w = 'X' or cd_conta_cred_w = 'X' or cd_historico_w = 0) then
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
	dados_contab_w.cd_historico		:= cd_historico_w;


	/* Numero de agrupamento */

	nr_seq_agrupamento_w			:= nr_seq_lote_w;
	dados_contab_w.nr_seq_agrupamento 	:= nr_seq_agrupamento_w;

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

		/* Obtem nr_seq_protocolo e nr_seq_prestador_exec, informacoes que sao utilizadas no complemento historico */

		select	max(a.nr_seq_protocolo),
			max(a.nr_seq_prestador_exec)
		into STRICT	nr_seq_protocolo_w,
			nr_seq_prestador_w
		from	pls_conta a
		where	nr_sequencia	= nr_seq_conta_w;

		/* Informacoes de PF e PJ utilizadas no complemento historico */

		if (coalesce(nr_seq_prestador_w,0) > 0) then
			select	a.cd_pessoa_fisica,
				a.cd_cgc
			into STRICT	cd_pessoa_fisica_w,
				cd_cgc_prestador_w
			from	pls_prestador a
			where	a.nr_sequencia	= nr_seq_prestador_w;
			
			begin
			nm_prestador_w	:= substr(obter_nome_pf_pj(cd_pessoa_fisica_w, cd_cgc_prestador_w),1,255);
			exception
			when others then
				nm_prestador_w	:= null;
			end;
			
			select	max(nr_cpf)
			into STRICT	cd_cpf_prestador_w
			from	pessoa_fisica
			where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
		end if;

		/* Informacao da regulamentacao e plano, utilizada para obter o centro de custo */

		if (coalesce(nr_seq_plano_w::text, '') = '') then
			begin
			select	b.ie_regulamentacao,
				b.nr_sequencia
			into STRICT	ie_regulamentacao_w,
				nr_seq_plano_w
			from	pls_segurado a,
				pls_plano b
			where	b.nr_sequencia  = a.nr_seq_plano
			and	a.nr_sequencia	= nr_seq_segurado_w;
			exception
			when others then
				ie_regulamentacao_w	:= null;
				nr_seq_plano_w      	:= null;
			end;
		else
			begin
			select	b.ie_regulamentacao
			into STRICT	ie_regulamentacao_w
			from	pls_plano b
			where	b.nr_sequencia  = nr_seq_plano_w;
			exception
			when others then
				ie_regulamentacao_w	:= null;
			end;
		end if;
									

		/* Numero da nota fiscal - Utilizada no complemento historico */

		select	max(nr_nota_fiscal)
		into STRICT	nr_nota_fiscal_w
		from	pls_prot_conta_titulo
		where	nr_sequencia	= nr_seq_prot_conta_w;

		if (doc_p.nm_atributo = 'VL_GLOSA') then
			ds_glosa_w	:= wheb_mensagem_pck.get_texto(1044379);
		end if;

		/* Montagem do complemento historico */

		ds_conteudo_w	:= substr(	cd_cgc_prestador_w		|| '#@' ||
						cd_cpf_prestador_w		|| '#@' ||
						nm_prestador_w			|| '#@' ||
						nr_nota_fiscal_w		|| '#@' ||
						nr_seq_conta_w			|| '#@' ||
						nr_seq_prestador_w		|| '#@' ||
						nr_seq_protocolo_w		|| '#@' ||
						cd_unimed_destino_w		|| '#@' ||
						nr_seq_lote_w			|| '#@' ||
						cd_unimed_origem_w		|| '#@' ||
						nr_guia_principal_w		|| '#@' ||
						nr_guia_operadora_w		|| '#@' ||
						nr_guia_prestador_w		|| '#@' ||
						ds_glosa_w,1,4000);

		begin
		ds_compl_historico_w	:= substr(obter_compl_historico(doc_p.cd_tipo_lote_contabil, dados_contab_w.cd_historico, ds_conteudo_w),1,255);
		exception
		when others then
			ds_compl_historico_w	:= null;
		end;
		dados_contab_w.ds_compl_historico	:= substr(ds_compl_historico_w,1,255);

	end if;

	/* Inverte as contas contabeis caso o movimento seja de glosa */

	if (doc_p.nm_atributo = 'VL_GLOSA') then
		cd_cc_aux_w     := cd_conta_cred_w;
		cd_conta_cred_w := cd_conta_deb_w;
		cd_conta_deb_w  := cd_cc_aux_w;
	end if;

	/* Salva as contas contabeis em um vetor, pois sera feito um insert com cada uma delas*/

	vet_contas_contabeis_w := vet_contas_contabeis();
	vet_contas_contabeis_w.extend(2);
	vet_contas_contabeis_w(1)       := cd_conta_cred_w;
	vet_contas_contabeis_w(2)       := cd_conta_deb_w;
	dados_contab_w.cd_historico     := cd_historico_w;

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

	if (coalesce(doc_p.nr_lote_contabil, 0) <> 0) then
		if (coalesce(doc_p.ds_origem, 'X') = 'ESTORNO') then
			nr_lote_contabil_w := 0;
		else
			nr_lote_contabil_w := doc_p.nr_lote_contabil;
		end if;

		if (doc_p.nm_tabela = 'PTU_AVISO_PROCEDIMENTO' ) then
			update	ptu_aviso_procedimento
			set	nr_lote_contabil = nr_lote_contabil_w
			where	nr_sequencia = doc_p.nr_doc_analitico;
		elsif (doc_p.nm_tabela = 'PTU_AVISO_MATERIAL') then
			update	ptu_aviso_material
			set	nr_lote_contabil = nr_lote_contabil_w
			where	nr_sequencia = doc_p.nr_doc_analitico;
		elsif (doc_p.nm_tabela = 'PTU_AVISO_PROC_ITEM') then
			update	ptu_aviso_proc_item
			set	nr_lote_contabil = nr_lote_contabil_w
			where	nr_sequencia = doc_p.nr_doc_analitico;
		elsif (doc_p.nm_tabela = 'PTU_AVISO_MAT_ITEM') then
			update	ptu_aviso_mat_item
			set	nr_lote_contabil = nr_lote_contabil_w
			where	nr_sequencia = doc_p.nr_doc_analitico;
		end if;
	end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_contab_onl_lote_fin_pck.contab_aviso_cobranca ( doc_p INOUT ctb_documento, nm_usuario_p text) FROM PUBLIC;
