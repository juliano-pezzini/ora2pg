-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_code_specialities (cd_medico_p text, cd_especialidade_p text) RETURNS varchar AS $body$
DECLARE

cd_especialidade_w	MEDICO_ESPECIALIDADE.cd_especialidade%type;
countsqr bigint;
countbsnr bigint;
nr_sequencia_w MEDICO_ESPEC_BSNR.nr_sequencia%type;

BEGIN
  if ((cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') and coalesce(cd_especialidade_p::text, '') = '') then
    select count(cd)
    into STRICT countsqr
    from (SELECT cd_especialidade cd,nr_rqe ds
    from MEDICO_ESPECIALIDADE
    where CD_PESSOA_FISICA = cd_medico_p /*and  cd_especialidade='300' */
order by 2) alias4;

    if (countsqr=1) then
      select cd_especialidade cd
      into STRICT cd_especialidade_w
      from MEDICO_ESPECIALIDADE
      where CD_PESSOA_FISICA = cd_medico_p;/*and  cd_especialidade='300';*/
    end if;
    return cd_especialidade_w;
   end if;
if (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '' AND cd_especialidade_p IS NOT NULL AND cd_especialidade_p::text <> '') then
		
		select count(cd)
		into STRICT countbsnr
		from (SELECT nr_sequencia cd, nr_bsnr ds from MEDICO_ESPEC_BSNR
				where CD_PESSOA_FISICA = cd_medico_p
				and CD_ESPECIALIDADE = cd_especialidade_p order by 2) alias2;
		if (countbsnr=1) then
			select nr_sequencia 
			into STRICT nr_sequencia_w
			from MEDICO_ESPEC_BSNR
			where CD_PESSOA_FISICA = cd_medico_p and CD_ESPECIALIDADE = cd_especialidade_p;
	End if;
	return nr_sequencia_w;
	End if;
return null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_code_specialities (cd_medico_p text, cd_especialidade_p text) FROM PUBLIC;

