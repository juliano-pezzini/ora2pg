-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_utilizacao_benef_pck.grava_prest_princ_util_benef ( nr_seq_util_benef_p INOUT pls_util_cta_pck.t_number_table, nr_seq_prest_princ_p INOUT pls_util_cta_pck.t_number_table, nr_seq_prest_princ_inter_p INOUT pls_util_cta_pck.t_number_table, cd_medico_princ_p INOUT pls_util_cta_pck.t_varchar2_table_10, ie_origem_conta_p INOUT pls_util_cta_pck.t_varchar2_table_10, ie_tipo_protocolo_p INOUT pls_util_cta_pck.t_varchar2_table_3, cd_pessoa_fisica_reembolso_p INOUT pls_util_cta_pck.t_varchar2_table_10, cd_cnpj_reembolso_p INOUT pls_util_cta_pck.t_varchar2_table_15, nr_seq_cbo_reembolso_p INOUT pls_util_cta_pck.t_number_table, nr_seq_cbo_conta_p INOUT pls_util_cta_pck.t_number_table, ie_commit_p text, ie_esvaziar_tabela_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	grava o prestador e medico principal do atendimento
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [ ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao:

	O prestador e medico principal e levantado pela rotina que chamar esta, e passado por parametro,
	deixando esta rotina aqui responsavel por atualizar os dados relacionados ao prestador e medico principal
	
	Nenhuma selecao de dados deve ser realizada aqui, apenas a atualizacao deles.
	
	Como devem ser listadas as contas de origem de intercambio, e a estrutura faz uma separacao
	para as informacoes de prestador de intercambio, e feito DECODE para jogar a informacao condizente, 
	conforme origem da conta.
	
	e necessario uma atenao especial para os casos de reembolso, pois o prestador talvez nao 
	esteja cadastrado como pls_prestador
	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

-- Joga para o banco
forall i in nr_seq_util_benef_p.first..nr_seq_util_benef_p.last
	update	w_pls_utilizacao_benef
	set	nr_seq_prestador	= nr_seq_prest_princ_p(i),
		nr_seq_prest_inter	= nr_seq_prest_princ_inter_p(i),
		cd_medico		= cd_medico_princ_p(i),
		nr_cpf			= CASE WHEN ie_tipo_protocolo_p(i)='R' THEN  obter_dados_pf(cd_pessoa_fisica_reembolso_p(i), 'CPF')  ELSE CASE WHEN ie_origem_conta_p(i)='A' THEN  pls_obter_dados_prest_inter(nr_seq_prest_princ_inter_p(i), 'CPF')  ELSE pls_obter_dados_prestador(nr_seq_prest_princ_p(i), 'CPF') END  END ,
		cd_cgc			= CASE WHEN ie_tipo_protocolo_p(i)='R' THEN  cd_cnpj_reembolso_p(i)  ELSE CASE WHEN ie_origem_conta_p(i)='A' THEN  pls_obter_dados_prest_inter(nr_seq_prest_princ_inter_p(i), 'CGC')  ELSE pls_obter_dados_prestador(nr_seq_prest_princ_p(i), 'CGC') END  END ,
		cd_municipio_ibge	= substr(CASE WHEN ie_tipo_protocolo_p(i)='R' THEN  obter_dados_pf_pj(cd_pessoa_fisica_reembolso_p(i), cd_cnpj_reembolso_p(i), 'CDMDV')  ELSE CASE WHEN ie_origem_conta_p(i)='A' THEN  pls_obter_dados_prest_inter(nr_seq_prest_princ_inter_p(i), 'IBGE')  ELSE pls_obter_dados_prestador(nr_seq_prest_princ_p(i), 'IBGEC') END  END , 1, 6),
		cd_cbo			= CASE WHEN ie_tipo_protocolo_p(i)='R' THEN  coalesce(obter_codigo_cbo_saude(nr_seq_cbo_reembolso_p(i)), obter_dados_pf(cd_pessoa_fisica_reembolso_p(i), 'CBOS'))  ELSE CASE WHEN ie_origem_conta_p(i)='A' THEN  pls_obter_dados_prest_inter(nr_seq_prest_princ_inter_p(i), 'CBO')  ELSE CASE WHEN pls_obter_dados_prestador(nr_seq_prest_princ_p(i), 'TPR')='PJ' THEN  ''  ELSE coalesce(obter_dados_pf(cd_medico_princ_p(i), 'CBOS'), obter_codigo_cbo_saude(coalesce(pls_obter_cbo_prestador(nr_seq_prest_princ_p(i)), nr_seq_cbo_conta_p(i)))) END  END  END ,
		nr_seq_cbo_saude	= CASE WHEN ie_tipo_protocolo_p(i)='R' THEN  obter_dados_pf(cd_pessoa_fisica_reembolso_p(i), 'CBO')  ELSE CASE WHEN ie_origem_conta_p(i)='A' THEN  pls_obter_dados_prest_inter(nr_seq_prest_princ_inter_p(i), 'CBOS')  ELSE CASE WHEN pls_obter_dados_prestador(nr_seq_prest_princ_p(i), 'TPR')='PJ' THEN  ''  ELSE coalesce(obter_dados_pf(cd_medico_princ_p(i), 'CBO'), coalesce(pls_obter_cbo_prestador(nr_seq_prest_princ_p(i)), nr_seq_cbo_conta_p(i))) END  END  END ,
		ds_prestador		= substr(CASE WHEN ie_tipo_protocolo_p(i)='R' THEN  CASE WHEN cd_pessoa_fisica_reembolso_p(i) = NULL THEN  obter_razao_social(cd_cnpj_reembolso_p(i))  ELSE obter_nome_pf(cd_pessoa_fisica_reembolso_p(i)) END   ELSE CASE WHEN ie_origem_conta_p(i)='A' THEN  pls_obter_dados_prest_inter(nr_seq_prest_princ_inter_p(i), 'N')  ELSE pls_obter_dados_prestador(nr_seq_prest_princ_p(i), 'NF') END  END ,1,250)
	where	nr_sequencia		= nr_seq_util_benef_p(i);
	
-- se foi marcado para commitar
if (coalesce(ie_commit_p, 'N') = 'N') then

	commit;
end if;

-- se foi marcado para esvaziar as tabelas
if (coalesce(ie_esvaziar_tabela_p, 'S') = 'S') then

	nr_seq_util_benef_p.delete;
	nr_seq_prest_princ_p.delete;
	cd_medico_princ_p.delete;
	nr_seq_prest_princ_inter_p.delete;
	ie_origem_conta_p.delete;
	ie_tipo_protocolo_p.delete;
	cd_pessoa_fisica_reembolso_p.delete;
	cd_cnpj_reembolso_p.delete;
	nr_seq_cbo_reembolso_p.delete;
	nr_seq_cbo_conta_p.delete;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_utilizacao_benef_pck.grava_prest_princ_util_benef ( nr_seq_util_benef_p INOUT pls_util_cta_pck.t_number_table, nr_seq_prest_princ_p INOUT pls_util_cta_pck.t_number_table, nr_seq_prest_princ_inter_p INOUT pls_util_cta_pck.t_number_table, cd_medico_princ_p INOUT pls_util_cta_pck.t_varchar2_table_10, ie_origem_conta_p INOUT pls_util_cta_pck.t_varchar2_table_10, ie_tipo_protocolo_p INOUT pls_util_cta_pck.t_varchar2_table_3, cd_pessoa_fisica_reembolso_p INOUT pls_util_cta_pck.t_varchar2_table_10, cd_cnpj_reembolso_p INOUT pls_util_cta_pck.t_varchar2_table_15, nr_seq_cbo_reembolso_p INOUT pls_util_cta_pck.t_number_table, nr_seq_cbo_conta_p INOUT pls_util_cta_pck.t_number_table, ie_commit_p text, ie_esvaziar_tabela_p text) FROM PUBLIC;