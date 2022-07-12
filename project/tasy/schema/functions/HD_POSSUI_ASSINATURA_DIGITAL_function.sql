-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_possui_assinatura_digital (nr_seq_dialise_p bigint) RETURNS varchar AS $body$
DECLARE


ie_assinatura_w	varchar(1);


BEGIN

if (nr_seq_dialise_p IS NOT NULL AND nr_seq_dialise_p::text <> '') then
	SELECT	CASE WHEN coalesce(max(nr_sequencia)::text, '') = '' THEN  'N'  ELSE 'S' END
	into STRICT	ie_assinatura_w
	from	hd_assinatura_digital
	where	nr_seq_dialise = nr_seq_dialise_p;
end if;

return	ie_assinatura_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_possui_assinatura_digital (nr_seq_dialise_p bigint) FROM PUBLIC;
