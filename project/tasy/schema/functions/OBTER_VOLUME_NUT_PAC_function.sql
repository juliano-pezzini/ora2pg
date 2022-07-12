-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_volume_nut_pac (nr_seq_nut_p bigint) RETURNS bigint AS $body$
DECLARE


qt_volume_w	double precision;


BEGIN
if (nr_seq_nut_p IS NOT NULL AND nr_seq_nut_p::text <> '') then
	select	sum(coalesce(qt_volume,0))
	into STRICT	qt_volume_w
	from	nut_paciente_elemento
	where	nr_seq_nut_pac = nr_seq_nut_p;
end if;

return qt_volume_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_volume_nut_pac (nr_seq_nut_p bigint) FROM PUBLIC;
