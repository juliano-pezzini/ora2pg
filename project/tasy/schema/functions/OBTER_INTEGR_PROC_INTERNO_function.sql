-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_integr_proc_interno ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_tipo_integracao_p bigint ) RETURNS varchar AS $body$
DECLARE


cd_integracao_w		varchar(20) := null;
ie_lado_w		varchar(1);
nr_seq_proc_interno_w	bigint;


BEGIN

select	max(ie_lado),
	max(nr_seq_proc_interno)
into STRICT	ie_lado_w,
	nr_seq_proc_interno_w
from	prescr_procedimento
where	nr_prescricao	= nr_prescricao_p
and	nr_sequencia 	= nr_seq_prescr_p;


if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '')	 then

	select	max(cd_integracao)
	into STRICT	cd_integracao_w
	from	regra_proc_interno_integra
	where	nr_seq_proc_interno 	= nr_seq_proc_interno_w
	and	ie_lado			= ie_lado_w
	and	ie_tipo_integracao	= ie_tipo_integracao_p;

end if;

if (coalesce(cd_integracao_w::text, '') = '') then

	select 	coalesce(cd_integracao, to_char(nr_seq_proc_interno_w))
	into STRICT	cd_integracao_w
	from	proc_interno
	where	nr_sequencia = nr_seq_proc_interno_w;

end if;

return	cd_integracao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_integr_proc_interno ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_tipo_integracao_p bigint ) FROM PUBLIC;

