-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_setor_ent_prescr_proc ( nr_prescricao_p bigint, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


cd_retorno_w	integer;
ds_retorno_w	varchar(100);


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

	select	max(cd_setor_entrega)
	into STRICT	cd_retorno_w
	from	prescr_procedimento
	where	nr_prescricao	= nr_prescricao_p
	and	nr_sequencia	= nr_sequencia_p;

	if (coalesce(cd_retorno_w::text, '') = '') then
		select	max(cd_setor_entrega)
		into STRICT	cd_retorno_w
		from	prescr_medica
		where	nr_prescricao	=	nr_prescricao_p;
	end if;

end if;

return	cd_retorno_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_setor_ent_prescr_proc ( nr_prescricao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

