-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ecarta_integracao_pck.gerar_arquivo_solicitacao ( pls_solicitacao_p pls_solicitacao_row) AS $body$
DECLARE

	-- variáveis
	doc			xmlDOM.DOMDocument;
	msg_node		xmlDOM.DOMNode;
	corp_node		xmlDOM.DOMNode;
	proc_node		xmlDOM.DOMNode;
	ars_node		xmlDOM.DOMNode;
	arq_node		xmlDOM.DOMNode;
	ar_node			xmlDOM.DOMNode;
	dest_node		xmlDOM.DOMNode;
	item_node		xmlDOM.DOMNode;
	doc_elmt		xmlDOM.DOMElement;
	cdata_sct		xmlDOM.DOMCDATASection;
	--
	nm_arquivo_w		pls_ecarta_arquivo_solic.nm_arquivo%type;
	nm_arquivo_aux_w	pls_ecarta_arquivo_solic.nm_arquivo%type;
	ds_extensao_w		varchar(10);
	ds_caminho_w		pls_ecarta_arquivo_solic.ds_caminho%type;
	exists_w		boolean;
	file_length_w		pls_ecarta_arquivo_solic.qt_tamanho%type;
	blocksize_w		pls_ecarta_arquivo_solic.qt_tamanho%type;

	-- Dados do arquivo
	c01_w CURSOR FOR
	SELECT	a.nm_arquivo,
		a.ds_caminho
	from	pls_ecarta_arquivo_solic a
	where	a.nr_sequencia = current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_arquivo_solic_w')::pls_ecarta_arquivo_solic.nr_sequencia%type;
BEGIN
	-- Seta variáveis globais
	PERFORM set_config('pls_ecarta_integracao_pck.nm_procedimento_w', 'gerar arquivos da solicitação', false);

	-- Cria o documento xml
	doc	 := xmlDOM.newDOMDocument;
	xmlDOM.setVersion(doc, '1.0');

	-- Cria o cabeçalho do documento xml
	msg_node := xmlDOM.makeNode(doc);
	doc_elmt := xmlDOM.createElement(doc, 'Mensagem');
	xmlDOM.setAttribute(doc_elmt, 'xmlns:xs', 'http://www.w3.org/2001/XMLSchema');
	msg_node := xmlDOM.appendChild(msg_node, xmlDOM.makeNode(doc_elmt));
	--
	doc_elmt := xmlDOM.createElement(doc, 'corpoMensagem');
	corp_node := xmlDOM.appendChild(msg_node, xmlDOM.makeNode(doc_elmt));
	--
	doc_elmt := xmlDOM.createElement(doc, 'procCumprimento');
	proc_node := xmlDOM.appendChild(corp_node, xmlDOM.makeNode(doc_elmt));
	--
	doc_elmt := xmlDOM.createElement(doc, 'nuLote');
	item_node := xmlDOM.appendChild(proc_node, xmlDOM.makeNode(doc_elmt));
	cdata_sct := xmlDOM.createCDATASection(doc, current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_lote_w')::pls_ecarta_lote.nr_sequencia%type);
 	item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));
	--
	doc_elmt := xmlDOM.createElement(doc, 'nuContrato');
	item_node := xmlDOM.appendChild(proc_node, xmlDOM.makeNode(doc_elmt));
	cdata_sct := xmlDOM.createCDATASection(doc, current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.nr_contrato_correios);
	item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));
	--
	doc_elmt := xmlDOM.createElement(doc, 'nuCartaoPostagem');
	item_node := xmlDOM.appendChild(proc_node, xmlDOM.makeNode(doc_elmt));
	cdata_sct := xmlDOM.createCDATASection(doc, current_setting('pls_ecarta_integracao_pck.pls_matriz_t')::pls_matriz_r.nr_cartao_postagem);
	item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));
	--
	doc_elmt := xmlDOM.createElement(doc, 'idSpool');
	item_node := xmlDOM.appendChild(proc_node, xmlDOM.makeNode(doc_elmt));
	cdata_sct := xmlDOM.createCDATASection(doc, 'N');
	item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));
	--
	doc_elmt := xmlDOM.createElement(doc, 'nmSpool');
	item_node := xmlDOM.appendChild(proc_node, xmlDOM.makeNode(doc_elmt));
	cdata_sct := xmlDOM.createCDATASection(doc, '');
	item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));


	-- Itens do documento xml
	doc_elmt := xmlDOM.createElement(doc, 'arsCumprimento');
	ars_node := xmlDOM.appendChild(proc_node, xmlDOM.makeNode(doc_elmt));

	-- Processa as solicitações
	for i in pls_solicitacao_p.first..pls_solicitacao_p.last loop
		-- Seta variáveis globais
		PERFORM set_config('pls_ecarta_integracao_pck.nr_seq_ecarta_solicitacao_w', pls_solicitacao_p[i].nr_sequencia, false);
		PERFORM set_config('pls_ecarta_integracao_pck.nr_seq_ecarta_arquivo_solic_w', null, false);

		-- Solicitação possui arquivo?
		if (pls_solicitacao_p[i].ie_arquivo_complementar = 'S') then
			-- Seleciona o arquivo mais recente
			select max(a.nr_sequencia) into STRICT current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_arquivo_solic_w')::pls_ecarta_arquivo_solic.nr_sequencia%type from pls_ecarta_arquivo_solic a where a.nr_seq_ecarta_solicitacao = current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_solicitacao_w')::pls_ecarta_solicitacao.nr_sequencia%type;
			open c01_w;
			fetch c01_w into nm_arquivo_w, ds_caminho_w;
			close c01_w;

			-- Ajusta caminho do arquivo no contexto da função
			ds_caminho_w := pls_ecarta_integracao_pck.ajustar_barra(current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_diretorio_funcao || current_setting('pls_ecarta_integracao_pck.ie_barra_w')::varchar(1) || ds_caminho_w);

			-- Verifica se o arquivo existe
			utl_file.fGetAttr(ds_caminho_w, nm_arquivo_w, exists_w, file_length_w, blocksize_w);
			if	not exists_w then
				CALL wheb_mensagem_pck.exibir_mensagem_abort('O arquivo "' || nm_arquivo_w || '" não existe no diretório "' || ds_caminho_w || '" ou o sistema não possui permissão de acesso!');
			end if;

			-- Copia e renomeia o arquivo para o diretório de temporários
			ds_extensao_w := substr(nm_arquivo_w, instr(nm_arquivo_w, '.', -1, 1), length(nm_arquivo_w));
			nm_arquivo_aux_w := 'e-Carta_' || current_setting('pls_ecarta_integracao_pck.pls_matriz_t')::pls_matriz_r.cd_identificador || '_' || current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_lote_w')::pls_ecarta_lote.nr_sequencia%type || '_' || current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_solicitacao_w')::pls_ecarta_solicitacao.nr_sequencia%type || '_1_complementar' || ds_extensao_w;
			utl_file.fcopy(ds_caminho_w, nm_arquivo_w, current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_dir_temp_comp, nm_arquivo_aux_w);

			-- Adiciona o arquivo na lista de arquivos processados
			PERFORM set_config('pls_ecarta_integracao_pck.qt_arq_w', current_setting('pls_ecarta_integracao_pck.qt_arq_w')::numeric(22) + 1, false);
			current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row(current_setting('pls_ecarta_integracao_pck.qt_arq_w')::numeric(22)).nr_seq_ecarta_solicitacao	:= current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_solicitacao_w')::pls_ecarta_solicitacao.nr_sequencia%type;
			current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row(current_setting('pls_ecarta_integracao_pck.qt_arq_w')::numeric(22)).nr_sequencia			:= current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_arquivo_solic_w')::pls_ecarta_arquivo_solic.nr_sequencia%type;
			current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row(current_setting('pls_ecarta_integracao_pck.qt_arq_w')::numeric(22)).nm_arquivo			:= nm_arquivo_aux_w;
			current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row(current_setting('pls_ecarta_integracao_pck.qt_arq_w')::numeric(22)).ds_caminho			:= current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_dir_temp_comp;
			current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row(current_setting('pls_ecarta_integracao_pck.qt_arq_w')::numeric(22)).ie_excluir			:= 'S';
		end if;

		-- Atributos do lote
		doc_elmt := xmlDOM.createElement(doc, 'AR');
		ar_node := xmlDOM.appendChild(ars_node, xmlDOM.makeNode(doc_elmt));

		-- Atributos da solicitação
		doc_elmt := xmlDOM.createElement(doc, 'cdObjetoCliente');
		item_node := xmlDOM.appendChild(ar_node, xmlDOM.makeNode(doc_elmt));
		cdata_sct := xmlDOM.createCDATASection(doc, current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_solicitacao_w')::pls_ecarta_solicitacao.nr_sequencia%type);
		item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));
		--
		doc_elmt := xmlDOM.createElement(doc, 'DestCumprimento');
		dest_node := xmlDOM.appendChild(ar_node, xmlDOM.makeNode(doc_elmt));
		--
		doc_elmt := xmlDOM.createElement(doc, 'nmDestinatario');
		item_node := xmlDOM.appendChild(dest_node, xmlDOM.makeNode(doc_elmt));
		cdata_sct := xmlDOM.createCDATASection(doc, pls_solicitacao_p[i].nm_destinatario);
		item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));
		--
		doc_elmt := xmlDOM.createElement(doc, 'deEnderecoDest');
		item_node := xmlDOM.appendChild(dest_node, xmlDOM.makeNode(doc_elmt));
		cdata_sct := xmlDOM.createCDATASection(doc, pls_solicitacao_p[i].ds_endereco);
		item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));
		--
		doc_elmt := xmlDOM.createElement(doc, 'nuEnderecoDest');
		item_node := xmlDOM.appendChild(dest_node, xmlDOM.makeNode(doc_elmt));
		cdata_sct := xmlDOM.createCDATASection(doc, pls_solicitacao_p[i].nr_endereco);
		item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));
		--
		doc_elmt := xmlDOM.createElement(doc, 'deComplementoDest');
		item_node := xmlDOM.appendChild(dest_node, xmlDOM.makeNode(doc_elmt));
		cdata_sct := xmlDOM.createCDATASection(doc, pls_solicitacao_p[i].ds_complemento);
		item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));
		--
		doc_elmt := xmlDOM.createElement(doc, 'deBairroDest');
		item_node := xmlDOM.appendChild(dest_node, xmlDOM.makeNode(doc_elmt));
		cdata_sct := xmlDOM.createCDATASection(doc, pls_solicitacao_p[i].ds_bairro);
		item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));
		--
		doc_elmt := xmlDOM.createElement(doc, 'deCidadeDest');
		item_node := xmlDOM.appendChild(dest_node, xmlDOM.makeNode(doc_elmt));
		cdata_sct := xmlDOM.createCDATASection(doc, pls_solicitacao_p[i].ds_municipio);
		item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));
		--
		doc_elmt := xmlDOM.createElement(doc, 'cdUFDest');
		item_node := xmlDOM.appendChild(dest_node, xmlDOM.makeNode(doc_elmt));
		cdata_sct := xmlDOM.createCDATASection(doc, pls_solicitacao_p[i].sg_estado);
		item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));
		--
		doc_elmt := xmlDOM.createElement(doc, 'nuCEPDest');
		item_node := xmlDOM.appendChild(dest_node, xmlDOM.makeNode(doc_elmt));
		cdata_sct := xmlDOM.createCDATASection(doc, pls_solicitacao_p[i].cd_cep);
		item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));
		--
		doc_elmt := xmlDOM.createElement(doc, 'arqCumprimento');
		arq_node := xmlDOM.appendChild(ar_node, xmlDOM.makeNode(doc_elmt));
		--
		doc_elmt := xmlDOM.createElement(doc, 'nmArquivoComplementar');
		item_node := xmlDOM.appendChild(dest_node, xmlDOM.makeNode(doc_elmt));
		cdata_sct := xmlDOM.createCDATASection(doc, nm_arquivo_aux_w);
		item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));
		--
		doc_elmt := xmlDOM.createElement(doc, 'idArquivoComplementar');
		item_node := xmlDOM.appendChild(dest_node, xmlDOM.makeNode(doc_elmt));
		cdata_sct := xmlDOM.createCDATASection(doc, pls_solicitacao_p[i].ie_arquivo_complementar);
		item_node := xmlDOM.appendChild(item_node, xmlDOM.makeNode(cdata_sct));
		--
		doc_elmt := xmlDOM.createElement(doc, 'cdServicoAdicional');
		item_node := xmlDOM.appendChild(dest_node, xmlDOM.makeNode(doc_elmt));
		cdata_sct := xmlDOM.createCDATASection(doc, '');
		item_node := xmlDOM.appendChild(dest_node, xmlDOM.makeNode(cdata_sct));
	end loop;

	-- Define o nome do arquivo xml
	nm_arquivo_w := 'e-Carta_' || current_setting('pls_ecarta_integracao_pck.pls_matriz_t')::pls_matriz_r.cd_identificador || '_' || current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_lote_w')::pls_ecarta_lote.nr_sequencia%type || '_servico.xml';

	-- Salva o arquivo xml
	xmlDOM.writeToFile(doc, current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_dir_temp_comp || current_setting('pls_ecarta_integracao_pck.ie_barra_w')::varchar(1) || nm_arquivo_w, 'UTF-8');
	xmlDOM.freeDocument(doc);

	-- Adiciona o arquivo xml na lista de arquivos processados
	PERFORM set_config('pls_ecarta_integracao_pck.qt_arq_w', current_setting('pls_ecarta_integracao_pck.qt_arq_w')::numeric(22) + 1, false);
	current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row(current_setting('pls_ecarta_integracao_pck.qt_arq_w')::numeric(22)).nm_arquivo := nm_arquivo_w;
	current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row(current_setting('pls_ecarta_integracao_pck.qt_arq_w')::numeric(22)).ds_caminho := current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_dir_temp_comp;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ecarta_integracao_pck.gerar_arquivo_solicitacao ( pls_solicitacao_p pls_solicitacao_row) FROM PUBLIC;