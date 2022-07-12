-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_monitor_qualidade_pck.gera_mensagem_lote ( nr_seq_lote_qualidade_p pls_lote_qualida_monit_ans.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

 
dados_conta_w		pls_monitor_qualidade_pck.dados_conta_qualidade;
dados_data_conta_w	pls_monitor_qualidade_pck.dados_data_conta;
dados_ocor_conta_w	pls_monitor_qualidade_pck.dados_ocor_conta;
dados_item_w		pls_monitor_qualidade_pck.dados_item;
dados_ocor_item_w	pls_monitor_qualidade_pck.dados_ocor_item;
dados_pacote_w		pls_monitor_qualidade_pck.dados_pacote;
dados_ocor_pct_w	pls_monitor_qualidade_pck.dados_ocor_pct;
ds_xml_aux_w		w_pls_monitor_ans_qualid.ds_xml%type;
ds_xml_data_aux_w	varchar(4000);
ds_xml_proc_aux_w	varchar(4000);
ds_xml_ocor_cta_w	varchar(4000);
ds_xml_ocor_item_w	varchar(4000);
ds_xml_ocor_pct_w	varchar(4000);

nr_seq_cta_monit_w	pls_cta_qualid_monit_ans.nr_sequencia%type;
nr_seq_item_monit_w	pls_item_qualid_monit_ans.nr_sequencia%type;
nr_seq_pct_monit_w	pls_pct_qualid_monit_ans.nr_sequencia%type;

C01 CURSOR FOR 
	SELECT	ds_xml 
	from	w_pls_monitor_ans_qualid;
	
BEGIN 
 
for r_C01_w in C01 loop 
	 
	dados_conta_w.cd_cnes 			:= '';
	dados_conta_w.ie_tipo_prestador 	:= '';
	dados_conta_w.cd_cnpj_cpf 		:= '';
	dados_conta_w.cd_guia_prestador 	:= '';
	dados_conta_w.cd_guia_operadora 	:= '';
	dados_conta_w.nr_seq_reembolso 		:= '';
	dados_conta_w.nr_seq_lote_qualidade	:= '';
	 
	dados_conta_w.cd_cnes 			:= pls_monitor_qualidade_pck.obter_valor_tag(r_C01_w.ds_xml,'<CNES>');
	dados_conta_w.ie_tipo_prestador 	:= pls_monitor_qualidade_pck.obter_valor_tag(r_C01_w.ds_xml,'<identificadorExecutante>');
	dados_conta_w.cd_cnpj_cpf 		:= pls_monitor_qualidade_pck.obter_valor_tag(r_C01_w.ds_xml,'<codigoCNPJ_CPF>');
	dados_conta_w.cd_guia_prestador 	:= pls_monitor_qualidade_pck.obter_valor_tag(r_C01_w.ds_xml,'<numeroGuiaPrestador>');
	dados_conta_w.cd_guia_operadora 	:= pls_monitor_qualidade_pck.obter_valor_tag(r_C01_w.ds_xml,'<numeroGuiaOperadora>');
	dados_conta_w.nr_seq_reembolso 		:= pls_monitor_qualidade_pck.obter_valor_tag(r_C01_w.ds_xml,'<identificadorReembolso>');
	dados_conta_w.nr_seq_lote_qualidade	:= nr_seq_lote_qualidade_p;
	 
	nr_seq_cta_monit_w := pls_monitor_qualidade_pck.gera_conta_lote(dados_conta_w, nm_usuario_p, nr_seq_cta_monit_w);
	 
	ds_xml_aux_w := r_C01_w.ds_xml;
	 
	if (position('<lancamentosRegistradosANS>' in ds_xml_aux_w) > 0) and (position('</lancamentosRegistradosANS>' in ds_xml_aux_w) > 0) then 
		 
		ds_xml_data_aux_w := substr(ds_xml_aux_w, position('<lancamentosRegistradosANS>' in ds_xml_aux_w), (position('</lancamentosRegistradosANS>' in ds_xml_aux_w) + 28) - position('<lancamentosRegistradosANS>' in ds_xml_aux_w));
		 
		while(position('<dataProcessamento>' in ds_xml_data_aux_w) > 0) and (position('</dataProcessamento>' in ds_xml_data_aux_w) > 0) loop 
			 
			dados_data_conta_w.nr_seq_cta_monit := '';
			dados_data_conta_w.dt_processamento := '';
			 
			dados_data_conta_w.nr_seq_cta_monit := nr_seq_cta_monit_w;
			dados_data_conta_w.dt_processamento := pls_monitor_qualidade_pck.converte_data(pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_data_aux_w,'<dataProcessamento>'), 'AAAA-MM-DD');
			 
			CALL pls_monitor_qualidade_pck.gerar_data_conta_lote(dados_data_conta_w, nm_usuario_p);
			 
			ds_xml_data_aux_w	:= substr(ds_xml_data_aux_w,position('</dataProcessamento>' in ds_xml_data_aux_w)+20,length(ds_xml_data_aux_w));
		end loop;
		 
		ds_xml_aux_w := substr(ds_xml_aux_w, position('</lancamentosRegistradosANS>' in ds_xml_aux_w) + 28, length(ds_xml_aux_w));
	end if;
	 
	if (position('<dataProcessamento>' in ds_xml_aux_w) > 0) and (position('</dataProcessamento>' in ds_xml_aux_w) > 0) then 
		 
		dados_conta_w.nr_sequencia 	:= '';
		dados_conta_w.dt_processamento 	:= '';
		 
		dados_conta_w.nr_sequencia 	:= nr_seq_cta_monit_w;
		dados_conta_w.dt_processamento 	:= pls_monitor_qualidade_pck.converte_data(pls_monitor_qualidade_pck.obter_valor_tag(r_C01_w.ds_xml,'<dataProcessamento>'), 'AAAA-MM-DD');
		 
		CALL pls_monitor_qualidade_pck.atualiza_data_conta_lote(dados_conta_w);
		 
		ds_xml_aux_w := substr(ds_xml_aux_w, position('</dataProcessamento>' in ds_xml_aux_w) + 20, length(ds_xml_aux_w));
	end if;
	 
	if (position('<ocorrenciasLancamento>' in ds_xml_aux_w) > 0) and (position('</ocorrenciasLancamento>' in ds_xml_aux_w) > 0) then 
		 
		ds_xml_ocor_cta_w := substr(ds_xml_aux_w, position('<ocorrenciasLancamento>' in ds_xml_aux_w), (position('</ocorrenciasLancamento>' in ds_xml_aux_w) + 24) - position('<ocorrenciasLancamento>' in ds_xml_aux_w));
		 
		while(position('<ocorrencia>' in ds_xml_ocor_cta_w) > 0) and (position('</ocorrencia>' in ds_xml_ocor_cta_w) > 0) loop 
			 
			dados_ocor_conta_w.nr_seq_cta_monit	:= '';
			dados_ocor_conta_w.cd_campo 		:= '';
			dados_ocor_conta_w.ds_conteudo 		:= '';
			dados_ocor_conta_w.cd_glosa 		:= '';
			 
			dados_ocor_conta_w.nr_seq_cta_monit	:= nr_seq_cta_monit_w;
			dados_ocor_conta_w.cd_campo 		:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_ocor_cta_w,'<identificadorCampo>');
			dados_ocor_conta_w.ds_conteudo 		:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_ocor_cta_w,'<conteudoCampo>');
			dados_ocor_conta_w.cd_glosa 		:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_ocor_cta_w,'<codigoErro>');
			 
			CALL pls_monitor_qualidade_pck.gerar_ocor_conta_lote(dados_ocor_conta_w, nm_usuario_p);
			 
			ds_xml_ocor_cta_w := substr(ds_xml_ocor_cta_w, position('</ocorrencia>' in ds_xml_ocor_cta_w) + 13, length(ds_xml_ocor_cta_w));
		end loop;
		 
		ds_xml_aux_w := substr(ds_xml_aux_w, position('</ocorrenciasLancamento>' in ds_xml_aux_w) + 24, length(ds_xml_aux_w));
	end if;
	 
	if (position('<itensLancamento>' in ds_xml_aux_w) > 0) and (position('</itensLancamento>' in ds_xml_aux_w) > 0) then 
		 
		while(position('<procedimentoItemAssistencial>' in ds_xml_aux_w) > 0) and (position('</procedimentoItemAssistencial>' in ds_xml_aux_w) > 0) loop 
			 
			dados_item_w.nr_seq_cta_monit	:= '';
			dados_item_w.cd_tabela_ref 	:= '';
			dados_item_w.cd_grupo_proc 	:= '';
			dados_item_w.cd_item	 	:= '';
			dados_item_w.cd_regiao_boca	:= '';
			dados_item_w.cd_dente 		:= '';
			 
			dados_item_w.nr_seq_cta_monit	:= nr_seq_cta_monit_w;
			dados_item_w.cd_tabela_ref 	:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_aux_w, '<codigoTabela>');
			 
			ds_xml_proc_aux_w := substr(ds_xml_aux_w, position('<procedimento>' in ds_xml_aux_w), (position('</procedimento>' in ds_xml_aux_w) + 15) - position('<procedimento>' in ds_xml_aux_w));
			 
			dados_item_w.cd_grupo_proc 	:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_proc_aux_w, '<grupoProcedimento>');			
			dados_item_w.cd_item	 	:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_proc_aux_w, '<codigoProcedimento>');
			dados_item_w.cd_regiao_boca	:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_aux_w, '<denteRegiao>');
			dados_item_w.cd_dente 		:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_aux_w, '<ans:denteFace>');
			 
			nr_seq_item_monit_w := pls_monitor_qualidade_pck.gerar_item_lote( dados_item_w, nm_usuario_p, nr_seq_item_monit_w);
			 
			if (position('<ocorrenciasProcedimentoItemAssistencial>' in ds_xml_aux_w) > 0) and (position('</ocorrenciasProcedimentoItemAssistencial>' in ds_xml_aux_w) > 0) then 
				 
				ds_xml_ocor_item_w := 	substr(ds_xml_aux_w, position('<ocorrenciasProcedimentoItemAssistencial>' in ds_xml_aux_w), (position('</ocorrenciasProcedimentoItemAssistencial>' in ds_xml_aux_w) + 42) 
							- position('<ocorrenciasProcedimentoItemAssistencial>' in ds_xml_aux_w));
				 
				while(position('<ocorrencia>' in ds_xml_ocor_item_w) > 0) and (position('</ocorrencia>' in ds_xml_ocor_item_w) > 0) loop 
					 
					dados_ocor_item_w.nr_seq_item_monit	:= '';
					dados_ocor_item_w.cd_campo 		:= '';
					dados_ocor_item_w.ds_conteudo 		:= '';
					dados_ocor_item_w.cd_glosa 		:= '';
					 
					dados_ocor_item_w.nr_seq_item_monit	:= nr_seq_item_monit_w;
					dados_ocor_item_w.cd_campo 		:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_ocor_item_w,'<identificadorCampo>');
					dados_ocor_item_w.ds_conteudo 		:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_ocor_item_w,'<conteudoCampo>');
					dados_ocor_item_w.cd_glosa 		:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_ocor_item_w,'<codigoErro>');
					 
					CALL pls_monitor_qualidade_pck.gerar_ocor_item_lote( dados_ocor_item_w, nm_usuario_p);
					 
					ds_xml_ocor_item_w := substr(ds_xml_ocor_item_w, position('</ocorrencia>' in ds_xml_ocor_item_w) + 13, length(ds_xml_ocor_item_w));
				end loop;
			end if;
			 
			if (position('<detalhamentoPacote>' in ds_xml_aux_w) > 0) and (position('</detalhamentoPacote>' in ds_xml_aux_w) > 0) then 
				 
				while(position('<pacote>' in ds_xml_aux_w) > 0) and (position('</pacote>' in ds_xml_aux_w) > 0) loop 
					 
					dados_pacote_w.nr_seq_item_monit	:= '';
					dados_pacote_w.cd_tabela_ref 		:= '';
					dados_pacote_w.cd_item 			:= '';
					 
					dados_pacote_w.nr_seq_item_monit	:= nr_seq_item_monit_w;
					dados_pacote_w.cd_tabela_ref 		:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_aux_w, '<codigoTabela>');
					dados_pacote_w.cd_item 			:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_aux_w, '<codigoProcedimento>');
					 
					nr_seq_pct_monit_w := pls_monitor_qualidade_pck.gerar_pacote_lote(dados_pacote_w, nm_usuario_p, nr_seq_pct_monit_w);
					 
					if (position('<ocorrenciasPacote>' in ds_xml_aux_w) > 0) and (position('</ocorrenciasPacote>' in ds_xml_aux_w) > 0) then 
						 
						ds_xml_ocor_pct_w := substr(ds_xml_aux_w, position('<ocorrenciasPacote>' in ds_xml_aux_w), (position('</ocorrenciasPacote>' in ds_xml_aux_w) + 20) - position('<ocorrenciasPacote>' in ds_xml_aux_w));
						 
						while(position('<ocorrencia>' in ds_xml_ocor_pct_w) > 0) and (position('</ocorrencia>' in ds_xml_ocor_pct_w) > 0) loop 
							 
							dados_ocor_pct_w.nr_seq_pct_monit	:= '';
							dados_ocor_pct_w.cd_campo 		:= '';
							dados_ocor_pct_w.ds_conteudo 		:= '';
							dados_ocor_pct_w.cd_glosa 		:= '';
							 
							dados_ocor_pct_w.nr_seq_pct_monit	:= nr_seq_pct_monit_w;
							dados_ocor_pct_w.cd_campo 		:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_ocor_pct_w,'<identificadorCampo>');
							dados_ocor_pct_w.ds_conteudo 		:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_ocor_pct_w,'<conteudoCampo>');
							dados_ocor_pct_w.cd_glosa 		:= pls_monitor_qualidade_pck.obter_valor_tag(ds_xml_ocor_pct_w,'<codigoErro>');
							 
							CALL pls_monitor_qualidade_pck.gerar_ocor_pct_lote(dados_ocor_pct_w, nm_usuario_p);
							 
							ds_xml_ocor_pct_w := substr(ds_xml_ocor_pct_w, position('</ocorrencia>' in ds_xml_ocor_pct_w) + 13, length(ds_xml_ocor_pct_w));
						end loop;
					end if;
					 
					ds_xml_aux_w := substr(ds_xml_aux_w, position('</pacote>' in ds_xml_aux_w) + 9, length(ds_xml_aux_w));
				end loop;
			end if;
			 
			ds_xml_aux_w := substr(ds_xml_aux_w, position('</procedimentoItemAssistencial>' in ds_xml_aux_w) + 31, length(ds_xml_aux_w));
		end loop;
	end if;
end loop;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_monitor_qualidade_pck.gera_mensagem_lote ( nr_seq_lote_qualidade_p pls_lote_qualida_monit_ans.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;