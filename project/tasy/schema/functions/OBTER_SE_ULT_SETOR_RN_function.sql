-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_ult_setor_rn (nr_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1);
cd_setor_atendimento_w		atend_paciente_unidade.cd_setor_atendimento%type;
cd_unidade_basica_w		atend_paciente_unidade.cd_unidade_basica%type;
cd_unidade_compl_w		atend_paciente_unidade.cd_unidade_compl%type;
qt_existe_registro_w		integer := 0;


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	select 	count(*)
	into STRICT	qt_existe_registro_w
	from	atend_paciente_unidade
	where	nr_atendimento = nr_atendimento_p;
	
	
	if (coalesce(qt_existe_registro_w, 0) > 1) then
	    select  max(cd_setor_atendimento),
				max(cd_unidade_basica),
				max(cd_unidade_compl)
		into STRICT	cd_setor_atendimento_w,
				cd_unidade_basica_w,
				cd_unidade_compl_w
		from	atend_paciente_unidade
		where 	nr_atendimento = nr_atendimento_p
		and		coalesce(dt_saida_unidade::text, '') = '';
		
		if (cd_setor_atendimento_p = cd_setor_atendimento_w) and (cd_unidade_basica_p	= cd_unidade_basica_w) and (cd_unidade_compl_p = cd_unidade_compl_w) then
		   ds_retorno_w := 'S';
		else
		   ds_retorno_w := 'N';
		end if;
			
	else
	   ds_retorno_w := 'S';
	end if;
		
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_ult_setor_rn (nr_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text) FROM PUBLIC;

