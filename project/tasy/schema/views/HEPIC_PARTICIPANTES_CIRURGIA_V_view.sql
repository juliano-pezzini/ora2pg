-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hepic_participantes_cirurgia_v (nr_cirurgia, nr_sequencia, cd_pessoa_fisica, nm_participante, cd_procedimento, ie_cirurgiao, ie_funcao, ds_funcao) AS SELECT DISTINCT a.nr_cirurgia,
					0 nr_sequencia, 
					obter_medico_cirurgia(a.nr_cirurgia,'C') cd_pessoa_fisica, 
					obter_medico_cirurgia(a.nr_cirurgia, 'D') nm_participante, 
					d.cd_procedimento, 
					CASE WHEN a.cd_medico_cirurgiao=obter_medico_cirurgia(a.nr_cirurgia, 'C') THEN  'S'  ELSE 'N' END  ie_cirurgiao, 
					'1' ie_funcao, 
					c.ds_funcao 
       FROM 	cirurgia a, 
					funcao_medico c, 
					prescr_procedimento d 
       WHERE 	a.nr_cirurgia IS NOT NULL 
        AND 	1 = c.cd_funcao        
        AND 	a.nr_prescricao = d.nr_prescricao 
        AND 	obter_se_proc_cirurgico(d.cd_procedimento,d.ie_origem_proced,d.cd_setor_atendimento) = 'S' 
  
UNION ALL
 
  SELECT DISTINCT 	a.nr_cirurgia, 
					b.nr_sequencia, 
					b.cd_pessoa_fisica, 
					b.nm_participante, 
					d.cd_procedimento, 
					CASE WHEN a.cd_medico_cirurgiao=b.cd_pessoa_fisica THEN  'S'  ELSE 'N' END  ie_cirurgiao, 
					b.ie_funcao, 
					c.ds_funcao 
       FROM 	cirurgia a, 
					cirurgia_participante b, 
					funcao_medico c, 
					prescr_procedimento d 
       WHERE 	a.nr_cirurgia IS NOT NULL 
        AND 	a.nr_cirurgia = b.nr_cirurgia 
        AND 	b.ie_funcao = c.cd_funcao 
        AND 	b.ie_funcao <> 1        
        AND 	a.nr_prescricao = d.nr_prescricao 
        AND 	obter_se_proc_cirurgico(d.cd_procedimento,d.ie_origem_proced, d.cd_setor_atendimento) = 'S' 
     ORDER BY nr_cirurgia, cd_procedimento, ie_funcao;

