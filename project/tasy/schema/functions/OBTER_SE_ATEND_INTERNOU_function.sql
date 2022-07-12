-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atend_internou (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_internou_w	varchar(1);


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_internou_w
	from	setor_atendimento b,
		atend_paciente_unidade a
	where	b.cd_setor_atendimento = a.cd_setor_atendimento
	and	b.cd_classif_setor in ('3','4')
	and	a.nr_atendimento = nr_atendimento_p;
end if;

return ie_internou_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atend_internou (nr_atendimento_p bigint) FROM PUBLIC;

