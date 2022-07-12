-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW sus_bpa_sisrca_v (ie_indicador_linha, tp_registro, ds_cabecalho, dt_processamento, qt_linha, qt_folha, nr_controle, nm_orgao_resp, ds_sigla_resp, nr_cnpj_resp, nm_orgao_destino, ie_orgao_destino, ds_versao, cd_carater_atend, cd_cbo_executor, cd_cep_paciente, cd_cid_principal, cd_cnpj_exec_opme, nr_cns_executor, cd_cns_paciente, nr_seq_equipe, cd_etnia, cd_municipio_ibge, cd_nacionalidade, cd_pessoa_fisica, cd_procedimento, cd_raca_cor, nr_servico, nr_seq_classif, nr_cnes_executor, ddd_fone_pac, nr_autor_estab, ds_bairro, cd_complemento, ds_email, ds_endereco, ds_origem_informacao, ds_registro, dt_competencia, dt_mesano_referencia, dt_nascimento, dt_atendimento, ie_cabecalho, ie_sexo, ie_tipo_bpa, nm_paciente, nm_usuario, nm_usuario_nrec, nr_atendimento, nr_folha_bpa, nr_fone_pac, nr_idade_pac, nr_interno_conta, nr_linha_bpa, nr_endereco, nr_seq_protocolo, nr_sequencia, qt_procedimento, cd_tipo_logradouro, nr_seq_area_eq, nr_telefone) AS select	'01' ie_indicador_linha,
	1 tp_registro,
	'#BPA#' ds_cabecalho,
	to_char(dt_mesano_referencia,'yyyymm') dt_processamento,
	qt_linhas qt_linha,
	qt_folha_bpa qt_folha,
	cd_dominio nr_controle,
	nm_orgao_responsavel nm_orgao_resp,
	cd_orgao_responsavel ds_sigla_resp,
	cd_cgc_responsavel nr_cnpj_resp,
	nm_orgao_destino,
	ie_orgao_destino,
	lpad(ie_versao_bpa,5,0) ds_versao,
	null cd_carater_atend,
	null cd_cbo_executor,
	null cd_cep_paciente,
	null cd_cid_principal,
	null cd_cnpj_exec_opme,
	null nr_cns_executor,
	null cd_cns_paciente,
	null nr_seq_equipe,
	null cd_etnia,
	null cd_municipio_ibge,
	null cd_nacionalidade,
	null cd_pessoa_fisica,
	null cd_procedimento,
	null cd_raca_cor,
	null nr_servico,
	null nr_seq_classif,
	null nr_cnes_executor,
	null ddd_fone_pac,
	null nr_autor_estab,
	null ds_bairro,
	null cd_complemento,
	null ds_email,
	null ds_endereco,
	null ds_origem_informacao,
	null ds_registro,
	null dt_competencia,
	null dt_mesano_referencia,
	null dt_nascimento,
	null dt_atendimento,
	null ie_cabecalho,
	null ie_sexo,
	null ie_tipo_bpa,
	null nm_paciente,
	null nm_usuario,
	null nm_usuario_nrec,
	null nr_atendimento,
	null nr_folha_bpa,
	null nr_fone_pac,
	null nr_idade_pac,
	null nr_interno_conta,
	null nr_linha_bpa,
	null nr_endereco,
	nr_seq_protocolo,
	null nr_sequencia,
	null qt_procedimento,
	null cd_tipo_logradouro,
	' ' nr_seq_area_eq,
	null nr_telefone
FROM	w_susbpa_interf
where	ie_cabecalho = 'C'

union all

select	'02' ie_indicador_linha,
	2 tp_registro,
	'' ds_cabecalho,
	to_char(dt_competencia,'yyyymm') dt_processamento,
	qt_linhas qt_linha,
	qt_folha_bpa qt_folha,
	cd_dominio nr_controle,
	nm_orgao_responsavel nm_orgao_resp,
	cd_orgao_responsavel ds_sigla_resp,
	cd_cgc_responsavel nr_cnpj_resp,
	nm_orgao_destino,
	ie_orgao_destino,
	lpad(ie_versao_bpa,5,0) ds_versao,
	cd_carater_atendimento cd_carater_atend,
	cd_cbo cd_cbo_executor,
	cd_cep cd_cep_paciente,
	cd_cid_proc cd_cid_principal,
	cd_cnpj_fornecedor cd_cnpj_exec_opme,
	cd_cns_medico_exec nr_cns_executor,
	cd_cns_paciente,
	cd_equipe nr_seq_equipe,
	cd_etnia,
	cd_municipio_ibge,
	cd_nacionalidade,
	cd_pessoa_fisica,
	lpad(cd_procedimento,10,0) cd_procedimento,
	cd_raca_cor,
	CASE WHEN coalesce(cd_servico,0)=0 THEN null  ELSE lpad(cd_servico,3,0) END  nr_servico,
	CASE WHEN coalesce(cd_servico_classif,0)=0 THEN null  ELSE lpad(cd_servico_classif,3,0) END  nr_seq_classif,
	lpad(cd_ups,7,0) nr_cnes_executor,
	ddd_fone_pac,
	ds_autorizacao nr_autor_estab,
	ds_bairro,
	ds_compl_logradouro cd_complemento,
	ds_email,
	ds_logradouro ds_endereco,
	ds_origem_informacao,
	ds_registro,
	to_char(dt_competencia,'yyyymm') dt_competencia,
	dt_mesano_referencia,
	to_char(dt_nascimento,'yyyymmdd') dt_nascimento,
	to_char(dt_procedimento,'yyyymmdd') dt_atendimento,
	ie_cabecalho,
	ie_sexo_pac ie_sexo,
	ie_tipo_bpa,
	nm_paciente,
	nm_usuario,
	nm_usuario_nrec,
	nr_atendimento,
	nr_folha_bpa,
	nr_fone_pac,
	lpad(nr_idade_pac,3,0) nr_idade_pac,
	nr_interno_conta,
	nr_linha_folha nr_linha_bpa,
	nr_logradouro nr_endereco,
	nr_seq_protocolo,
	nr_sequencia,
	lpad(qt_procedimento,6,0) qt_procedimento,
	tp_logradouro cd_tipo_logradouro,
	' ' nr_seq_area_eq,
	substr(ddd_fone_pac||nr_fone_pac,1,11) nr_telefone
from	w_susbpa_interf
where	ie_cabecalho = 'P'
and	ie_tipo_bpa = 'C'

union all

select	'03' ie_indicador_linha,
	3 tp_registro,
	'' ds_cabecalho,
	to_char(dt_competencia,'yyyymm') dt_processamento,
	qt_linhas qt_linha,
	qt_folha_bpa qt_folha,
	cd_dominio nr_controle,
	nm_orgao_responsavel nm_orgao_resp,
	cd_orgao_responsavel ds_sigla_resp,
	cd_cgc_responsavel nr_cnpj_resp,
	nm_orgao_destino,
	ie_orgao_destino,
	lpad(ie_versao_bpa,5,0) ds_versao,
	cd_carater_atendimento cd_carater_atend,
	cd_cbo cd_cbo_executor,
	cd_cep cd_cep_paciente,
	cd_cid_proc cd_cid_principal,
	cd_cnpj_fornecedor cd_cnpj_exec_opme,
	cd_cns_medico_exec nr_cns_executor,
	cd_cns_paciente,
	cd_equipe nr_seq_equipe,
	cd_etnia,
	cd_municipio_ibge,
	cd_nacionalidade,
	cd_pessoa_fisica,
	lpad(cd_procedimento,10,0) cd_procedimento,
	cd_raca_cor,
	CASE WHEN coalesce(cd_servico,0)=0 THEN null  ELSE lpad(cd_servico,3,0) END  nr_servico,
	CASE WHEN coalesce(cd_servico_classif,0)=0 THEN null  ELSE lpad(cd_servico_classif,3,0) END  nr_seq_classif,
	lpad(cd_ups,7,0) nr_cnes_executor,
	ddd_fone_pac,
	ds_autorizacao nr_autor_estab,
	ds_bairro,
	ds_compl_logradouro cd_complemento,
	ds_email,
	ds_logradouro ds_endereco,
	ds_origem_informacao,
	ds_registro,
	to_char(dt_competencia,'yyyymm') dt_competencia,
	dt_mesano_referencia,
	to_char(dt_nascimento,'yyyymmdd') dt_nascimento,
	to_char(dt_procedimento,'yyyymmdd') dt_atendimento,
	ie_cabecalho,
	ie_sexo_pac ie_sexo,
	ie_tipo_bpa,
	nm_paciente,
	nm_usuario,
	nm_usuario_nrec,
	nr_atendimento,
	nr_folha_bpa,
	nr_fone_pac,
	lpad(nr_idade_pac,3,0) nr_idade_pac,
	nr_interno_conta,
	nr_linha_folha nr_linha_bpa,
	nr_logradouro nr_endereco,
	nr_seq_protocolo,
	nr_sequencia,
	lpad(qt_procedimento,6,0) qt_procedimento,
	tp_logradouro cd_tipo_logradouro,
	' ' nr_seq_area_eq,
	substr(ddd_fone_pac||nr_fone_pac,1,11) nr_telefone
from	w_susbpa_interf
where	ie_cabecalho = 'P'
and	ie_tipo_bpa = 'I';

