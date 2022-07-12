-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_visita_autorizada (nr_atendimento_p bigint, nr_seq_tipo_p bigint) RETURNS varchar AS $body$
DECLARE


qt_tipo_visita_w	bigint;
ie_tipo_visita_aut_w	varchar(1);
ie_grau_parentesco_visi_w	bigint;
qt_visitante_aut_w	bigint;


BEGIN

ie_tipo_visita_aut_w := 'S';

if (coalesce(nr_seq_tipo_p,0) > 0) then

	select	coalesce(max(ie_grau_parentesco),0)
	into STRICT	ie_grau_parentesco_visi_w
	from	visitante
	where	nr_sequencia = nr_seq_tipo_p;
end if;

if (coalesce(nr_atendimento_p,0) > 0) then

	select	count(*)
	into STRICT	qt_visitante_aut_w
	from	atendimento_visita_lib
	where	nr_atendimento = nr_atendimento_p;

	if (qt_visitante_aut_w > 0) then
		select  Count(*)
		into STRICT	qt_tipo_visita_w
		from  	atendimento_visita_lib a,
			grau_parentesco g
		where	a.nr_atendimento = nr_atendimento_p
		and	coalesce(a.cd_pessoa_lib::text, '') = ''
		and	g.nr_sequencia = a.nr_seq_grau_parentesco
		and	g.ie_grau_parentesco = ie_grau_parentesco_visi_w;

		if (qt_tipo_visita_w > 0) then
			ie_tipo_visita_aut_w := 'S';
		else
			ie_tipo_visita_aut_w := 'N';
		end if;
	end if;
end if;

return ie_tipo_visita_aut_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_visita_autorizada (nr_atendimento_p bigint, nr_seq_tipo_p bigint) FROM PUBLIC;
