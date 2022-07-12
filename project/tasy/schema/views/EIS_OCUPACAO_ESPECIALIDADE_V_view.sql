-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_ocupacao_especialidade_v (dt_referencia, cd_setor_atendimento, cd_convenio, cd_tipo_acomodacao, ie_clinica, cd_especialidade, ds_especialidade, qt_leito_livre, nr_pac_partic, nr_pac_conv, nr_pac_sus, nr_pac_outros, nr_obito_partic, nr_obito_conv, nr_obito_sus, nr_obito_outros, nr_alta_partic, nr_alta_conv, nr_alta_sus, nr_alta_outros, nr_admissao_partic, nr_admissao_conv, nr_admissao_sus, nr_admissao_outros, nr_pac_total, nr_obito_total, nr_alta_total, nr_admissao_total, qt_leito_total) AS select   a.dt_referencia,
      a.cd_setor_atendimento, 
      a.cd_convenio, 
      a.cd_tipo_acomodacao, 
      a.ie_clinica, 
	  m.cd_especialidade,	 
      e.ds_especialidade, 
      coalesce(qt_leito_livre,0) qt_leito_livre,          
      CASE WHEN v.ie_tipo_convenio=1 THEN  nr_pacientes  ELSE 0 END  nr_pac_partic,        
      CASE WHEN v.ie_tipo_convenio=2 THEN  nr_pacientes WHEN v.ie_tipo_convenio=5 THEN nr_pacientes WHEN v.ie_tipo_convenio=6 THEN nr_pacientes WHEN v.ie_tipo_convenio=7 THEN nr_pacientes WHEN v.ie_tipo_convenio=8 THEN nr_pacientes WHEN v.ie_tipo_convenio=9 THEN nr_pacientes  ELSE 0 END  nr_pac_conv,     
      CASE WHEN v.ie_tipo_convenio=3 THEN  nr_pacientes  ELSE 0 END  nr_pac_sus,      
      CASE WHEN v.ie_tipo_convenio=1 THEN  0 WHEN v.ie_tipo_convenio=2 THEN  0 WHEN v.ie_tipo_convenio=3 THEN  0 WHEN v.ie_tipo_convenio=5 THEN  0 WHEN v.ie_tipo_convenio=6 THEN  0 WHEN v.ie_tipo_convenio=7 THEN  0 WHEN v.ie_tipo_convenio=8 THEN  0 WHEN v.ie_tipo_convenio=9 THEN  0  ELSE nr_pacientes END  nr_pac_outros, 
      CASE WHEN v.ie_tipo_convenio=1 THEN  nr_obitos  ELSE 0 END  nr_obito_partic,         
      CASE WHEN v.ie_tipo_convenio=2 THEN  nr_obitos WHEN v.ie_tipo_convenio=5 THEN nr_obitos WHEN v.ie_tipo_convenio=6 THEN nr_obitos WHEN v.ie_tipo_convenio=7 THEN nr_obitos WHEN v.ie_tipo_convenio=8 THEN nr_obitos WHEN v.ie_tipo_convenio=9 THEN nr_obitos  ELSE 0 END  nr_obito_conv,      
      CASE WHEN v.ie_tipo_convenio=3 THEN  nr_obitos  ELSE 0 END  nr_obito_sus,      
      CASE WHEN v.ie_tipo_convenio=1 THEN  0 WHEN v.ie_tipo_convenio=2 THEN  0 WHEN v.ie_tipo_convenio=3 THEN  0 WHEN v.ie_tipo_convenio=5 THEN  0 WHEN v.ie_tipo_convenio=6 THEN  0 WHEN v.ie_tipo_convenio=7 THEN  0 WHEN v.ie_tipo_convenio=8 THEN  0 WHEN v.ie_tipo_convenio=9 THEN  0  ELSE nr_obitos END  nr_obito_outros, 
      CASE WHEN v.ie_tipo_convenio=1 THEN  nr_altas  ELSE 0 END  nr_alta_partic,      
      CASE WHEN v.ie_tipo_convenio=2 THEN  nr_altas WHEN v.ie_tipo_convenio=nr_altas THEN 5 WHEN v.ie_tipo_convenio=nr_altas THEN 6 WHEN v.ie_tipo_convenio=nr_altas THEN 7 WHEN v.ie_tipo_convenio=nr_altas THEN 8 WHEN v.ie_tipo_convenio=nr_altas THEN 9 WHEN v.ie_tipo_convenio=nr_altas THEN 0 END  nr_alta_conv,       
      CASE WHEN v.ie_tipo_convenio=3 THEN  nr_altas  ELSE 0 END  nr_alta_sus,       
      CASE WHEN v.ie_tipo_convenio=1 THEN  0 WHEN v.ie_tipo_convenio=2 THEN  0 WHEN v.ie_tipo_convenio=3 THEN  0 WHEN v.ie_tipo_convenio=5 THEN  0 WHEN v.ie_tipo_convenio=6 THEN  0 WHEN v.ie_tipo_convenio=7 THEN  0 WHEN v.ie_tipo_convenio=8 THEN  0 WHEN v.ie_tipo_convenio=9 THEN  0  ELSE nr_altas END  nr_alta_outros, 
      CASE WHEN v.ie_tipo_convenio=1 THEN  nr_admissoes  ELSE 0 END  nr_admissao_partic,  
      CASE WHEN v.ie_tipo_convenio=2 THEN  nr_admissoes WHEN v.ie_tipo_convenio=5 THEN nr_admissoes WHEN v.ie_tipo_convenio=6 THEN nr_admissoes WHEN v.ie_tipo_convenio=7 THEN nr_admissoes WHEN v.ie_tipo_convenio=8 THEN nr_admissoes WHEN v.ie_tipo_convenio=9 THEN nr_admissoes  ELSE 0 END  nr_admissao_conv,   
      CASE WHEN v.ie_tipo_convenio=3 THEN  nr_admissoes  ELSE 0 END  nr_admissao_sus, 
      CASE WHEN v.ie_tipo_convenio=1 THEN  0 WHEN v.ie_tipo_convenio=2 THEN  0 WHEN v.ie_tipo_convenio=3 THEN  0 WHEN v.ie_tipo_convenio=5 THEN  0 WHEN v.ie_tipo_convenio=6 THEN  0 WHEN v.ie_tipo_convenio=7 THEN  0 WHEN v.ie_tipo_convenio=8 THEN  0 WHEN v.ie_tipo_convenio=9 THEN  0  ELSE nr_admissoes END  nr_admissao_outros, 
      nr_pacientes nr_pac_total, 
      nr_obitos nr_obito_total, 
      nr_altas nr_alta_total, 
      nr_admissoes nr_admissao_total, 
      (coalesce(qt_leito_livre,0) + nr_pacientes) qt_leito_total 
FROM        convenio v, 
      especialidade_medica e, 
      medico_especialidade m, 
      eis_ocupacao_hospitalar a 
where   a.cd_convenio      = v.cd_convenio 
and  a.cd_medico     = m.cd_pessoa_fisica 
and    m.cd_especialidade   = e.cd_especialidade 
  and   a.ie_periodo  = 'D';
