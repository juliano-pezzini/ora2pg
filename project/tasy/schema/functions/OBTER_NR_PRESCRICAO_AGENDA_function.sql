-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nr_prescricao_agenda ( nr_seq_agenda_p bigint) RETURNS bigint AS $body$
DECLARE

nr_prescricao_w	bigint;

BEGIN
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then
	begin
	select	coalesce(nr_prescricao,0)
	into STRICT	nr_prescricao_w
	from	prescr_medica
	where	ie_tipo_prescr_cirur	= '1'
	and	nr_seq_agenda		= nr_seq_agenda_p;
	end;
end if;
return nr_prescricao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nr_prescricao_agenda ( nr_seq_agenda_p bigint) FROM PUBLIC;

