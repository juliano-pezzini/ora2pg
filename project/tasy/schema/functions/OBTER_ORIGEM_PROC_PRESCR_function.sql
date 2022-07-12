-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_origem_proc_prescr (nr_prescricao_p bigint, nr_seq_proced_p bigint) RETURNS bigint AS $body$
DECLARE


ie_origem_proced_w	smallint;


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_proced_p IS NOT NULL AND nr_seq_proced_p::text <> '') then
	select	max(ie_origem_proced)
	into STRICT	ie_origem_proced_w
	from	prescr_procedimento
	where	nr_prescricao	= nr_prescricao_p
	and	nr_sequencia	= nr_seq_proced_p;
end if;

return ie_origem_proced_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_origem_proc_prescr (nr_prescricao_p bigint, nr_seq_proced_p bigint) FROM PUBLIC;
