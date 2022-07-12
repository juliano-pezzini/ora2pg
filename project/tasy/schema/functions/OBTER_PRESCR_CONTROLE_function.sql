-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prescr_controle ( nr_controle_p bigint, cd_estabelecimento_p bigint default null) RETURNS bigint AS $body$
DECLARE


nr_prescricao_w		bigint;


BEGIN

nr_prescricao_w	:= 0;

if (nr_controle_p IS NOT NULL AND nr_controle_p::text <> '') then

	select	max(nr_prescricao)
	into STRICT	nr_prescricao_w
	from	prescr_medica
	where	nr_controle	   = nr_controle_p
	and	cd_estabelecimento = coalesce(cd_estabelecimento_p,cd_estabelecimento);

	if (coalesce(nr_prescricao_w::text, '') = '') then

		select	max(p.nr_prescricao)
		into STRICT	nr_prescricao_w
		from	prescr_procedimento r,
			prescr_medica p
		where	r.nr_controle_ext	= nr_controle_p
		and	r.nr_prescricao		= p.nr_prescricao
		and	p.cd_estabelecimento	= coalesce(cd_estabelecimento_p,cd_estabelecimento);

	end if;

end if;

return	nr_prescricao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prescr_controle ( nr_controle_p bigint, cd_estabelecimento_p bigint default null) FROM PUBLIC;

