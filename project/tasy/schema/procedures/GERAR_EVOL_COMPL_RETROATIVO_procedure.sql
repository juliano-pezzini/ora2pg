-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evol_compl_retroativo ( cd_evolucao_p EVOLUCAO_PACIENTE.CD_EVOLUCAO%type, ds_justificativa_retro_p EVOLUCAO_PACIENTE_COMPL.DS_JUSTIFICATIVA_RETRO%type) AS $body$
DECLARE


ie_existe_compl_w varchar(1);


BEGIN

select coalesce(max('S'), 'N')
into STRICT ie_existe_compl_w
from EVOLUCAO_PACIENTE_COMPL
where NR_SEQ_EVO_PACIENTE = cd_evolucao_p;

if (ie_existe_compl_w = 'S') then
  update EVOLUCAO_PACIENTE_COMPL
  set ds_justificativa_retro = ds_justificativa_retro_p
  where NR_SEQ_EVO_PACIENTE = cd_evolucao_p;
else
  insert into EVOLUCAO_PACIENTE_COMPL(
    NR_SEQ_EVO_PACIENTE,
    ds_justificativa_retro
  ) values (
    cd_evolucao_p,
    ds_justificativa_retro_p
  );

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evol_compl_retroativo ( cd_evolucao_p EVOLUCAO_PACIENTE.CD_EVOLUCAO%type, ds_justificativa_retro_p EVOLUCAO_PACIENTE_COMPL.DS_JUSTIFICATIVA_RETRO%type) FROM PUBLIC;

