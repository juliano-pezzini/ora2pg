-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_anestesia_proc_interno ( nr_seq_proc_interno_p bigint ) RETURNS varchar AS $body$
DECLARE


cd_tipo_anestesia_w	varchar(2);


BEGIN

if (nr_seq_proc_interno_p > 0) then
	select	max(cd_tipo_anestesia)
	into STRICT	cd_tipo_anestesia_w
	from	proc_interno
	where	nr_sequencia	=	nr_seq_proc_interno_p;
end if;

return	cd_tipo_anestesia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_anestesia_proc_interno ( nr_seq_proc_interno_p bigint ) FROM PUBLIC;

