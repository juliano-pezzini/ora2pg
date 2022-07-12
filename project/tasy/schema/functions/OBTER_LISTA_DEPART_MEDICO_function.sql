-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lista_depart_medico (cd_setor_atendimento_p departamento_setor.cd_setor_atendimento%type) RETURNS varchar AS $body$
DECLARE


ds_list_medical_depart_w	varchar(2000) := '';

  list_medical_depart RECORD;

BEGIN
  for list_medical_depart in (
      SELECT obter_nome_departamento_medico(ds.cd_departamento) medical_depart_name
      from   departamento_setor ds
      join   setor_atendimento sa
      on     sa.cd_setor_atendimento = ds.cd_setor_atendimento
      where  ds.cd_setor_atendimento = cd_setor_atendimento_p
      order by 1
  )
  
  loop  
      ds_list_medical_depart_w := ds_list_medical_depart_w || list_medical_depart.medical_depart_name || ', ';
  end loop;

return	substr(ds_list_medical_depart_w, 1, length(ds_list_medical_depart_w) - 2);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lista_depart_medico (cd_setor_atendimento_p departamento_setor.cd_setor_atendimento%type) FROM PUBLIC;

