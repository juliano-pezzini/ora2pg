-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW w_eis_upp_grau_risco_q_v (nr_atendimento, dt_evento, cd_setor_atendimento, ds_setor, ds_unidade, qt_ponto, ds_risco) AS select	distinct	
	b.nr_atendimento, 
	b.dt_evento, 
	c.cd_setor_atendimento, 
	substr(obter_ds_descricao_setor(c.cd_setor_atendimento),1,255) ds_setor, 
	obter_unidade_atendimento(b.nr_atendimento,'A','U') ds_unidade, 
	e.qt_ponto,	  
	substr(obter_resultado_braden_q(e.qt_ponto),1,100) ds_risco 
FROM atend_escala_braden_q e, qua_evento_paciente b
LEFT OUTER JOIN cur_ferida c ON (b.nr_sequencia = c.nr_seq_evento)
WHERE c.ie_admitido_ferida = 'N'  and c.dt_inativacao is null and b.nr_atendimento = e.nr_atendimento and e.nr_sequencia = ( select max(f.nr_sequencia) 
		    	  from	 atend_escala_braden_q f 
			  where f.nr_atendimento = e.nr_atendimento 
			  and	 trunc(f.dt_avaliacao)<= trunc(c.dt_atualizacao)) and trunc(c.dt_atualizacao) >= trunc(e.dt_avaliacao);

