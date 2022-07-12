-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_proc_int_lib_conv ( nr_seq_proc_interno_p bigint, cd_convenio_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(10):= 'S';

C01 CURSOR FOR
	SELECT	coalesce(ie_liberar,'S')
	from	proc_interno_lib_conv
	where	nr_seq_proc_interno		= nr_seq_proc_interno_p
	and	coalesce(cd_convenio,cd_convenio_p)	= cd_convenio_p
	order by coalesce(cd_convenio,0);

BEGIN

open C01;
loop
fetch C01 into
	ds_retorno_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_proc_int_lib_conv ( nr_seq_proc_interno_p bigint, cd_convenio_p bigint) FROM PUBLIC;

