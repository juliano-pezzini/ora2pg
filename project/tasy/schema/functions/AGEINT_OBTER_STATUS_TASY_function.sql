-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_status_tasy ( nr_seq_status_p bigint) RETURNS varchar AS $body$
DECLARE


ie_status_tasy_w	varchar(2);


BEGIN

if (nr_seq_status_p IS NOT NULL AND nr_seq_status_p::text <> '') then

	select	max(ie_status_tasy)
	into STRICT	ie_status_tasy_w
	from	agenda_integrada_status
	where	nr_sequencia 	= nr_seq_status_p
	and		ie_situacao		= 'A';

end if;

return	ie_status_tasy_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_status_tasy ( nr_seq_status_p bigint) FROM PUBLIC;

