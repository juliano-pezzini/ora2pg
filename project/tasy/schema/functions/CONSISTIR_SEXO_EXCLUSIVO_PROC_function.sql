-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consistir_sexo_exclusivo_proc ( cd_pessoa_fisica_p text, nr_seq_proc_interno_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS varchar AS $body$
DECLARE


ie_sexo_w		varchar(1);
ie_sexo_sus_w		varchar(1);

/*
	S - Procedimento é valido para a pessoa
	N - Procedimento não é valido para a pessoa
*/
BEGIN

if (ie_origem_proced_p = 7) then

	begin
	select 	ie_sexo
	into STRICT	ie_sexo_sus_w
	from 	sus_procedimento
	where 	cd_procedimento = cd_procedimento_p
	and 	ie_origem_proced = ie_origem_proced_p;
	exception
		when others then
			ie_sexo_sus_w	:= null;
	end;

	if (ie_sexo_sus_w = 'I') then
		ie_sexo_sus_w:= null;
	end if;

else

	begin
	select	ie_sexo_sus
	into STRICT	ie_sexo_sus_w
	from 	procedimento
	where	cd_procedimento  = cd_procedimento_p
	and	ie_origem_proced = ie_origem_proced_p;
	exception
		when others then
			ie_sexo_sus_w	:= null;
	end;

	select	coalesce(max(ie_sexo), ie_sexo_sus_w)
	into STRICT	ie_sexo_sus_w
	from	proc_interno
	where	nr_sequencia		= nr_seq_proc_interno_p;

end if;

if (ie_sexo_sus_w IS NOT NULL AND ie_sexo_sus_w::text <> '') then

	begin
	select	obter_sexo_pf(cd_pessoa_fisica_p,'C')
	into STRICT	ie_sexo_w
	;
	exception
	when others then
		ie_sexo_w	:= null;
	end;

	if (ie_sexo_w IS NOT NULL AND ie_sexo_w::text <> '') then
		if (ie_sexo_sus_w 	 = ie_sexo_w) then
			return	'S';
		else
			return	'N';
		end	if;
	else
		return	'S';
	end	if;
else
	return	'S';
end	if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consistir_sexo_exclusivo_proc ( cd_pessoa_fisica_p text, nr_seq_proc_interno_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;

