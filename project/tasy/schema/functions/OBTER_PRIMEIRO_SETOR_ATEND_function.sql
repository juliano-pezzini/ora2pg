-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_primeiro_setor_atend ( nr_atendimento_p bigint, ie_opcao_p text default 'D') RETURNS varchar AS $body$
DECLARE


nr_seq_interno_w	bigint;
cd_setor_atendimento_w	integer;
ds_setor_atendimento_w	varchar(100);


BEGIN
-- ie_opcao_p - C (Código) / D (Descrição)
ds_setor_atendimento_w := '';

if (coalesce(nr_atendimento_p,0) > 0) then

	select	coalesce(min(nr_seq_interno),0)
	into STRICT	nr_seq_interno_w
	from 	atend_paciente_unidade a
	where	a.nr_atendimento 	= nr_atendimento_p
	and 	dt_entrada_unidade	=  (SELECT min(dt_entrada_unidade)
		                           from atend_paciente_unidade b
		                           where nr_atendimento = nr_atendimento_p);

	if (nr_seq_interno_w > 0) then
		select 	coalesce(max(cd_setor_atendimento),0)
		into STRICT	cd_setor_atendimento_w
		from 	atend_paciente_unidade
		where 	nr_seq_interno = nr_seq_interno_w;

		if (cd_setor_atendimento_w > 0) then

			select	substr(max(ds_setor_atendimento),1,100)
			into STRICT	ds_setor_atendimento_w
			from	setor_atendimento
			where	cd_setor_atendimento	= cd_setor_atendimento_w;
		end if;
	end if;
end if;

If (ie_opcao_p = 'C') then
	return	cd_setor_atendimento_w;
Elsif (ie_opcao_p = 'D') then
	return	ds_setor_atendimento_w;
End if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_primeiro_setor_atend ( nr_atendimento_p bigint, ie_opcao_p text default 'D') FROM PUBLIC;
