-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW w_eis_upp_gravidade_v (nr_atendimento, dt_evento, cd_setor_atendimento, ds_setor, ds_unidade, ds_gravidade) AS select	distinct	
	b.nr_atendimento,	  
	b.dt_evento, 
	c.cd_setor_atendimento, 
	substr(obter_ds_descricao_setor(c.cd_setor_atendimento),1,255) ds_setor, 
	obter_unidade_atendimento(b.nr_atendimento,'A','U') ds_unidade, 
	coalesce(substr(obter_dados_ficha_UPP(c.nr_sequencia,'EM'),1,255),'Não informado') ds_gravidade	 
FROM atend_escala_braden d, qua_evento_paciente b
LEFT OUTER JOIN cur_ferida c ON (b.nr_sequencia = c.nr_seq_evento)
WHERE c.ie_admitido_ferida = 'N'  and c.dt_inativacao is null and b.nr_atendimento = d.nr_atendimento and d.nr_sequencia = ( select max(e.nr_sequencia) 
		    	  from	 atend_escala_braden e 
			  where e.nr_atendimento = d.nr_atendimento 
			  and	 trunc(e.dt_avaliacao)<= trunc(c.dt_atualizacao)) and trunc(c.dt_atualizacao) >= trunc(d.dt_avaliacao);

