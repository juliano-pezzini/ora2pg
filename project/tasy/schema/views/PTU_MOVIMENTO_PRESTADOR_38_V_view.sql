-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ptu_movimento_prestador_38_v (tp_registro, ie_ordem, ie_ordem_2, nr_sequencia, cd_tipo_registro, cd_unimed_des, cd_unimed_ori, dt_geracao, nr_versao_trans, sg_cons_diretor_tecnico, sg_uf_cons_diretor_tecnico, ie_tipo_rede_min, ie_tipo_prestador, cd_prestador, cd_cgc_cpf402, cd_insc_est, nr_crm, cd_uf_crm, nm_prestador, nm_fantasia, ie_tipo_vinculo, dt_inclusao_uni, dt_exclusao_uni, ie_tipo_contratualizacao, ie_tipo_class_estabelecimento, ie_categoria_diferente, ie_acitente_trabalho, ie_urgencia_emergencia, dt_inicio_serv, dt_inicio_contrato, nr_registro_ans, nm_diretor_tecnico, nr_crm_diretor_tec, ie_tipo_disponibilidade, ie_tabela_propria, cd_perfil_assist_hosp, ie_tipo_produto, ie_guia_medico, ie_registro_cert1, ie_registro_atua1, ie_registro_cert2, ie_registro_atua2, reservado, ie_tipo_endereco, ds_endereco, nr_endereco, ds_complento, ds_bairro, cd_municipio, nr_cep, nr_ddd, nr_fone_1, nr_fone_2, nr_fax, ds_email, ds_endereco_web, cd_cnes, nr_leitos_totais, nr_leito_contrato, nr_leitos_psiquiatria, nr_uti_adulto, nr_uti_neonatal, nr_uti_pediatria, cd_cgc_cpf, cd_grupo_servico, cd_rede, nm_rede, qt_tot_r402, qt_tot_r403, qt_tot_r404, qt_tot_r405, nr_seq_movimento, nr_seq_endereco, cd_espec_1, cd_atua_1, cd_espec_2, cd_atua_2, reservado7, nr_seq_prestador, ie_guia_medico_espec_1, ie_guia_medico_espec_2, ie_guia_medico_atua_1, ie_guia_medico_atua_2, nr_leitos_intermed, ie_filial, cd_imposto, vl_imposto) AS select	/* + USE_CONCAT*/
	1				tp_registro, 
	1				ie_ordem, 
	1				ie_ordem_2, 
	1				nr_sequencia, 
	'401'				cd_tipo_registro, 
	cd_unimed_destino		cd_unimed_des, 
	cd_unimed_origem		cd_unimed_ori, 
	dt_geracao			dt_geracao, 
	15				nr_versao_trans, 
	null				sg_cons_diretor_tecnico, 
	null				sg_uf_cons_diretor_tecnico, 
	null				ie_tipo_rede_min, 
	null				ie_tipo_prestador, 
	null				cd_prestador, 
	null				cd_cgc_cpf402, 
	null				cd_insc_est, 
	null				nr_crm, 
	null				cd_uf_crm, 
	null				nm_prestador, 
	null				nm_fantasia, 
	null				ie_tipo_vinculo, 
	null				dt_inclusao_uni, 
	null				dt_exclusao_uni, 
	null				ie_tipo_contratualizacao, 
	null				ie_tipo_class_estabelecimento, 
	null				ie_categoria_diferente, 
	null				ie_acitente_trabalho, 
	null				ie_urgencia_emergencia, 
	null				dt_inicio_serv, 
	null				dt_inicio_contrato, 
	null				nr_registro_ans, 
	null				nm_diretor_tecnico, 
	null				nr_crm_diretor_tec, 
	null				ie_tipo_disponibilidade, 
	null				ie_tabela_propria, 
	null				cd_perfil_assist_hosp, 
	null				ie_tipo_produto, 
	null				ie_guia_medico, 
	null				ie_registro_cert1, 
	null				ie_registro_atua1, 
	null				ie_registro_cert2, 
	null				ie_registro_atua2, 
	null				reservado, 
	null				ie_tipo_endereco, 
	null				ds_endereco, 
	null				nr_endereco, 
	null				ds_complento, 
	null				ds_bairro, 
	null				cd_municipio, 
	null				nr_cep, 
	null				nr_ddd, 
	null				nr_fone_1, 
	null				nr_fone_2, 
	null				nr_fax, 
	null				ds_email, 
	null				ds_endereco_web, 
	null				cd_cnes, 
	null				nr_leitos_totais, 
	null				nr_leito_contrato, 
	null				nr_leitos_psiquiatria, 
	null				nr_uti_adulto, 
	null				nr_uti_neonatal, 
	null				nr_uti_pediatria, 
	null				cd_cgc_cpf, 
	null				cd_grupo_servico, 
	null				cd_rede, 
	null				nm_rede, 
	null				qt_tot_r402, 
	null				qt_tot_r403, 
	null				qt_tot_r404, 
	null				qt_tot_r405, 
	nr_sequencia			nr_seq_movimento, 
	0				nr_seq_endereco, 
	null				cd_espec_1, 
	null				cd_atua_1, 
	null				cd_espec_2, 
	null				cd_atua_2, 
	null				reservado7, 
	0				nr_seq_prestador, 
	null				ie_guia_medico_espec_1, 
	null				ie_guia_medico_espec_2, 
	null				ie_guia_medico_atua_1, 
	null				ie_guia_medico_atua_2, 
	null				nr_leitos_intermed, 
	null				ie_filial, 
	null				cd_imposto, 
	null				vl_imposto 
FROM	ptu_movimento_prestador 

union all
 
select	2				tp_registro, 
	2				ie_ordem, 
	3				ie_ordem_2, 
	2				nr_sequencia, 
	'402'				cd_tipo_registro, 
	null				cd_unimed_des, 
	null				cd_unimed_ori, 
	null				dt_geracao, 
	null				nr_versao_trans, 
	null				sg_cons_diretor_tecnico, 
	a.sg_uf_cons_diretor_tecnico	sg_uf_cons_diretor_tecnico, 
	a.ie_tipo_rede_min		ie_tipo_rede_min, 
	a.ie_tipo_prestador		ie_tipo_prestador, 
	a.nr_seq_prestador		cd_prestador, 
	null				cd_cgc_cpf402, 
	a.nr_insc_estadual		cd_insc_est, 
	a.nr_crm			nr_crm, 
	a.uf_crm			cd_uf_crm, 
	substr(elimina_acentuacao(a.nm_prestador),1,40)			nm_prestador, 
	substr(elimina_acentuacao(a.nm_fantasia),1,40)			nm_fantasia, 
	a.ie_tipo_vinculo		ie_tipo_vinculo, 
	a.dt_inclusao			dt_inclusao_uni, 
	a.dt_exclusao			dt_exclusao_uni, 
	a.ie_tipo_contratualizacao	ie_tipo_contratualizacao, 
	a.ie_tipo_classif_estab		ie_tipo_class_estabelecimento, 
	a.ie_categoria_dif		ie_categoria_diferente, 
	a.ie_acidente_trabalho		ie_acitente_trabalho, 
	a.ie_urgencia_emerg		ie_urgencia_emergencia, 
	a.dt_inicio_servico		dt_inicio_serv, 
	a.dt_inicio_contrato		dt_inicio_contrato, 
	a.nr_registro_ans		nr_registro_ans, 
	a.nm_diretor_tecnico		nm_diretor_tecnico, 
	a.nr_cons_diretor_tecnico	nr_crm_diretor_tec, 
	a.ie_tipo_disponibilidade	ie_tipo_disponibilidade, 
	a.ie_tabela_propria		ie_tabela_propria, 
	a.ie_perfil_assistencial	cd_perfil_assist_hosp, 
	a.ie_tipo_produto		ie_tipo_produto, 
	CASE WHEN a.ie_tipo_prestador=1 THEN null  ELSE a.ie_guia_medico END 		ie_guia_medico, 
	substr(obter_ptu_especialidade_rce(a.nr_sequencia, 1,'IE_RCE'),1,1)	ie_registro_cert1, 
	substr(obter_ptu_especialidade_rce(a.nr_sequencia, 1,'IE_ATUA'),1,1)	ie_registro_atua1, 
	substr(obter_ptu_especialidade_rce(a.nr_sequencia, 2,'IE_RCE'),1,1)	ie_registro_cert2, 
	substr(obter_ptu_especialidade_rce(a.nr_sequencia, 2,'IE_ATUA'),1,1)	ie_registro_atua2, 
	' '				reservado, 
	null				ie_tipo_endereco, 
	null				ds_endereco, 
	null				nr_endereco, 
	null				ds_complento, 
	null				ds_bairro, 
	null				cd_municipio, 
	null				nr_cep, 
	null				nr_ddd, 
	null				nr_fone_1, 
	null				nr_fone_2, 
	null				nr_fax, 
	null				ds_email, 
	null				ds_endereco_web, 
	null				cd_cnes, 
	null				nr_leitos_totais, 
	null				nr_leito_contrato, 
	null				nr_leitos_psiquiatria, 
	null				nr_uti_adulto, 
	null				nr_uti_neonatal, 
	null				nr_uti_pediatria, 
	a.cd_cgc_cpf			cd_cgc_cpf, 
	null				cd_grupo_servico, 
	null				cd_rede, 
	null				nm_rede, 
	null				qt_tot_r402, 
	null				qt_tot_r403, 
	null				qt_tot_r404, 
	null				qt_tot_r405, 
	a.nr_seq_movimento		nr_seq_movimento, 
	0				nr_seq_endereco, 
	substr(obter_ptu_especialidade_rce(a.nr_sequencia, 1,'CD_ESTA'),1,2) cd_espec_1, 
	lpad(obter_ptu_especialidade_rce(a.nr_sequencia, 1,'NR_RCE'),2,' ') cd_atua_1, 
	substr(obter_ptu_especialidade_rce(a.nr_sequencia, 2,'CD_ESTA'),1,2) cd_espec_2, 
	lpad(obter_ptu_especialidade_rce(a.nr_sequencia, 2,'NR_RCE'),2,' ') cd_atua_2, 
	' '				reservado7, 
	a.nr_sequencia			nr_seq_prestador, 
	substr(obter_ptu_especialidade_rce(a.nr_sequencia, 1,'IE_GUIA_ESPEC'),1,1)	ie_guia_medico_espec_1, 
	substr(obter_ptu_especialidade_rce(a.nr_sequencia, 2,'IE_GUIA_ESPEC'),1,1)	ie_guia_medico_espec_2, 
	substr(obter_ptu_especialidade_rce(a.nr_sequencia, 1,'IE_GUIA_ATUA'),1,1)	ie_guia_medico_atua_1, 
	substr(obter_ptu_especialidade_rce(a.nr_sequencia, 2,'IE_GUIA_ATUA'),1,1)	ie_guia_medico_atua_2, 
	null				nr_leitos_intermed, 
	null				ie_filial, 
	null				cd_imposto, 
	null				vl_imposto 
from	ptu_prestador		a 

union all
 
select	3				tp_registro, 
	2				ie_ordem, 
	3				ie_ordem_2, 
	3				nr_sequencia, 
	'403'				cd_tipo_registro, 
	null				cd_unimed_des, 
	null				cd_unimed_ori, 
	null				dt_geracao, 
	null				nr_versao_trans, 
	null				sg_cons_diretor_tecnico, 
	null				sg_uf_cons_diretor_tecnico, 
	null				ie_tipo_rede_min, 
	null				ie_tipo_prestador, 
	null				cd_prestador, 
	null				cd_cgc_cpf402, 
	null				cd_insc_est, 
	null				nr_crm, 
	null				cd_uf_crm, 
	null				nm_prestador, 
	null				nm_fantasia, 
	null				ie_tipo_vinculo, 
	null				dt_inclusao_uni, 
	null				dt_exclusao_uni, 
	null				ie_tipo_contratualizacao, 
	null				ie_tipo_class_estabelecimento, 
	null				ie_categoria_diferente, 
	null				ie_acitente_trabalho, 
	null				ie_urgencia_emergencia, 
	null				dt_inicio_serv, 
	null				dt_inicio_contrato, 
	null				nr_registro_ans, 
	null				nm_diretor_tecnico, 
	null				nr_crm_diretor_tec, 
	null				ie_tipo_disponibilidade, 
	null				ie_tabela_propria, 
	null				cd_perfil_assist_hosp, 
	null				ie_tipo_produto, 
	null				ie_guia_medico, 
	null				ie_registro_cert1, 
	null				ie_registro_atua1, 
	null				ie_registro_cert2, 
	null				ie_registro_atua2, 
	null				reservado, 
	b.ie_tipo_endereco		ie_tipo_endereco, 
	substr(elimina_acentuacao(b.ds_endereco),1,40)			ds_endereco, 
	b.nr_endereco			nr_endereco, 
	substr(elimina_acentuacao(b.ds_complemento),1,15)		ds_complento, 
	substr(elimina_acentuacao(b.ds_bairro),1,30)			ds_bairro, 
	lpad(b.cd_municipio_ibge,6,'0') || calcula_digito('MODULO10',lpad(b.cd_municipio_ibge,6,'0'))	cd_municipio, 
	b.cd_cep			nr_cep, 
	b.nr_ddd			nr_ddd, 
	b.nr_telefone			nr_fone_1, 
	b.nr_telefone_dois		nr_fone_2, 
	b.nr_fax			nr_fax, 
	substr(elimina_acentuacao(b.ds_email),1,40)			ds_email, 
	substr(elimina_acentuacao(b.ds_endereco_web),1,50)		ds_endereco_web, 
	substr(elimina_acentuacao(b.cd_cnes),1,7)			cd_cnes, 
	b.nr_leitos_totais		nr_leitos_totais, 
	b.nr_leitos_contrat		nr_leito_contrato, 
	b.nr_leitos_psiquiatria		nr_leitos_psiquiatria, 
	b.nr_uti_adulto			nr_uti_adulto, 
	b.nr_uti_neonatal		nr_uti_neonatal, 
	b.nr_uti_pediatria		nr_uti_pediatria, 
	a.cd_cgc_cpf			cd_cgc_cpf, 
	null				cd_grupo_servico, 
	null				cd_rede, 
	null				nm_rede, 
	null				qt_tot_r402, 
	null				qt_tot_r403, 
	null				qt_tot_r404, 
	null				qt_tot_r405, 
	a.nr_seq_movimento		nr_seq_movimento, 
	b.nr_sequencia			nr_seq_endereco, 
	null				cd_espec_1, 
	null				cd_atua_1, 
	null				cd_espec_2, 
	null				cd_atua_2, 
	null				reservado7, 
	a.nr_sequencia			nr_seq_prestador, 
	null				ie_guia_medico_espec_1, 
	null				ie_guia_medico_espec_2, 
	null				ie_guia_medico_atua_1, 
	null				ie_guia_medico_atua_2, 
	c.nr_leitos_intermed		nr_leitos_intermed, 
	'N'				ie_filial, 
	null				cd_imposto, 
	null				vl_imposto 
FROM ptu_prestador_endereco b, ptu_prestador a
LEFT OUTER JOIN pls_prestador_inst_fisica c ON (a.nr_seq_prestador = c.nr_seq_prestador)
WHERE b.nr_seq_prestador	= a.nr_sequencia  
union all
 
select	4				tp_registro, 
	2				ie_ordem, 
	4				ie_ordem_2, 
	4				nr_sequencia, 
	'404'				cd_tipo_registro, 
	null				cd_unimed_des, 
	null				cd_unimed_ori, 
	null				dt_geracao, 
	null				nr_versao_trans, 
	null				sg_cons_diretor_tecnico, 
	null				sg_uf_cons_diretor_tecnico, 
	null				ie_tipo_rede_min, 
	null				ie_tipo_prestador, 
	null				cd_prestador, 
	null				cd_cgc_cpf402, 
	null				cd_insc_est, 
	null				nr_crm, 
	null				cd_uf_crm, 
	null				nm_prestador, 
	null				nm_fantasia, 
	null				ie_tipo_vinculo, 
	null				dt_inclusao_uni, 
	null				dt_exclusao_uni, 
	null				ie_tipo_contratualizacao, 
	null				ie_tipo_class_estabelecimento, 
	null				ie_categoria_diferente, 
	null				ie_acitente_trabalho, 
	null				ie_urgencia_emergencia, 
	null				dt_inicio_serv, 
	null				dt_inicio_contrato, 
	null				nr_registro_ans, 
	null				nm_diretor_tecnico, 
	null				nr_crm_diretor_tec, 
	null				ie_tipo_disponibilidade, 
	null				ie_tabela_propria, 
	null				cd_perfil_assist_hosp, 
	null				ie_tipo_produto, 
	null				ie_guia_medico, 
	null				ie_registro_cert1, 
	null				ie_registro_atua1, 
	null				ie_registro_cert2, 
	null				ie_registro_atua2, 
	null				reservado, 
	null				ie_tipo_endereco, 
	null				ds_endereco, 
	null				nr_endereco, 
	null				ds_complento, 
	null				ds_bairro, 
	null				cd_municipio, 
	null				nr_cep, 
	null				nr_ddd, 
	null				nr_fone_1, 
	null				nr_fone_2, 
	null				nr_fax, 
	null				ds_email, 
	null				ds_endereco_web, 
	null				cd_cnes, 
	null				nr_leitos_totais, 
	null				nr_leito_contrato, 
	null				nr_leitos_psiquiatria, 
	null				nr_uti_adulto, 
	null				nr_uti_neonatal, 
	null				nr_uti_pediatria, 
	null				cd_cgc_cpf, 
	b.cd_grupo_servico		cd_grupo_servico, 
	null				cd_rede, 
	null				nm_rede, 
	null				qt_tot_r402, 
	null				qt_tot_r403, 
	null				qt_tot_r404, 
	null				qt_tot_r405, 
	a.nr_seq_movimento		nr_seq_movimento, 
	b.nr_seq_endereco +1		nr_seq_endereco, 
	null				cd_espec_1, 
	null				cd_atua_1, 
	null				cd_espec_2, 
	null				cd_atua_2, 
	null				reservado7, 
	a.nr_sequencia			nr_seq_prestador, 
	null				ie_guia_medico_espec_1, 
	null				ie_guia_medico_espec_2, 
	null				ie_guia_medico_atua_1, 
	null				ie_guia_medico_atua_2, 
	null				nr_leitos_intermed, 
	null				ie_filial, 
	null				cd_imposto, 
	null				vl_imposto 
from	ptu_prestador			a, 
	ptu_prestador_grupo_serv	b, 
	ptu_prestador_endereco		c 
where	b.nr_seq_endereco	= c.nr_sequencia 
and	c.nr_seq_prestador	= a.nr_sequencia 

union all
 
select	5				tp_registro, 
	2				ie_ordem, 
	0				ie_ordem_2, 
	5				nr_sequencia, 
	'405'				cd_tipo_registro, 
	null				cd_unimed_des, 
	null				cd_unimed_ori, 
	null				dt_geracao, 
	null				nr_versao_trans, 
	null				sg_cons_diretor_tecnico, 
	null				sg_uf_cons_diretor_tecnico, 
	null				ie_tipo_rede_min, 
	null				ie_tipo_prestador, 
	null				cd_prestador, 
	null				cd_cgc_cpf402, 
	null				cd_insc_est, 
	null				nr_crm, 
	null				cd_uf_crm, 
	null				nm_prestador, 
	null				nm_fantasia, 
	null				ie_tipo_vinculo, 
	null				dt_inclusao_uni, 
	null				dt_exclusao_uni, 
	null				ie_tipo_contratualizacao, 
	null				ie_tipo_class_estabelecimento, 
	null				ie_categoria_diferente, 
	null				ie_acitente_trabalho, 
	null				ie_urgencia_emergencia, 
	null				dt_inicio_serv, 
	null				dt_inicio_contrato, 
	null				nr_registro_ans, 
	null				nm_diretor_tecnico, 
	null				nr_crm_diretor_tec, 
	null				ie_tipo_disponibilidade, 
	null				ie_tabela_propria, 
	null				cd_perfil_assist_hosp, 
	null				ie_tipo_produto, 
	null				ie_guia_medico, 
	null				ie_registro_cert1, 
	null				ie_registro_atua1, 
	null				ie_registro_cert2, 
	null				ie_registro_atua2, 
	null				reservado, 
	null				ie_tipo_endereco, 
	null				ds_endereco, 
	null				nr_endereco, 
	null				ds_complento, 
	null				ds_bairro, 
	null				cd_municipio, 
	null				nr_cep, 
	null				nr_ddd, 
	null				nr_fone_1, 
	null				nr_fone_2, 
	null				nr_fax, 
	null				ds_email, 
	null				ds_endereco_web, 
	null				cd_cnes, 
	null				nr_leitos_totais, 
	null				nr_leito_contrato, 
	null				nr_leitos_psiquiatria, 
	null				nr_uti_adulto, 
	null				nr_uti_neonatal, 
	null				nr_uti_pediatria, 
	null				cd_cgc_cpf, 
	null				cd_grupo_servico, 
	substr(elimina_acentuacao(b.cd_rede),1,5)			cd_rede, 
	substr(elimina_acentuacao(b.nm_rede),1,40)			nm_rede, 
	null				qt_tot_r402, 
	null				qt_tot_r403, 
	null				qt_tot_r404, 
	null				qt_tot_r405, 
	a.nr_seq_movimento		nr_seq_movimento, 
	9999999				nr_seq_endereco, 
	null				cd_espec_1, 
	null				cd_atua_1, 
	null				cd_espec_2, 
	null				cd_atua_2, 
	null				reservado7, 
	a.nr_sequencia			nr_seq_prestador, 
	null				ie_guia_medico_espec_1, 
	null				ie_guia_medico_espec_2, 
	null				ie_guia_medico_atua_1, 
	null				ie_guia_medico_atua_2, 
	null				nr_leitos_intermed, 
	null				ie_filial, 
	null				cd_imposto, 
	null				vl_imposto 
from	ptu_prestador_rede_ref	b, 
	ptu_prestador		a 
where	b.nr_seq_prestador	= a.nr_sequencia 

union all
 
select	7				tp_registro, 
	99999999			ie_ordem, 
	7				ie_ordem_2, 
	999999				nr_sequencia, 
	'409'				cd_tipo_registro, 
	null				cd_unimed_des, 
	null				cd_unimed_ori, 
	null				dt_geracao, 
	null				nr_versao_trans, 
	null				sg_cons_diretor_tecnico, 
	null				sg_uf_cons_diretor_tecnico, 
	null				ie_tipo_rede_min, 
	null				ie_tipo_prestador, 
	null				cd_prestador, 
	null				cd_cgc_cpf402, 
	null				cd_insc_est, 
	null				nr_crm, 
	null				cd_uf_crm, 
	null				nm_prestador, 
	null				nm_fantasia, 
	null				ie_tipo_vinculo, 
	null				dt_inclusao_uni, 
	null				dt_exclusao_uni, 
	null				ie_tipo_contratualizacao, 
	null				ie_tipo_class_estabelecimento, 
	null				ie_categoria_diferente, 
	null				ie_acitente_trabalho, 
	null				ie_urgencia_emergencia, 
	null				dt_inicio_serv, 
	null				dt_inicio_contrato, 
	null				nr_registro_ans, 
	null				nm_diretor_tecnico, 
	null				nr_crm_diretor_tec, 
	null				ie_tipo_disponibilidade, 
	null				ie_tabela_propria, 
	null				cd_perfil_assist_hosp, 
	null				ie_tipo_produto, 
	null				ie_guia_medico, 
	null				ie_registro_cert1, 
	null				ie_registro_atua1, 
	null				ie_registro_cert2, 
	null				ie_registro_atua2, 
	null				reservado, 
	null				ie_tipo_endereco, 
	null				ds_endereco, 
	null				nr_endereco, 
	null				ds_complento, 
	null				ds_bairro, 
	null				cd_municipio, 
	null				nr_cep, 
	null				nr_ddd, 
	null				nr_fone_1, 
	null				nr_fone_2, 
	null				nr_fax, 
	null				ds_email, 
	null				ds_endereco_web, 
	null				cd_cnes, 
	null				nr_leitos_totais, 
	null				nr_leito_contrato, 
	null				nr_leitos_psiquiatria, 
	null				nr_uti_adulto, 
	null				nr_uti_neonatal, 
	null				nr_uti_pediatria, 
	null				cd_cgc_cpf, 
	null				cd_grupo_servico, 
	null				cd_rede, 
	null				nm_rede, 
	substr(obter_qt_registro_ptu_a400(nr_sequencia,'402'),1,7)	qt_tot_r402, 
	substr(obter_qt_registro_ptu_a400(nr_sequencia,'403'),1,7)	qt_tot_r403, 
	substr(obter_qt_registro_ptu_a400(nr_sequencia,'404'),1,7)	qt_tot_r404, 
	substr(obter_qt_registro_ptu_a400(nr_sequencia,'405'),1,7)	qt_tot_r405, 
	nr_sequencia			nr_seq_movimento, 
	99999999			nr_seq_endereco, 
	null				cd_espec_1, 
	null				cd_atua_1, 
	null				cd_espec_2, 
	null				cd_atua_2, 
	null				reservado7, 
	99999999			nr_seq_prestador, 
	null				ie_guia_medico_espec_1, 
	null				ie_guia_medico_espec_2, 
	null				ie_guia_medico_atua_1, 
	null				ie_guia_medico_atua_2, 
	null				nr_leitos_intermed, 
	null				ie_filial, 
	null				cd_imposto, 
	null				vl_imposto 
from	ptu_movimento_prestador;

