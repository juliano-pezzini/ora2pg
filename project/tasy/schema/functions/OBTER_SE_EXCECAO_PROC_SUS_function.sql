-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_excecao_proc_sus (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_excecao_w	varchar(1) := 'N';
qt_registro_w	bigint;
cd_procedimento_real_w	bigint;
ie_origem_proc_real_w	bigint;


BEGIN

begin
select	max(a.cd_procedimento_real),
	max(a.ie_origem_proc_real)
into STRICT	cd_procedimento_real_w,
	ie_origem_proc_real_w
from	sus_aih_unif a
where	a.nr_atendimento = nr_atendimento_p
and	a.nr_aih = (	SELECT	max(x.nr_aih)
			from	sus_aih_unif x
			where	x.nr_atendimento = nr_atendimento_p);
exception
when others then
	cd_procedimento_real_w 	:= 0;
	ie_origem_proc_real_w	:= 0;
end;

if (coalesce(cd_procedimento_real_w,0) > 0) and (coalesce(ie_origem_proc_real_w,0) > 0) then
	select	count(*)
	into STRICT	qt_registro_w
	from	regra_excecao_proc_sus
	where	cd_procedimento 	= cd_procedimento_real_w
	and	ie_origem_proced	= ie_origem_proc_real_w;
	if (qt_registro_w > 0) then
		ie_excecao_w := 'S';
	end if;
end if;

return ie_excecao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_excecao_proc_sus (nr_atendimento_p bigint) FROM PUBLIC;

