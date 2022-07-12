-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exame_urgente_regra ( cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, nr_seq_exame_p text, nr_prescricao_p prescr_procedimento.nr_prescricao%type default null, nr_seq_prescr_p prescr_procedimento.nr_sequencia%type default null, cd_procedimento_p prescr_procedimento.cd_procedimento%type default null, ie_origem_proced_p prescr_procedimento.ie_origem_proced%type default null, nr_seq_proc_interno_p prescr_procedimento.nr_seq_proc_interno%type default null) RETURNS varchar AS $body$
DECLARE

 
nr_seq_grupo_w      bigint;
ie_urgente_w       varchar(1) := null;

nr_atendimento_w     atendimento_paciente.nr_atendimento%type;
ie_tipo_atendimento_w  atendimento_paciente.ie_tipo_atendimento%type;
ie_clinica_w       atendimento_paciente.ie_clinica%type;
cd_procedencia_w     atendimento_paciente.cd_procedencia%type;

cd_setor_prescricao_w  prescr_medica.cd_setor_entrega%type;

cd_area_procedimento_w  especialidade_proc.cd_area_procedimento%type;

cd_grupo_proc_w     procedimento.cd_grupo_proc%type;
nr_seq_subgrupo_w    procedimento.cd_subgrupo_bpa%type;

c01 CURSOR FOR 
  SELECT ie_urgente 
  from  regra_urgencia_exame 
  where (coalesce(cd_estabelecimento,cd_estabelecimento_p)  = cd_estabelecimento_p   or (coalesce(cd_estabelecimento_p::text, '') = '')) 
  and (coalesce(cd_setor_atendimento,cd_setor_atendimento_p)= cd_setor_atendimento_p  or (coalesce(cd_setor_atendimento_p::text, '') = '')) 
  and (coalesce(nr_seq_grupo,nr_seq_grupo_w)    = nr_seq_grupo_w    or (coalesce(nr_seq_grupo_w::text, '') = '')) 
  and (coalesce(nr_seq_exame,nr_seq_exame_p)    = nr_seq_exame_p    or (coalesce(nr_seq_exame_p::text, '') = '')) 
  order  by nr_seq_exame, nr_seq_grupo, cd_setor_atendimento, cd_estabelecimento;

c02 CURSOR FOR 
  SELECT  
    ie_urgente 
  from 
    regra_urgencia_exame 
  where 
    coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_p, '1')) = coalesce(cd_estabelecimento_p,coalesce(cd_estabelecimento, '1')) and 
    coalesce(cd_setor_atendimento,coalesce(cd_setor_atendimento_p, '1')) = coalesce(cd_setor_atendimento_p,coalesce(cd_setor_atendimento, '1')) and 
    coalesce(nr_seq_grupo,coalesce(nr_seq_grupo_w, '1')) = coalesce(nr_seq_grupo_w, coalesce(nr_seq_grupo, '1')) and 
    coalesce(nr_seq_exame,coalesce(nr_seq_exame_p, '1')) = coalesce(nr_seq_exame_p, coalesce(nr_seq_exame, '1')) and 
    coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_w, '1')) = coalesce(ie_tipo_atendimento_w, coalesce(ie_tipo_atendimento, '1')) and 
    coalesce(ie_clinica, coalesce(ie_clinica_w, '1')) = coalesce(ie_clinica_w, coalesce(ie_clinica, '1')) and 
    coalesce(cd_procedencia, coalesce(cd_procedencia_w, '1')) = coalesce(cd_procedencia_w, coalesce(cd_procedencia, '1')) and 
    coalesce(cd_setor_prescricao, coalesce(cd_setor_prescricao_w, '1')) = coalesce(cd_setor_prescricao_w, coalesce(cd_setor_prescricao, '1')) and 
    coalesce(cd_procedimento, coalesce(cd_procedimento_p, '1')) = coalesce(cd_procedimento_p, coalesce(cd_procedimento, '1')) and 
    coalesce(ie_origem_proced, coalesce(ie_origem_proced_p, '1')) = coalesce(ie_origem_proced_p, coalesce(ie_origem_proced, '1')) and 
    coalesce(nr_seq_proc_interno, coalesce(nr_seq_proc_interno_p, '1')) = coalesce(nr_seq_proc_interno_p, coalesce(nr_seq_proc_interno, '1')) and 
    coalesce(cd_area_procedimento, coalesce(cd_area_procedimento_w, '1')) = coalesce(cd_area_procedimento_w, coalesce(cd_area_procedimento, '1')) and 
    coalesce(cd_grupo_proc, coalesce(cd_grupo_proc_w, '1')) = coalesce(cd_grupo_proc_w, coalesce(cd_grupo_proc, '1')) and 
    coalesce(nr_seq_subgrupo, coalesce(nr_seq_subgrupo_w, '1')) = coalesce(nr_seq_subgrupo_w, coalesce(nr_seq_subgrupo, '1')) 
  order  by nr_seq_exame, nr_seq_grupo, cd_setor_atendimento, cd_estabelecimento;


BEGIN 
 
select max(nr_seq_grupo) 
into STRICT  nr_seq_grupo_w 
from  exame_laboratorio 
where  nr_seq_exame = nr_seq_exame_p;
 
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') then 
   
  select 
    nr_atendimento, 
    cd_setor_entrega 
  into STRICT 
    nr_atendimento_w, 
    cd_setor_prescricao_w 
  from 
    prescr_medica 
  where 
    nr_prescricao = nr_prescricao_p;
   
  if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
 
    select 
      ie_tipo_atendimento, 
      ie_clinica, 
      cd_procedencia 
    into STRICT 
      ie_tipo_atendimento_w, 
      ie_clinica_w, 
      cd_procedencia_w 
    from 
      atendimento_paciente 
    where 
      nr_atendimento = nr_atendimento_w;
 
  end if;
 
  select 
    cd_grupo_proc, 
    cd_subgrupo_bpa 
  into STRICT 
    cd_grupo_proc_w, 
    nr_seq_subgrupo_w 
  from 
    procedimento 
  where 
    cd_procedimento = cd_procedimento_p and 
    ie_origem_proced = ie_origem_proced_p;
 
  select 
    obter_area_procedimento(cd_procedimento_p, ie_origem_proced_p) 
  into STRICT 
    cd_area_procedimento_w 
;
 
  open c02;
  loop 
  fetch c02 into  
    ie_urgente_w;
  EXIT WHEN NOT FOUND; /* apply on c02 */
    begin 
    exit;
    end;
  end loop;
  close c02;
 
else 
  --Mantido comportmento antigo para preenção de erros em caso de chamadas não rastreadas à function (relatórios e/ou fonte). 
  open c01;
  loop 
  fetch c01 into  
    ie_urgente_w;
  EXIT WHEN NOT FOUND; /* apply on c01 */
    begin 
    exit;
    end;
  end loop;
  close c01;
 
end if;
 
return ie_urgente_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exame_urgente_regra ( cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, nr_seq_exame_p text, nr_prescricao_p prescr_procedimento.nr_prescricao%type default null, nr_seq_prescr_p prescr_procedimento.nr_sequencia%type default null, cd_procedimento_p prescr_procedimento.cd_procedimento%type default null, ie_origem_proced_p prescr_procedimento.ie_origem_proced%type default null, nr_seq_proc_interno_p prescr_procedimento.nr_seq_proc_interno%type default null) FROM PUBLIC;
