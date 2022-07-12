-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW escalacao_profissional_v (cd_unidade, nm_pessoa_fisica, nm_enfermeiro_resp, nm_medico_resp, nm_psicologo_resp, nm_nutricionista_resp, nm_farmaceutico_resp, nm_fisioterapeuta_resp, nm_assistente_resp, nm_enf_resp, nm_manejador_resp, nr_atendimento, nr_seq_enfermeiro_resp, nr_seq_medico_resp, nr_seq_psicologo_resp, nr_seq_nutricionista_resp, nr_seq_farmaceutico_resp, nr_seq_fisioterapeuta_resp, nr_seq_assistente_resp, nr_seq_enf_resp, nr_seq_manejador_resp, cd_setor_atendimento, cd_estabelecimento, nr_seq_nursing_team, nm_nursing_team, cd_pessoa_fisica) AS select   cd_unidade,
         substr(obter_nome_pf(cd_pessoa_fisica),1,60) nm_pessoa_fisica,
         substr(obter_enfermeiro_resp(nr_atendimento,'N'),1,60) nm_enfermeiro_resp,
         substr(obter_profissional_atend(nr_atendimento,'M','N'),1,60) nm_medico_resp,
         substr(obter_profissional_atend(nr_atendimento,'P','N'),1,60) nm_psicologo_resp,
         substr(obter_profissional_atend(nr_atendimento,'N','N'),1,60) nm_nutricionista_resp,
         substr(obter_profissional_atend(nr_atendimento,'F','N'),1,60) nm_farmaceutico_resp,
         substr(obter_profissional_atend(nr_atendimento,'FI','N'),1,60) nm_fisioterapeuta_resp,
         substr(obter_profissional_atend(nr_atendimento,'A','N'),1,60) nm_assistente_resp,
         substr(obter_profissional_atend(nr_atendimento,'E','N'),1,60) nm_enf_resp,
         substr(obter_profissional_atend(nr_atendimento,'MA','N'),1,60) nm_manejador_resp,
         nr_atendimento,
	 substr(obter_enfermeiro_resp(nr_atendimento,'C'),1,20) nr_seq_enfermeiro_resp,
	 substr(obter_profissional_atend(nr_atendimento,'M','C'),1,20) nr_seq_medico_resp,
	 substr(obter_profissional_atend(nr_atendimento,'P','C'),1,60) nr_seq_psicologo_resp,
	 substr(obter_profissional_atend(nr_atendimento,'N','C'),1,60) nr_seq_nutricionista_resp,
	 substr(obter_profissional_atend(nr_atendimento,'F','C'),1,60) nr_seq_farmaceutico_resp,
	 substr(obter_profissional_atend(nr_atendimento,'FI','C'),1,60) nr_seq_fisioterapeuta_resp,
	 substr(obter_profissional_atend(nr_atendimento,'A','C'),1,60) nr_seq_assistente_resp,
	 substr(obter_profissional_atend(nr_atendimento,'E','C'),1,60) nr_seq_enf_resp,
	 substr(obter_profissional_atend(nr_atendimento,'MA','C'),1,60) nr_seq_manejador_resp,
	 cd_setor_atendimento,
	 cd_estabelecimento,
   substr(get_nursing_atend(nr_atendimento,'E','C'),1,60) nr_seq_nursing_team,
   substr(get_nursing_atend(nr_atendimento,'E','N'),1,60) nm_nursing_team,
   cd_pessoa_fisica
FROM     ocupacao_unidade_v
where    ie_status_unidade    = 'P'

union

select	 substr((u.cd_unidade_basica ||' ' || u.cd_unidade_compl),1,255) cd_unidade,
         substr(obter_nome_pf(a.cd_pessoa_fisica),1,255) nm_pessoa_fisica,
         substr(obter_enfermeiro_resp(a.nr_atendimento,'N'),1,60) nm_enfermeiro_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'M','N'),1,60) nm_medico_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'P','N'),1,60) nm_psicologo_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'N','N'),1,60) nm_nutricionista_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'F','N'),1,60) nm_farmaceutico_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'FI','N'),1,60) nm_fisioterapeuta_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'A','N'),1,60) nm_assistente_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'E','N'),1,60) nm_enf_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'MA','N'),1,60) nm_manejador_resp,
         a.nr_atendimento,substr(obter_enfermeiro_resp(a.nr_atendimento,'C'),1,20) nr_seq_enfermeiro_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'M','C'),1,20) nr_seq_medico_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'P','C'),1,60) nr_seq_psicologo_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'N','C'),1,60) nr_seq_nutricionista_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'F','C'),1,60) nr_seq_farmaceutico_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'FI','C'),1,60) nr_seq_fisioterapeuta_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'A','C'),1,60) nr_seq_assistente_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'E','C'),1,60) nr_seq_enf_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'MA','C'),1,60) nr_seq_manejador_resp,
	 c.cd_setor_atendimento,
	 a.cd_estabelecimento,
   substr(get_nursing_atend(a.nr_atendimento,'E','C'),1,60) nr_seq_nursing_team,
   substr(get_nursing_atend(a.nr_atendimento,'E','N'),1,60) nm_nursing_team,
   a.cd_pessoa_fisica
FROM atend_paciente_unidade u, setor_atendimento c, (select  b.nr_cirurgia,
        	  	  b.nr_atendimento,
                  b.dt_entrada_unidade,
                  b.cd_pessoa_fisica
         from     cirurgia b
         where    b.dt_inicio_real between LOCALTIMESTAMP - interval '1 days' and LOCALTIMESTAMP + interval '1 days'
         and      b.dt_entrada_recup is not null
         and	  b.dt_saida_recup is null) b
LEFT OUTER JOIN atendimento_paciente a ON (b.nr_atendimento = a.nr_atendimento)
WHERE a.nr_atendimento     = u.nr_atendimento and a.cd_pessoa_fisica   = b.cd_pessoa_fisica and b.nr_atendimento     = u.nr_atendimento and trunc(b.dt_entrada_unidade) = trunc(u.dt_entrada_unidade) and c.cd_setor_atendimento = u.cd_setor_atendimento and c.ie_situacao        = 'A' and c.cd_classif_setor   = '2'

union

select	 substr((b.cd_unidade_basica ||' ' || b.cd_unidade_compl),1,255) cd_unidade,
         substr(obter_nome_pf(a.cd_pessoa_fisica),1,255) nm_pessoa_fisica,
         substr(obter_enfermeiro_resp(a.nr_atendimento,'N'),1,60) nm_enfermeiro_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'M','N'),1,60) nm_medico_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'P','N'),1,60) nm_psicologo_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'N','N'),1,60) nm_nutricionista_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'F','N'),1,60) nm_farmaceutico_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'FI','N'),1,60) nm_fisioterapeuta_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'A','N'),1,60) nm_assistente_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'E','N'),1,60) nm_enf_resp,
         substr(obter_profissional_atend(a.nr_atendimento,'MA','N'),1,60) nm_manejador_resp,
         a.nr_atendimento,substr(obter_enfermeiro_resp(a.nr_atendimento,'C'),1,20) nr_seq_enfermeiro_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'M','C'),1,20) nr_seq_medico_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'P','C'),1,60) nr_seq_psicologo_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'N','C'),1,60) nr_seq_nutricionista_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'F','C'),1,60) nr_seq_farmaceutico_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'FI','C'),1,60) nr_seq_fisioterapeuta_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'A','C'),1,60) nr_seq_assistente_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'E','C'),1,60) nr_seq_enf_resp,
	 substr(obter_profissional_atend(a.nr_atendimento,'MA','C'),1,60) nr_seq_manejador_resp,
	 s.cd_setor_atendimento,
	 a.cd_estabelecimento,
   substr(get_nursing_atend(a.nr_atendimento,'E','C'),1,60) nr_seq_nursing_team,
   substr(get_nursing_atend(a.nr_atendimento,'E','N'),1,60) nm_nursing_team,
   a.cd_pessoa_fisica
FROM	setor_atendimento s,  
			pessoa_fisica p,  
			atend_categoria_convenio c,  
			atend_paciente_unidade b,  
			atendimento_paciente a  
	WHERE	a.nr_atendimento 	= b.nr_atendimento  
	AND	b.nr_seq_interno 	= obter_atepacu_paciente(a.nr_atendimento, 'A')  
	AND	a.nr_Atendimento 	= c.nr_atendimento  
	AND	c.nr_seq_interno	= obter_atecaco_atendimento(a.nr_atendimento)  
	AND	b.cd_setor_atendimento	= s.cd_setor_atendimento  
	AND	a.cd_pessoa_fisica		= p.cd_pessoa_fisica  
	AND	a.nr_atendimento	> 0 
	and	a.ie_tipo_atendimento = 3
	and a.dt_alta is null
	and a.dt_entrada > LOCALTIMESTAMP - interval '1 days' --tratamento para que considere somente os atendimentos de PA das ultimas 24 h
	AND	EXISTS (SELECT 1  
				FROM	setor_atendimento x,
					atend_paciente_unidade y
				WHERE	a.nr_atendimento = y.nr_atendimento
				AND	y.cd_setor_atendimento	= x.cd_setor_atendimento
				AND	x.cd_classif_setor	= '1')
order by cd_unidade, nm_pessoa_fisica;
