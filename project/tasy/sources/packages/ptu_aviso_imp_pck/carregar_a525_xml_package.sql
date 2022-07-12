-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Carregar o arquivo A525 de XML
CREATE OR REPLACE PROCEDURE ptu_aviso_imp_pck.carregar_a525_xml ( nr_seq_lote_p ptu_aviso_arq_xml.nr_seq_lote%type, nr_seq_arquivo_p ptu_aviso_arq_xml.nr_seq_arquivo%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
DECLARE

					
-- Contador
nr_guia_w			bigint := 1;
nr_tag_guia_w			bigint := 0;
nr_item_w			bigint := 1;
nr_tag_item_w			bigint := 0;
nr_glosa_w			bigint := 1;
nr_tag_glosa_w			bigint := 0;
					
-- Cabecalho
ds_cabecalho_w			text;
ds_origem_w			text;
ds_destino_w			text;
ds_rec_lote_w			text;
ds_mens_erro_w			text;
ds_prot_w			text;
ds_guia_w			text;
ds_itens_w			text;
ds_glosas_w			text;
ds_ident_w			text;

-- Cabecalho					
nr_seq_ret_arquivo_w		ptu_aviso_ret_arquivo.nr_sequencia%type;
ds_hash_w			ptu_aviso_ret_arquivo.ds_hash%type;
dt_transacao_w			varchar(255);
hr_transacao_w			varchar(255);
cd_cnpj_prest_origem_w		ptu_aviso_ret_arquivo.cd_cnpj_prest_origem%type;
nr_cpf_prest_origem_w		ptu_aviso_ret_arquivo.nr_cpf_prest_origem%type;
cd_prestador_origem_w		ptu_aviso_ret_arquivo.cd_prestador_origem%type;
cd_registro_ans_orig_w		ptu_aviso_ret_arquivo.cd_registro_ans_orig%type;
cd_cnpj_prest_destino_w		ptu_aviso_ret_arquivo.cd_cnpj_prest_destino%type;
nr_cpf_prest_destino_w		ptu_aviso_ret_arquivo.nr_cpf_prest_destino%type;
cd_prestador_destino_w		ptu_aviso_ret_arquivo.cd_prestador_destino%type;
cd_registro_ans_dest_w		ptu_aviso_ret_arquivo.cd_registro_ans_dest%type;
-- Mensagem erro
nr_seq_ret_mens_erro_w		ptu_aviso_ret_mens_erro.nr_sequencia%type;
cd_glosa_mens_erro_w		ptu_aviso_ret_mens_erro.cd_glosa%type;
ds_glosa_mens_erro_w		ptu_aviso_ret_mens_erro.ds_glosa%type;
-- Protocolo
nr_seq_ret_protocolo_w		ptu_aviso_ret_protocolo.nr_sequencia%type;
nr_registro_ans_w		ptu_aviso_ret_protocolo.nr_registro_ans%type;
nr_lote_w			ptu_aviso_ret_protocolo.nr_lote%type;
dt_envio_lote_w			ptu_aviso_ret_protocolo.dt_envio_lote%type;
cd_prestador_w			ptu_aviso_ret_protocolo.cd_prestador%type;
nr_cpf_prestador_w		ptu_aviso_ret_protocolo.nr_cpf_prestador%type;
cd_cnpj_prestador_w		ptu_aviso_ret_protocolo.cd_cnpj_prestador%type;
nm_prestador_w			ptu_aviso_ret_protocolo.nm_prestador%type;
nr_protocolo_w			ptu_aviso_ret_protocolo.nr_protocolo%type;
vl_total_protocolo_w		ptu_aviso_ret_protocolo.vl_total_protocolo%type;
vl_glosa_prot_w			ptu_aviso_ret_protocolo.vl_glosa_prot%type;
cd_cnes_prestador_w		ptu_aviso_ret_protocolo.cd_cnes_prestador%type;
-- Glosa protocolo
nr_seq_ret_glosa_prot_w		ptu_aviso_ret_prot_glosa.nr_sequencia%type;
cd_glosa_prot_w			ptu_aviso_ret_prot_glosa.cd_glosa%type;
ds_glosa_prot_w			ptu_aviso_ret_prot_glosa.ds_glosa%type;
-- Guia
nr_seq_ret_guia_w		ptu_aviso_ret_guia.nr_sequencia%type;
nr_guia_prestador_w		ptu_aviso_ret_guia.nr_guia_prestador%type;
nr_guia_operadora_w		ptu_aviso_ret_guia.nr_guia_operadora%type;
nr_carteira_benef_w		ptu_aviso_ret_guia.nr_carteira_benef%type;
ie_atendimento_rn_w		ptu_aviso_ret_guia.ie_atendimento_rn%type;
nm_beneficiario_w		ptu_aviso_ret_guia.nm_beneficiario%type;
nr_cns_benef_w			ptu_aviso_ret_guia.nr_cns_benef%type;
ie_ident_beneficiario_w		ptu_aviso_ret_guia.ie_ident_beneficiario%type;
dt_realizacao_w			ptu_aviso_ret_guia.dt_realizacao%type;
vl_processado_w			ptu_aviso_ret_guia.vl_processado%type;
vl_glosa_w			ptu_aviso_ret_guia.vl_glosa%type;
vl_liberado_w			ptu_aviso_ret_guia.vl_liberado%type;
-- Glosa guia
nr_seq_ret_glosa_guia_w		ptu_aviso_ret_guia_glosa.nr_sequencia%type;
cd_glosa_guia_w			ptu_aviso_ret_guia_glosa.cd_glosa%type;
ds_glosa_guia_w			ptu_aviso_ret_guia_glosa.ds_glosa%type;
-- Item
nr_seq_ret_item_w		ptu_aviso_ret_item.nr_sequencia%type;
dt_execucao_w			ptu_aviso_ret_item.dt_execucao%type;
hr_inicial_w			ptu_aviso_ret_item.hr_inicial%type;
hr_final_w			ptu_aviso_ret_item.hr_final%type;
cd_tabela_w			ptu_aviso_ret_item.cd_tabela%type;
cd_item_w			ptu_aviso_ret_item.cd_item%type;
ds_item_w			ptu_aviso_ret_item.ds_item%type;
qt_executada_w			ptu_aviso_ret_item.qt_executada%type;
cd_unidade_medida_w		ptu_aviso_ret_item.cd_unidade_medida%type;
cd_despesa_w			ptu_aviso_ret_item.cd_despesa%type;
ie_via_acesso_w			ptu_aviso_ret_item.ie_via_acesso%type;
ie_tecnica_utilizada_w		ptu_aviso_ret_item.ie_tecnica_utilizada%type;
tx_reducao_acrescimo_w		ptu_aviso_ret_item.tx_reducao_acrescimo%type;
vl_unitario_w			ptu_aviso_ret_item.vl_unitario%type;
vl_total_w			ptu_aviso_ret_item.vl_total%type;
vl_glosa_proc_w			ptu_aviso_ret_item.vl_glosa%type;
nr_seq_item_tiss_w		ptu_aviso_ret_item.nr_seq_item_tiss%type;
-- Glosa item
nr_seq_ret_glosa_item_w		ptu_aviso_ret_item_glosa.nr_sequencia%type;
cd_glosa_item_w			ptu_aviso_ret_item_glosa.cd_glosa%type;
ds_glosa_item_w			ptu_aviso_ret_item_glosa.ds_glosa%type;

ie_tipo_transacao_w		varchar(255);

C01 CURSOR FOR
	SELECT	ds_arquivo,
		substr(nm_arquivo,1,3) ie_tipo_nome,
		nm_arquivo
	from	ptu_aviso_arq_xml
	where	nr_seq_lote	= nr_seq_lote_p
	and	ie_tipo_arquivo	= 'A525';
	
BEGIN

for r_C01_w in C01 loop
	-- Cabecalho XML
	ds_cabecalho_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(r_C01_w.ds_arquivo,'ans:cabecalho',1);
	ds_origem_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_cabecalho_w,'ans:origem',1);
	ds_destino_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_cabecalho_w,'ans:destino',1);
	ds_ident_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_cabecalho_w,'ans:identificacaoTransacao',1);
	
	-- Origem
	cd_cnpj_prest_origem_w	:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_origem_w,'ans:CNPJ',1);
	nr_cpf_prest_origem_w	:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_origem_w,'ans:cpf',1);
	cd_prestador_origem_w	:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_origem_w,'ans:codigoPrestadorNaOperadora',1);
	cd_registro_ans_orig_w	:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_origem_w,'ans:registroANS',1);
	
	-- Destino
	cd_cnpj_prest_destino_w	:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_destino_w,'ans:CNPJ',1);
	nr_cpf_prest_destino_w	:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_destino_w,'ans:cpf',1);
	cd_prestador_destino_w	:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_destino_w,'ans:codigoPrestadorNaOperadora',1);
	cd_registro_ans_dest_w	:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_destino_w,'ans:registroANS',1);

	dt_transacao_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_cabecalho_w,'ans:dataRegistroTransacao',1);
	hr_transacao_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_cabecalho_w,'ans:horaRegistroTransacao',1);
	ds_hash_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(r_C01_w.ds_arquivo,'ans:hash',1);
	ie_tipo_transacao_w	:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_ident_w,'ans:tipoTransacao',1);
	
	-- Gerar erro se o arquivo nao for A525
	if (ie_tipo_transacao_w != 'PROTOCOLO_RECEBIMENTO') and (r_C01_w.ie_tipo_nome != 'AVR') then -- AVR e como comeca o nome do arquivo A525
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1053601);
	end if;
	
	-- Inserir arquivo A525
		nr_seq_ret_arquivo_w := ptu_aviso_imp_pck.inserir_a525_arquivo(	nr_seq_ret_arquivo_w, nm_usuario_p, nr_seq_arquivo_p, null, clock_timestamp(), ds_hash_w, dt_transacao_w, hr_transacao_w, cd_cnpj_prest_origem_w, nr_cpf_prest_origem_w, cd_prestador_origem_w, cd_registro_ans_orig_w, cd_cnpj_prest_destino_w, nr_cpf_prest_destino_w, cd_prestador_destino_w, cd_registro_ans_dest_w, r_C01_w.nm_arquivo);
	
	-- Isolar recebimento lote
	ds_rec_lote_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(r_C01_w.ds_arquivo,'ans:recebimentoLote',1);
	
	-- Mensagem de erro do arquivo
	nr_tag_glosa_w := ptu_aviso_imp_pck.obter_numero_tag(ds_rec_lote_w,'ans:mensagemErro');
	while(nr_glosa_w <= nr_tag_glosa_w) loop
		ds_mens_erro_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_rec_lote_w,'ans:mensagemErro',nr_glosa_w);
		cd_glosa_mens_erro_w	:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_mens_erro_w,'ans:codigoGlosa',1);
		ds_glosa_mens_erro_w	:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_mens_erro_w,'ans:descricaoGlosa',1);
		
		-- Inserir mensagem erro A525
		 nr_seq_ret_glosa_item_w := ptu_aviso_imp_pck.inserir_a525_mens_erro( nr_seq_ret_glosa_item_w, nm_usuario_p, nr_seq_ret_guia_w, cd_glosa_item_w, ds_glosa_item_w);
	
		nr_glosa_w := nr_glosa_w + 1;
	end loop;
	nr_glosa_w := 1;
	
	-- Protocolo
	ds_prot_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_rec_lote_w,'ans:protocoloRecebimento',1);
	nr_registro_ans_w	:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_prot_w,'ans:registroANS',1);
	nr_lote_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_prot_w,'ans:numeroLote',1);
	dt_envio_lote_w		:= ptu_aviso_imp_pck.converte_data(ptu_aviso_imp_pck.obter_conteudo_tag(ds_prot_w,'ans:dataEnvioLote',1));
	cd_prestador_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_prot_w,'ans:codigoPrestadorNaOperadora',1);
	nr_cpf_prestador_w	:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_prot_w,'ans:cpfContratado',1);
	cd_cnpj_prestador_w	:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_prot_w,'ans:cnpjContratado',1);
	nm_prestador_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_prot_w,'ans:nomeContratado',1);
	nr_protocolo_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_prot_w,'ans:numeroProtocolo',1);
	vl_total_protocolo_w	:= ptu_aviso_imp_pck.converte_numero(ptu_aviso_imp_pck.obter_conteudo_tag(ds_prot_w,'ans:valorTotalProtocolo',1));
	vl_glosa_prot_w		:= ptu_aviso_imp_pck.converte_numero(ptu_aviso_imp_pck.obter_conteudo_tag(ds_prot_w,'ans:vlGlosaProtocolo',1));
	cd_cnes_prestador_w	:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_prot_w,'ans:CNES',1);
	
	-- Inserir protocolo A525
		nr_seq_ret_protocolo_w := ptu_aviso_imp_pck.inserir_a525_protocolo(	nr_seq_ret_protocolo_w, nm_usuario_p, nr_seq_ret_arquivo_w, null, nr_registro_ans_w, nr_lote_w, dt_envio_lote_w, cd_prestador_w, nr_cpf_prestador_w, cd_cnpj_prestador_w, nm_prestador_w, nr_protocolo_w, vl_total_protocolo_w, vl_glosa_prot_w);
				
	-- Glosa protocolo
	nr_tag_glosa_w := ptu_aviso_imp_pck.obter_numero_tag(ds_prot_w,'ans:glosaProtocolo');
	while(nr_glosa_w <= nr_tag_glosa_w) loop
		ds_glosas_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_prot_w,'ans:glosaProtocolo',nr_glosa_w);
		cd_glosa_prot_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_glosas_w,'ans:codigoGlosa',1);
		ds_glosa_prot_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_glosas_w,'ans:descricaoGlosa',1);
		
		-- Inserir glosa protocolo A525
			nr_seq_ret_glosa_prot_w := ptu_aviso_imp_pck.inserir_a525_protocolo_glosa(	nr_seq_ret_glosa_prot_w, nm_usuario_p, nr_seq_ret_protocolo_w, cd_glosa_prot_w, ds_glosa_prot_w);
	
		nr_glosa_w := nr_glosa_w + 1;
	end loop;
	nr_glosa_w := 1;
				
	-- Guias
	nr_tag_guia_w		:= ptu_aviso_imp_pck.obter_numero_tag(ds_prot_w,'ans:dadosGuiasProtocolo');
	while(nr_guia_w <= nr_tag_guia_w) loop
		ds_guia_w			:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_prot_w,'ans:dadosGuiasProtocolo',nr_guia_w);
		nr_guia_prestador_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_guia_w,'ans:numeroGuiaPrestador',1);
		nr_guia_operadora_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_guia_w,'ans:numeroGuiaOperadora',1);
		nr_carteira_benef_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_guia_w,'ans:numeroCarteira',1);
		ie_atendimento_rn_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_guia_w,'ans:atendimentoRN',1);
		nm_beneficiario_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_guia_w,'ans:nomeBeneficiario',1);
		nr_cns_benef_w			:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_guia_w,'ans:numeroCNS',1);
		ie_ident_beneficiario_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_guia_w,'ans:identificadorBeneficiario',1);
		dt_realizacao_w			:= ptu_aviso_imp_pck.converte_data(ptu_aviso_imp_pck.obter_conteudo_tag(ds_guia_w,'ans:dataRealizacao',1));
		vl_processado_w			:= ptu_aviso_imp_pck.converte_numero(ptu_aviso_imp_pck.obter_conteudo_tag(ds_guia_w,'ans:valorProcessado',1));
		vl_glosa_w			:= ptu_aviso_imp_pck.converte_numero(ptu_aviso_imp_pck.obter_conteudo_tag(ds_guia_w,'ans:valorGlosa',1));
		vl_liberado_w			:= ptu_aviso_imp_pck.converte_numero(ptu_aviso_imp_pck.obter_conteudo_tag(ds_guia_w,'ans:valorLiberado',1));
		
		-- Inserir guia A525
			nr_seq_ret_guia_w := ptu_aviso_imp_pck.inserir_a525_guia(	nr_seq_ret_guia_w, nm_usuario_p, nr_seq_ret_protocolo_w, nr_guia_prestador_w, nr_guia_operadora_w, nr_carteira_benef_w, ie_atendimento_rn_w, nm_beneficiario_w, nr_cns_benef_w, ie_ident_beneficiario_w, dt_realizacao_w, vl_glosa_w, vl_liberado_w, vl_processado_w);
					
		-- Glosa guia
		nr_tag_glosa_w := ptu_aviso_imp_pck.obter_numero_tag(ds_guia_w,'ans:glosaGuia');
		while(nr_glosa_w <= nr_tag_glosa_w) loop
			ds_glosas_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_guia_w,'ans:glosaGuia',nr_glosa_w);
			cd_glosa_guia_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_glosas_w,'ans:codigoGlosa',1);
			ds_glosa_guia_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_glosas_w,'ans:descricaoGlosa',1);
			
			-- Inserir glosa guia A525
			 nr_seq_ret_glosa_guia_w := ptu_aviso_imp_pck.inserir_a525_guia_glosa( nr_seq_ret_glosa_guia_w, nm_usuario_p, nr_seq_ret_guia_w, cd_glosa_guia_w, ds_glosa_guia_w);
		
			nr_glosa_w := nr_glosa_w + 1;
		end loop;
		nr_glosa_w := 1;
					
		-- Itens
		nr_tag_item_w		:= ptu_aviso_imp_pck.obter_numero_tag(ds_guia_w,'ans:procedimentoRealizado');
		while(nr_item_w <= nr_tag_item_w) loop
			ds_itens_w			:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_guia_w,'ans:procedimentoRealizado',nr_item_w);
			dt_execucao_w			:= ptu_aviso_imp_pck.converte_data(ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:dataExecucao',1));
			hr_inicial_w			:= ptu_aviso_imp_pck.converte_data_hora(dt_execucao_w,ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:horaInicial',1));
			hr_final_w			:= ptu_aviso_imp_pck.converte_data_hora(dt_execucao_w,ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:horaFinal',1));
			cd_tabela_w			:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:codigoTabela',1);
			cd_item_w			:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:codigoProcedimento',1);
			ds_item_w			:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:descricaoProcedimento',1);
			qt_executada_w			:= ptu_aviso_imp_pck.converte_numero(ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:quantidadeExecutada',1));
			cd_unidade_medida_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:unidadeMedida',1);
			cd_despesa_w			:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:codigoDespesa',1);
			ie_via_acesso_w			:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:viaAcesso',1);
			ie_tecnica_utilizada_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:tecnicaUtilizada',1);
			tx_reducao_acrescimo_w		:= ptu_aviso_imp_pck.converte_numero(ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:fatorReducaoAcrescimo',1));
			vl_unitario_w			:= ptu_aviso_imp_pck.converte_numero(ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:valorUnitario',1));
			vl_total_w			:= ptu_aviso_imp_pck.converte_numero(ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:valorTotal',1));
			vl_glosa_proc_w			:= ptu_aviso_imp_pck.converte_numero(ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:valorGlosaProcedimento',1));
			nr_seq_item_tiss_w		:= ptu_aviso_imp_pck.converte_numero(ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:sequencialItem',1));
			
			-- Inserir item A525
			 	nr_seq_ret_item_w := ptu_aviso_imp_pck.inserir_a525_item( 	nr_seq_ret_item_w, nm_usuario_p, nr_seq_ret_guia_w, dt_execucao_w, hr_inicial_w, hr_final_w, cd_tabela_w, cd_item_w, ds_item_w, qt_executada_w, cd_unidade_medida_w, cd_despesa_w, ie_via_acesso_w, ie_tecnica_utilizada_w, tx_reducao_acrescimo_w, vl_unitario_w, vl_total_w, vl_glosa_proc_w, nr_seq_item_tiss_w);
						
			-- Glosa item
			nr_tag_glosa_w := ptu_aviso_imp_pck.obter_numero_tag(ds_itens_w,'ans:glosaGuia');
			while(nr_glosa_w <= nr_tag_glosa_w) loop
				ds_glosas_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_itens_w,'ans:glosaGuia',nr_glosa_w);
				cd_glosa_item_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_glosas_w,'ans:codigoGlosa',1);
				ds_glosa_item_w		:= ptu_aviso_imp_pck.obter_conteudo_tag(ds_glosas_w,'ans:descricaoGlosa',1);
				
				-- Inserir glosa item A525
				 nr_seq_ret_glosa_item_w := ptu_aviso_imp_pck.inserir_a525_item_glosa( nr_seq_ret_glosa_item_w, nm_usuario_p, nr_seq_ret_guia_w, cd_glosa_item_w, ds_glosa_item_w);
			
				nr_glosa_w := nr_glosa_w + 1;
			end loop;
			nr_glosa_w := 1;
		
			nr_item_w := nr_item_w + 1;
		end loop;
		nr_item_w := 1;
		
		nr_guia_w := nr_guia_w + 1;
	end loop;
	nr_guia_w := 1;
end loop;

commit;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_aviso_imp_pck.carregar_a525_xml ( nr_seq_lote_p ptu_aviso_arq_xml.nr_seq_lote%type, nr_seq_arquivo_p ptu_aviso_arq_xml.nr_seq_arquivo%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;