-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW exp_sasc_sasf_v (tp_registro, dt_geracao, hr_geracao, nr_sequencia_reg, nr_atendimento, nm_paciente, nr_mat_paciente, nm_segurado, nr_mat_segurado, tp_acomodacao, tp_procedimento, dt_atendimento, hr_atendimento, dt_internacao, hr_internacao, dt_entrada, dt_alta, hr_alta, cd_cid, ie_indicador_urgencia, ie_hospital_dia, nr_atendimento_senha, cd_autorizacao, cd_convenio_atend, cd_cnpj_hospital, cd_setor_hospital, nr_hospital, dt_nascimento, dt_carteira, nr_cpf, nr_crm_medico, cd_procedimento, vl_procedimento, qt_procedimento, qt_ch, tp_cooperado, ie_funcao_atend, dt_procedimento, hr_procedimento, cd_setor_atendimento, vl_conta, qt_lancamento, nr_interno_conta, ie_funcao_medico, dt_autorizacao) AS select	distinct 0					tp_registro,
	to_char(LOCALTIMESTAMP, 'ddmmyyyy')		dt_geracao,
	to_char(LOCALTIMESTAMP, 'hh24mi')		hr_geracao,
	0					nr_sequencia_reg,
	0					nr_atendimento,
	''				 	nm_paciente,
	''				 	nr_mat_paciente,
	''					nm_segurado,
	''					nr_mat_segurado,
	''					tp_acomodacao,
	1					tp_procedimento,
	''					dt_atendimento,
	''					hr_atendimento,
	''					dt_internacao,
	''					hr_internacao,
	LOCALTIMESTAMP				dt_entrada,
	''					dt_alta,
	''					hr_alta,
	'' 					cd_cid,
	''					ie_indicador_urgencia,
	''					ie_hospital_dia,
	''					nr_atendimento_senha,
	''					cd_autorizacao,
	'0'					cd_convenio_atend,
	''					cd_cnpj_hospital,
	''					cd_setor_hospital,
	''					nr_hospital,
	'' 					dt_nascimento,
	''					dt_carteira,
	''					nr_cpf,
	''					nr_crm_medico,
	''					cd_procedimento,
	''					vl_procedimento,
	''					qt_procedimento,
	''					qt_ch,
	''					tp_cooperado,
	0					ie_funcao_atend,
	''					dt_procedimento,
	''					hr_procedimento,
	''					cd_setor_atendimento,
	''					vl_conta,
	0					qt_lancamento,
	0					nr_interno_conta,
	'0'					ie_funcao_medico,
	''					dt_autorizacao
FROM	atendimento_paciente a
where	exists (select 1
		from conta_paciente b
		where a.nr_atendimento = b.nr_atendimento)

union all

select 	1					tp_registro,
	''					dt_geracao,
	''					hr_geracao,
	0					nr_sequencia_reg,
	a.nr_atendimento			nr_atendimento,
	substr(obter_nome_pf(a.cd_pessoa_fisica),1,50) nm_paciente,
	substr(obter_codigo_usuario_conv(a.nr_atendimento),1,20) nr_mat_paciente,
	substr(obter_nome_pf(a.cd_pessoa_responsavel),1,20) nm_segurado,
	LPAD(' ',20,' ')					nr_mat_segurado,
	substr(obter_tipo_acomodacao_atend(a.nr_atendimento,'C'),1,1) tp_acomodacao,
	1					tp_procedimento,
	to_char(a.dt_entrada, 'ddmmyyyy')	dt_atendimento,
	to_char(a.dt_entrada, 'hhmm')		hr_atendimento,
	to_char(a.dt_entrada, 'ddmmyyyy')	dt_internacao,
	to_char(a.dt_entrada, 'hhmm')		hr_internacao,
	b.dt_periodo_inicial				dt_entrada,
        to_char(a.dt_alta, 'ddmmyyyy')		dt_alta,
	to_char(a.dt_alta, 'hhmm')		hr_alta,
	substr(Obter_cid_princ_atendimento(a.nr_atendimento),1,6) cd_cid,
	'N'					ie_indicador_urgencia,
	'N'					ie_hospital_dia,
	substr(obter_senha_atendimento(a.nr_atendimento),1,20) nr_atendimento_senha,
	substr(obter_guia_convenio(a.nr_atendimento),1,20)	cd_autorizacao,
	LPAD(somente_numero(Obter_Convenio_Atendimento(a.nr_atendimento)),15,0) cd_convenio_atend,
	LPAD(' ',14, ' ')			cd_cnpj_hospital,
	LPAD(0,10,0)				cd_setor_hospital,
	LPAD(0,18,0) 				nr_hospital,
	to_char(obter_data_nascto_pf(a.cd_pessoa_fisica), 'ddmmyyyy') dt_nascimento,
	LPAD(0,8, 0)				dt_carteira,
	''					nr_cpf,
	''					nr_crm_medico,
	''					cd_procedimento,
	''					vl_procedimento,
	''					qt_procedimento,
	''					qt_ch,
	''					tp_cooperado,
	0					ie_funcao_atend,
	''					dt_procedimento,
	''					hr_procedimento,
	''					cd_setor_atendimento,
	''				vl_conta,
	0					qt_lancamento,
	0					nr_interno_conta,
	'0'					ie_funcao_medico,
	'00000000'				dt_autorizacao
from	atendimento_paciente a,
	conta_paciente b
where	exists (select 1
		from 	conta_paciente b,
			procedimento_paciente x
		where 	x.nr_interno_conta = b.nr_interno_conta
		and	a.nr_atendimento = b.nr_atendimento
		and 	obter_se_pasta_honorario(x.ie_responsavel_credito) = 'S')
and a.nr_atendimento = b.nr_atendimento

union all

select	2					tp_registro,
	''					dt_geracao,
	''					hr_geracao,
	0					nr_sequencia_reg,
	a.nr_atendimento			nr_atendimento,
	''				 	nm_paciente,
	''				 	nr_mat_paciente,
	''					nm_segurado,
	''					nr_mat_segurado,
	LPAD(substr(obter_tipo_acomodacao_atend(a.nr_atendimento,'C'),1,4),2,'0') tp_acomodacao,
	1					tp_procedimento,
	''					dt_atendimento,
	''					hr_atendimento,
	''					dt_internacao,
	''					hr_internacao,
	b.dt_periodo_inicial	dt_entrada,
	''					dt_alta,
	''					hr_alta,
	'' 					cd_cid,
	''					ie_indicador_urgencia,
	''					ie_hospital_dia,
	''					nr_atendimento_senha,
	'' 					cd_autorizacao,
	RPAD(somente_numero(Obter_Convenio_Atendimento(a.nr_atendimento)),15,' ') cd_convenio_atend,
	''					cd_cnpj_hospital,
	''					cd_setor_hospital,
	''					nr_hospital,
	'' 					dt_nascimento,
	''					dt_carteira,
	LPAD(coalesce(Obter_Cpf_Pessoa_Fisica(c.cd_medico_executor),0),14,'0') nr_cpf,
	LPAD(coalesce(Obter_CRM_Medico(c.cd_medico_executor),0),6,'0')	nr_crm_medico,
	LPAD(coalesce(c.cd_procedimento,0),8,0)			cd_procedimento,
	LPAD(coalesce(Elimina_Caracteres_Especiais(c.vl_procedimento),0),15,0)		vl_procedimento,
	LPAD(coalesce(c.qt_procedimento,0),5,0)		qt_procedimento,
	LPAD(0,9,0)				qt_ch,
	' '					tp_cooperado,
	CASE WHEN coalesce(c.cd_procedimento,0)=0 THEN 00  ELSE 01 END 					ie_funcao_atend,
	coalesce(to_char(c.dt_procedimento, 'ddmmyyyy'),0)	dt_procedimento,
	coalesce(to_char(c.dt_procedimento, 'hh24:mi'),0)	hr_procedimento,
	coalesce(LPAD(c.cd_setor_atendimento,5,0),0)		cd_setor_atendimento,
	''					vl_conta,
	0					qt_lancamento,
	(lpad(b.nr_interno_conta,10,0))::numeric  nr_interno_conta,
	substr(c.ie_funcao_medico,1,1)		ie_funcao_medico,
	''					dt_autorizacao
FROM atendimento_paciente a, conta_paciente b
LEFT OUTER JOIN procedimento_paciente c ON (b.nr_interno_conta = c.nr_interno_conta)
WHERE a.nr_atendimento = b.nr_atendimento  and ie_responsavel_credito is not null and obter_se_pasta_honorario(ie_responsavel_credito) = 'S'

union all

select	2					tp_registro,
	''					dt_geracao,
	''					hr_geracao,
	0					nr_sequencia_reg,
	a.nr_atendimento			nr_atendimento,
	''				 	nm_paciente,
	''				 	nr_mat_paciente,
	''					nm_segurado,
	''					nr_mat_segurado,
	LPAD(substr(obter_tipo_acomodacao_atend(a.nr_atendimento,'C'),1,4),2,'0') tp_acomodacao,
	1					tp_procedimento,
	''					dt_atendimento,
	''					hr_atendimento,
	''					dt_internacao,
	''					hr_internacao,
	b.dt_periodo_inicial	dt_entrada,
	''					dt_alta,
	''					hr_alta,
	'' 					cd_cid,
	''					ie_indicador_urgencia,
	''					ie_hospital_dia,
	''					nr_atendimento_senha,
	'' 					cd_autorizacao,
	RPAD(somente_numero(Obter_Convenio_Atendimento(a.nr_atendimento)),15,' ') cd_convenio_atend,
	''					cd_cnpj_hospital,
	''					cd_setor_hospital,
	''					nr_hospital,
	'' 					dt_nascimento,
	''					dt_carteira,
	LPAD(coalesce(Obter_Cpf_Pessoa_Fisica(d.cd_pessoa_fisica),0),14,'0') nr_cpf,
	LPAD(coalesce(Obter_CRM_Medico(d.cd_pessoa_fisica),0),6,'0')	nr_crm_medico,
	LPAD(coalesce(c.cd_procedimento,0),8,0)			cd_procedimento,
	LPAD(coalesce(Elimina_Caracteres_Especiais(d.vl_participante),0),15,0)		vl_procedimento,
	LPAD(0,5,0)		qt_procedimento,
	LPAD(0,9,0)				qt_ch,
	' '					tp_cooperado,
	CASE WHEN coalesce(c.cd_procedimento,0)=0 THEN 00  ELSE 01 END 					ie_funcao_atend,
	coalesce(to_char(c.dt_procedimento, 'ddmmyyyy'),0)	dt_procedimento,
	coalesce(to_char(c.dt_procedimento, 'hh24:mi'),0)	hr_procedimento,
	coalesce(LPAD(c.cd_setor_atendimento,5,0),0)		cd_setor_atendimento,
	''					vl_conta,
	0					qt_lancamento,
	(lpad(b.nr_interno_conta,10,0))::numeric 		nr_interno_conta,
	substr(d.ie_funcao,1,1)			ie_funcao_medico,
	''					dt_autorizacao
FROM procedimento_participante d, atendimento_paciente a, conta_paciente b
LEFT OUTER JOIN procedimento_paciente c ON (b.nr_interno_conta = c.nr_interno_conta)
WHERE a.nr_atendimento = b.nr_atendimento  and c.nr_sequencia = d.nr_sequencia and c.ie_responsavel_credito is not null and obter_se_pasta_honorario(c.ie_responsavel_credito) = 'S'
 
union all

select	3					tp_registro,
	''					dt_geracao,
	''					hr_geracao,
	0					nr_sequencia_reg,
	a.nr_atendimento			nr_atendimento,
	''				 	nm_paciente,
	''				 	nr_mat_paciente,
	''					nm_segurado,
	''					nr_mat_segurado,
	''					tp_acomodacao,
	1					tp_procedimento,
	''					dt_atendimento,
	''					hr_atendimento,
	''					dt_internacao,
	''					hr_internacao,
	b.dt_periodo_inicial	dt_entrada,
	''					dt_alta,
	''					hr_alta,
	''					cd_cid,
	''					ie_indicador_urgencia,
	''					ie_hospital_dia,
	''					nr_atendimento_senha,
	'' 					cd_autorizacao,
	RPAD(somente_numero(Obter_Convenio_Atendimento(a.nr_atendimento)),15,' ') cd_convenio_atend,
	''					cd_cnpj_hospital,
	''					cd_setor_hospital,
	''					nr_hospital,
	'' 					dt_nascimento,
	''					dt_carteira,
	''					nr_cpf,
	''					nr_crm_medico,
	''					cd_procedimento,
	''					vl_procedimento,
	''					qt_procedimento,
	''					qt_ch,
	''					tp_cooperado,
	0					ie_funcao_atend,
	''					dt_procedimento,
	''					hr_procedimento,
	''					cd_setor_atendimento,
	substr(Elimina_Caracteres_Especiais(sum(obter_valor_conta(b.nr_interno_conta,0))),1,20)   vl_conta,
	0		qt_lancamento	,
	0					nr_interno_conta,
	'0'					ie_funcao_medico,
	''					dt_autorizacao
from	atendimento_paciente a,
	conta_paciente b
where	a.nr_atendimento = b.nr_atendimento
and	 exists (select 1
		from 	conta_paciente b,
			procedimento_paciente x
		where 	x.nr_interno_conta = b.nr_interno_conta
		and	a.nr_atendimento = b.nr_atendimento
		and 	obter_se_pasta_honorario(x.ie_responsavel_credito) = 'S')
group by b.dt_periodo_inicial, a.nr_atendimento

union all

select	distinct  9					tp_registro,
	''					dt_geracao,
	''					hr_geracao,
	0					nr_sequencia_reg,
	99999999					nr_atendimento,
	''				 	nm_paciente,
	''				 	nr_mat_paciente,
	''					nm_segurado,
	''					nr_mat_segurado,
	''					tp_acomodacao,
	1					tp_procedimento,
	''					dt_atendimento,
	''					hr_atendimento,	
	''					dt_internacao,
	''					hr_internacao,
	LOCALTIMESTAMP					dt_entrada,
	''					dt_alta,
	''					hr_alta,
	'' 					cd_cid,
	''					ie_indicador_urgencia,
	''					ie_hospital_dia,
	''					nr_atendimento_senha,
	''					cd_autorizacao,
	'0'				cd_convenio_atend,
	''					cd_cnpj_hospital,
	''					cd_setor_hospital,
	''					nr_hospital,
	'' 					dt_nascimento,
	''					dt_carteira,
	''					nr_cpf,
	''					nr_crm_medico,
	''					cd_procedimento,
	''					vl_procedimento,
	''					qt_procedimento,
	''					qt_ch,
	''					tp_cooperado,
	0					ie_funcao_atend,
	''					dt_procedimento,
	''					hr_procedimento,
	''					cd_setor_atendimento,
	''					vl_conta,
	0					qt_lancamento,
	0					nr_interno_conta,
	'0'					ie_funcao_medico,
	''					dt_autorizacao
from	atendimento_paciente a
where	exists (select 1
		from conta_paciente b
		where a.nr_atendimento = b.nr_atendimento) ;

