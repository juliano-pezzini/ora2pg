-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proc_interno_cirurgia (nr_cirurgia_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_proc_interno_w 	bigint;

BEGIN
	select 	coalesce(max(nr_seq_proc_interno),0)
	into STRICT 	nr_seq_proc_interno_w
	from 	cirurgia
	where 	nr_cirurgia = nr_cirurgia_p;

return	nr_seq_proc_interno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proc_interno_cirurgia (nr_cirurgia_p bigint) FROM PUBLIC;

