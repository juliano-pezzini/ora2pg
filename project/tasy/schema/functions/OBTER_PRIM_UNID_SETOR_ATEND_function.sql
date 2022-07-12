-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prim_unid_setor_atend ( nr_atendimento_p bigint, ie_opcao_p text default 'U') RETURNS varchar AS $body$
DECLARE


nr_seq_interno_w	atend_paciente_unidade.nr_seq_interno%type;
cd_setor_atendimento_w	atend_paciente_unidade.cd_setor_atendimento%type;
cd_unidade_basica_w	atend_paciente_unidade.cd_unidade_basica%type;
cd_unidade_compl_w	atend_paciente_unidade.cd_unidade_compl%type;
ds_retorno_w		varchar(255);



BEGIN
-- ie_opcao_p - C (Código) / U ( Unidade Basica +Unidade Complementar)
cd_setor_atendimento_w := null;

if (coalesce(nr_atendimento_p,0) > 0) then

	select	coalesce(min(nr_seq_interno),0)
	into STRICT	nr_seq_interno_w
	from 	atend_paciente_unidade a
	where	a.nr_atendimento 	= nr_atendimento_p
	and 	dt_entrada_unidade	=  (SELECT min(dt_entrada_unidade)
		                           from atend_paciente_unidade b
		                           where nr_atendimento = nr_atendimento_p);

	if (nr_seq_interno_w > 0) then
		begin
		select 	coalesce(max(cd_setor_atendimento),0),
			max(cd_unidade_basica),
			max(cd_unidade_compl)
		into STRICT	cd_setor_atendimento_w,
			cd_unidade_basica_w,
			cd_unidade_compl_w
		from 	atend_paciente_unidade
		where 	nr_seq_interno = nr_seq_interno_w;

		exception
			when others then
				cd_unidade_basica_w	:= '';
				cd_unidade_compl_w	:= '';
		end;
		ds_retorno_w	:= cd_unidade_basica_w || ' ' || cd_unidade_compl_w;
	end if;
end if;

If (ie_opcao_p = 'C') then
	return	cd_setor_atendimento_w;
Elsif (ie_opcao_p = 'U') then
	return	ds_retorno_w;
End if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prim_unid_setor_atend ( nr_atendimento_p bigint, ie_opcao_p text default 'U') FROM PUBLIC;
