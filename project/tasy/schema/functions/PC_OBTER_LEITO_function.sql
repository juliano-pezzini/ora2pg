-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pc_obter_leito (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

				
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
nr_seq_interno_w		atend_paciente_unidade.nr_seq_interno%type;
cd_unidade_basica_w		atend_paciente_unidade.cd_unidade_basica%type;
cd_unidade_compl_w		atend_paciente_unidade.cd_unidade_compl%type;
ds_retorno_w			varchar(255);
			

BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '')	then

	select 	coalesce(max(nr_seq_interno),0)
	into STRICT 	nr_seq_interno_w
	from	atend_paciente_unidade
	where 	coalesce(dt_saida_unidade::text, '') = ''
	and		nr_atendimento = nr_atendimento_p;
	
	if (nr_seq_interno_w > 0)  then
		select	cd_unidade_basica,
				cd_unidade_compl
		into STRICT	cd_unidade_basica_w,
				cd_unidade_compl_w
		from	atend_paciente_unidade
		where	nr_seq_interno = nr_seq_interno_w;
		
		ds_retorno_w := cd_unidade_basica_w;
		if (cd_unidade_compl_w IS NOT NULL AND cd_unidade_compl_w::text <> '') then
			ds_retorno_w := ds_retorno_w || ' - ' || cd_unidade_compl_w;
		end if;
	end if;
end if;	
	
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pc_obter_leito (nr_atendimento_p bigint) FROM PUBLIC;
