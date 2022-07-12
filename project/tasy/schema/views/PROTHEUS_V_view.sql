-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW protheus_v (tp_registro, z2_filial, z2_datfat, z2_horfat, z2_numlote, z2_codori, z2_origem, z2_instit, z2_codcli, z2_descli, z2_codesp, z2_nomesp, z2_codcon, z2_nomcon, z2_codpla, z2_despla, z2_codpac, z2_nome, z2_datate, z2_horate, z2_matric, z2_nrguia, z2_codcrm, z2_nommed, z2_codpro, z2_tiporec, z2_despro, z2_codgrd, z2_quant, z2_vunit, z2_totch, z2_totval, z2_totrev, z2_numnf, z2_coditem, z2_dtnasc, z2_sexo, ie_tipo, nr_seq_protocolo, cd_ordem) AS select	'10' tp_registro,
	'Z2_FILIAL' z2_filial, 
	'Z2_DATFAT' z2_datfat, 
	'Z2_HORFAT' z2_horfat, 
	'Z2_NUMLOTE' z2_numlote, 
	'Z2_CODORI' z2_codori, 
	'Z2_ORIGEM' z2_origem, 
	'Z2_INSTIT' z2_instit, 
	'Z2_CODCLI' z2_codcli, 
	'Z2_DESCLI' z2_descli, 
	'Z2_CODESP' z2_codesp, 
	'Z2_NOMESP' z2_nomesp, 
	'Z2_CODCON' z2_codcon, 
	'Z2_NOMCON' z2_nomcon, 
	'Z2_CODPLA' z2_codpla, 
	'Z2_DESPLA' z2_despla, 
	'Z2_CODPAC' z2_codpac, 
	'Z2_NOME' z2_nome, 
	'Z2_DATATE' z2_datate, 
	'Z2_HORATE' z2_horate, 
	'Z2_MATRIC' z2_matric, 
	'Z2_NRGUIA' z2_nrguia, 
	'Z2_CODCRM' z2_codcrm, 
	'Z2_NOMMED' z2_nommed, 
	'Z2_CODPRO' z2_codpro, 
	'Z2_TIPOREC' z2_tiporec, 
	'Z2_DESPRO' z2_despro, 
	'Z2_CODGRD' z2_codgrd, 
	'Z2_QUANT' z2_quant, 
	'Z2_VUNIT' z2_vunit, 
	'Z2_TOTCH' z2_totch, 
	'Z2_TOTVAL' z2_totval, 
	'Z2_TOTREV' z2_totrev, 
	'Z2_NUMNF' z2_numnf, 
	'Z2_CODITEM' z2_coditem, 
	'Z2_DTNASC' z2_dtnasc, 
	'Z2_SEXO' z2_sexo, 
	'Cabeçalho' ie_tipo, 
	a.nr_seq_protocolo, 
	0 cd_ordem 
FROM	protocolo_convenio a 

union all
 
select	'20' tp_registro, 
	to_char(a.cd_estabelecimento) z2_filial, 
	to_char(LOCALTIMESTAMP,'dd/mm/yyyy') z2_datfat, 
	to_char(LOCALTIMESTAMP,'hh24:mi') z2_horfat, 
	to_char(a.nr_seq_protocolo) z2_numlote, 
	obter_cgc_estabelecimento(a.cd_estabelecimento) z2_codori, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,60) z2_origem, 
	substr(obter_desc_setor_atend(obter_setor_atendimento(b.nr_atendimento)),1,60) z2_instit, 
	to_char(d.ie_clinica) z2_codcli, 
	obter_valor_dominio(17,d.ie_clinica) z2_descli, 
	to_char(c.cd_especialidade) z2_codesp, -- Apenas Procedimento e Filme 
	substr(obter_nome_especialidade(c.cd_especialidade),1,60) z2_nomesp, -- Apenas Procedimento e Filme 
	to_char(obter_convenio_atendimento(b.nr_atendimento)) z2_codcon, 
	substr(obter_nome_convenio(obter_convenio_atendimento(b.nr_atendimento)),1,40) z2_nomcon, 
	substr(obter_categoria_atendimento(b.nr_atendimento),1,20) z2_codpla, 
	substr(obter_categoria_convenio(obter_convenio_atendimento(b.nr_atendimento), obter_categoria_atendimento(b.nr_atendimento)),1,60) z2_despla, 
	substr(coalesce(e.cd_sistema_ant,e.cd_pessoa_fisica),1,8) z2_codpac, 
	e.nm_pessoa_fisica z2_nome, 
	to_char(d.dt_entrada,'dd/mm/yyyy') z2_datate, 
	to_char(d.dt_entrada,'hh24:mi') z2_horate, 
	obter_dados_categ_conv(b.nr_atendimento, 'U') z2_matric, 
	obter_dados_categ_conv(b.nr_atendimento, 'G') z2_nrguia, 
	substr(obter_nome_medico(c.cd_medico_req, 'CRM'),1,10) z2_codcrm, -- Apenas Procedimento e Filme 
	obter_nome_medico(c.cd_medico_req, 'N') z2_nommed, -- Apenas Procedimento e Filme 
	substr(to_char(c.cd_procedimento),1,10) z2_codpro, -- Procedimento = CD_PROCEDIMENTO, Filme = null, Material = CD_MATERIAL 
	obter_sigla_proc_int_classif(c.nr_seq_proc_interno) z2_tiporec, -- Procedimento = DS_SIGLA, Filme = 'F', Material = 'M' 
	obter_desc_procedimento(c.cd_procedimento,c.ie_origem_proced) z2_despro, -- Procedimento = DS_PROCEDIMENTO, Filme = 'FILME', Material = DS_MATERIAL 
	null z2_codgrd, 
	to_char(c.qt_procedimento) z2_quant, -- Procedimento sem Filme = QT_PROCEDIMENTO, Filme = 1, Material = QT_MATERIAL 
	replace(to_char(c.vl_procedimento),',','.') z2_vunit, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	replace(to_char(c.vl_procedimento),',','.') z2_totch, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	replace(to_char(c.vl_procedimento),',','.') z2_totval, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	replace(to_char(c.vl_procedimento),',','.') z2_totrev, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	null z2_numnf, 
	substr(coalesce(obter_integracao_proc_interno(null,null,c.nr_seq_proc_interno,10),c.nr_seq_proc_interno),1,10) z2_coditem, -- Procedimento = CD_INTEGRACAO, Material = CD_SISTEMA_ANT 
	to_char(e.dt_nascimento,'dd/mm/yyyy') z2_dtnasc, 
	e.ie_sexo z2_sexo, 
	'Procedimento sem Filme' ie_tipo, 
	a.nr_seq_protocolo, 
	4 cd_ordem 
from	protocolo_convenio a, 
	conta_paciente b, 
	procedimento_paciente c, 
	atendimento_paciente d, 
	pessoa_fisica e 
where	b.nr_seq_protocolo = a.nr_seq_protocolo 
and	c.nr_interno_conta = b.nr_interno_conta 
and	c.vl_materiais = 0 
and	c.nr_sequencia <> coalesce(c.nr_seq_proc_pacote,0) 
and	d.nr_atendimento = b.nr_atendimento 
and	e.cd_pessoa_fisica = d.cd_pessoa_fisica 

union all
 
select	'20' tp_registro, 
	to_char(a.cd_estabelecimento) z2_filial, 
	to_char(LOCALTIMESTAMP,'dd/mm/yyyy') z2_datfat, 
	to_char(LOCALTIMESTAMP,'hh24:mi') z2_horfat, 
	to_char(a.nr_seq_protocolo) z2_numlote, 
	obter_cgc_estabelecimento(a.cd_estabelecimento) z2_codori, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,60) z2_origem, 
	substr(obter_desc_setor_atend(obter_setor_atendimento(b.nr_atendimento)),1,60) z2_instit, 
	to_char(d.ie_clinica) z2_codcli, 
	obter_valor_dominio(17,d.ie_clinica) z2_descli, 
	to_char(c.cd_especialidade) z2_codesp, -- Apenas Procedimento e Filme 
	substr(obter_nome_especialidade(c.cd_especialidade),1,60) z2_nomesp, -- Apenas Procedimento e Filme 
	to_char(obter_convenio_atendimento(b.nr_atendimento)) z2_codcon, 
	substr(obter_nome_convenio(obter_convenio_atendimento(b.nr_atendimento)),1,40) z2_nomcon, 
	substr(obter_categoria_atendimento(b.nr_atendimento),1,20) z2_codpla, 
	substr(obter_categoria_convenio(obter_convenio_atendimento(b.nr_atendimento), obter_categoria_atendimento(b.nr_atendimento)),1,60) z2_despla, 
	substr(coalesce(e.cd_sistema_ant,e.cd_pessoa_fisica),1,8) z2_codpac, 
	e.nm_pessoa_fisica z2_nome, 
	to_char(d.dt_entrada,'dd/mm/yyyy') z2_datate, 
	to_char(d.dt_entrada,'hh24:mi') z2_horate, 
	obter_dados_categ_conv(b.nr_atendimento, 'U') z2_matric, 
	obter_dados_categ_conv(b.nr_atendimento, 'G') z2_nrguia, 
	substr(obter_nome_medico(c.cd_medico_req, 'CRM'),1,10) z2_codcrm, -- Apenas Procedimento e Filme 
	obter_nome_medico(c.cd_medico_req, 'N') z2_nommed, -- Apenas Procedimento e Filme 
	substr(to_char(c.cd_procedimento),1,10) z2_codpro, -- Procedimento = CD_PROCEDIMENTO, Filme = null, Material = CD_MATERIAL 
	obter_sigla_proc_int_classif(c.nr_seq_proc_interno) z2_tiporec, -- Procedimento = DS_SIGLA, Filme = 'F', Material = 'M' 
	obter_desc_procedimento(c.cd_procedimento,c.ie_origem_proced) z2_despro, -- Procedimento = DS_PROCEDIMENTO, Filme = 'FILME', Material = DS_MATERIAL 
	null z2_codgrd, 
	to_char(c.qt_procedimento) z2_quant, -- Procedimento sem Filme = QT_PROCEDIMENTO, Filme = 1, Material = QT_MATERIAL 
	replace(to_char(c.vl_procedimento - c.vl_materiais),',','.') z2_vunit, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	replace(to_char(c.vl_procedimento - c.vl_materiais),',','.') z2_totch, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	replace(to_char(c.vl_procedimento - c.vl_materiais),',','.') z2_totval, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	replace(to_char(c.vl_procedimento - c.vl_materiais),',','.') z2_totrev, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	null z2_numnf, 
	substr(coalesce(obter_integracao_proc_interno(null,null,c.nr_seq_proc_interno,10),c.nr_seq_proc_interno),1,10) z2_coditem, -- Procedimento = CD_INTEGRACAO, Material = CD_SISTEMA_ANT 
	to_char(e.dt_nascimento,'dd/mm/yyyy') z2_dtnasc, 
	e.ie_sexo z2_sexo, 
	'Procedimento com Filme' ie_tipo, 
	a.nr_seq_protocolo, 
	2 cd_ordem 
from	protocolo_convenio a, 
	conta_paciente b, 
	procedimento_paciente c, 
	atendimento_paciente d, 
	pessoa_fisica e 
where	b.nr_seq_protocolo = a.nr_seq_protocolo 
and	c.nr_interno_conta = b.nr_interno_conta 
and	c.vl_materiais > 0 
and	c.nr_sequencia <> coalesce(c.nr_seq_proc_pacote,0) 
and	d.nr_atendimento = b.nr_atendimento 
and	e.cd_pessoa_fisica = d.cd_pessoa_fisica 

union all
 
select	'20' tp_registro, 
	to_char(a.cd_estabelecimento) z2_filial, 
	to_char(LOCALTIMESTAMP,'dd/mm/yyyy') z2_datfat, 
	to_char(LOCALTIMESTAMP,'hh24:mi') z2_horfat, 
	to_char(a.nr_seq_protocolo) z2_numlote, 
	obter_cgc_estabelecimento(a.cd_estabelecimento) z2_codori, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,60) z2_origem, 
	substr(obter_desc_setor_atend(obter_setor_atendimento(b.nr_atendimento)),1,60) z2_instit, 
	to_char(d.ie_clinica) z2_codcli, 
	obter_valor_dominio(17,d.ie_clinica) z2_descli, 
	to_char(c.cd_especialidade) z2_codesp, -- Apenas Procedimento e Filme 
	substr(obter_nome_especialidade(c.cd_especialidade),1,60) z2_nomesp, -- Apenas Procedimento e Filme 
	to_char(obter_convenio_atendimento(b.nr_atendimento)) z2_codcon, 
	substr(obter_nome_convenio(obter_convenio_atendimento(b.nr_atendimento)),1,40) z2_nomcon, 
	substr(obter_categoria_atendimento(b.nr_atendimento),1,20) z2_codpla, 
	substr(obter_categoria_convenio(obter_convenio_atendimento(b.nr_atendimento), obter_categoria_atendimento(b.nr_atendimento)),1,60) z2_despla, 
	substr(coalesce(e.cd_sistema_ant,e.cd_pessoa_fisica),1,8) z2_codpac, 
	e.nm_pessoa_fisica z2_nome, 
	to_char(d.dt_entrada,'dd/mm/yyyy') z2_datate, 
	to_char(d.dt_entrada,'hh24:mi') z2_horate, 
	obter_dados_categ_conv(b.nr_atendimento, 'U') z2_matric, 
	obter_dados_categ_conv(b.nr_atendimento, 'G') z2_nrguia, 
	substr(obter_nome_medico(c.cd_medico_req, 'CRM'),1,10) z2_codcrm, -- Apenas Procedimento e Filme 
	obter_nome_medico(c.cd_medico_req, 'N') z2_nommed, -- Apenas Procedimento e Filme 
	null z2_codpro, -- Procedimento = CD_PROCEDIMENTO, Filme = null, Material = CD_MATERIAL 
	'F' z2_tiporec, -- Procedimento = DS_SIGLA, Filme = 'F', Material = 'M' 
	'FILME' z2_despro, -- Procedimento = DS_PROCEDIMENTO, Filme = 'FILME', Material = DS_MATERIAL 
	null z2_codgrd, 
	'1' z2_quant, -- Procedimento sem Filme = QT_PROCEDIMENTO, Filme = 1, Material = QT_MATERIAL 
	replace(to_char(c.vl_materiais),',','.') z2_vunit, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	replace(to_char(c.vl_materiais),',','.') z2_totch, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	replace(to_char(c.vl_materiais),',','.') z2_totval, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	replace(to_char(c.vl_materiais),',','.') z2_totrev, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	null z2_numnf, 
	substr(coalesce(obter_integracao_proc_interno(null,null,c.nr_seq_proc_interno,10),c.nr_seq_proc_interno),1,10) z2_coditem, -- Procedimento = CD_INTEGRACAO, Material = CD_SISTEMA_ANT 
	to_char(e.dt_nascimento,'dd/mm/yyyy') z2_dtnasc, 
	e.ie_sexo z2_sexo, 
	'Filme' ie_tipo, 
	a.nr_seq_protocolo, 
	3 cd_ordem 
from	protocolo_convenio a, 
	conta_paciente b, 
	procedimento_paciente c, 
	atendimento_paciente d, 
	pessoa_fisica e 
where	b.nr_seq_protocolo = a.nr_seq_protocolo 
and	c.nr_interno_conta = b.nr_interno_conta 
and	c.vl_materiais > 0 
and	c.nr_sequencia <> coalesce(c.nr_seq_proc_pacote,0) 
and	d.nr_atendimento = b.nr_atendimento 
and	e.cd_pessoa_fisica = d.cd_pessoa_fisica 

union all
 
select	'20' tp_registro, 
	to_char(a.cd_estabelecimento) z2_filial, 
	to_char(LOCALTIMESTAMP,'dd/mm/yyyy') z2_datfat, 
	to_char(LOCALTIMESTAMP,'hh24:mi') z2_horfat, 
	to_char(a.nr_seq_protocolo) z2_numlote, 
	obter_cgc_estabelecimento(a.cd_estabelecimento) z2_codori, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,60) z2_origem, 
	substr(obter_desc_setor_atend(obter_setor_atendimento(b.nr_atendimento)),1,60) z2_instit, 
	to_char(d.ie_clinica) z2_codcli, 
	obter_valor_dominio(17,d.ie_clinica) z2_descli, 
	null z2_codesp, -- Apenas Procedimento e Filme 
	null z2_nomesp, -- Apenas Procedimento e Filme 
	to_char(obter_convenio_atendimento(b.nr_atendimento)) z2_codcon, 
	substr(obter_nome_convenio(obter_convenio_atendimento(b.nr_atendimento)),1,40) z2_nomcon, 
	substr(obter_categoria_atendimento(b.nr_atendimento),1,20) z2_codpla, 
	substr(obter_categoria_convenio(obter_convenio_atendimento(b.nr_atendimento), obter_categoria_atendimento(b.nr_atendimento)),1,60) z2_despla, 
	substr(coalesce(e.cd_sistema_ant,e.cd_pessoa_fisica),1,8) z2_codpac, 
	e.nm_pessoa_fisica z2_nome, 
	to_char(d.dt_entrada,'dd/mm/yyyy') z2_datate, 
	to_char(d.dt_entrada,'hh24:mi') z2_horate, 
	obter_dados_categ_conv(b.nr_atendimento, 'U') z2_matric, 
	obter_dados_categ_conv(b.nr_atendimento, 'G') z2_nrguia, 
	null z2_codcrm, -- Apenas Procedimento e Filme 
	null z2_nommed, -- Apenas Procedimento e Filme 
	substr(to_char(c.cd_material),1,10) z2_codpro, -- Procedimento = CD_PROCEDIMENTO, Filme = null, Material = CD_MATERIAL 
	'M' z2_tiporec, -- Procedimento = DS_SIGLA, Filme = 'F', Material = 'M' 
	obter_desc_material(c.cd_material) z2_despro, -- Procedimento = DS_PROCEDIMENTO, Filme = 'FILME', Material = DS_MATERIAL 
	null z2_codgrd, 
	replace(to_char(c.qt_material),',','.') z2_quant, -- Procedimento sem Filme = QT_PROCEDIMENTO, Filme = 1, Material = QT_MATERIAL 
	replace(to_char(c.vl_material),',','.') z2_vunit, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	replace(to_char(c.vl_material),',','.') z2_totch, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	replace(to_char(c.vl_material),',','.') z2_totval, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	replace(to_char(c.vl_material),',','.') z2_totrev, -- Procedimento sem Filme = VL_PROCEDIMENTO, Procedimento com Filme = VL_PROCEDIMENTO - VL_MATERIAIS, Filme = VL_MATERIAIS, Material = VL_MATERIAL 
	null z2_numnf, 
	substr(coalesce(obter_dados_material(c.cd_material,'CSA'),c.cd_material),1,10) z2_coditem, -- Procedimento = CD_INTEGRACAO, Material = CD_SISTEMA_ANT 
	to_char(e.dt_nascimento,'dd/mm/yyyy') z2_dtnasc, 
	e.ie_sexo z2_sexo, 
	'Material' ie_tipo, 
	a.nr_seq_protocolo, 
	1 cd_ordem 
from	protocolo_convenio a, 
	conta_paciente b, 
	material_atend_paciente c, 
	atendimento_paciente d, 
	pessoa_fisica e 
where	b.nr_seq_protocolo = a.nr_seq_protocolo 
and	c.nr_interno_conta = b.nr_interno_conta 
and	c.nr_sequencia <> coalesce(c.nr_seq_proc_pacote,0) 
and	d.nr_atendimento = b.nr_atendimento 
and	e.cd_pessoa_fisica = d.cd_pessoa_fisica;
