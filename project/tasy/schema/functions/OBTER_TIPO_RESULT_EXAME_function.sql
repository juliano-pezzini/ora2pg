-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_result_exame (nr_seq_exame_p bigint, nr_seq_cliente_p bigint) RETURNS varchar AS $body$
DECLARE



ds_tipo_resultado_w			varchar(32000) := '';
ie_tipo_resultado_w			varchar(01)	:= '';
dt_exame_w				timestamp;


c01 CURSOR FOR
	SELECT	dt_exame
	from	med_result_exame
	where	nr_seq_cliente		= nr_seq_cliente_p
	group	by dt_exame
	order 	by dt_exame desc;


BEGIN

open	c01;
loop
fetch	c01 into
	dt_exame_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	coalesce(max(ie_tipo_resultado),'N')
	into STRICT	ie_tipo_resultado_w
	from	med_result_exame
	where	nr_seq_cliente		= nr_seq_cliente_p
	and	nr_seq_exame		= nr_seq_exame_p
	and	dt_exame		= dt_exame_w;

	ds_tipo_resultado_w	:= ds_tipo_resultado_w || ie_tipo_resultado_w || ';';

	end;
end loop;
close c01;

return	ds_tipo_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_result_exame (nr_seq_exame_p bigint, nr_seq_cliente_p bigint) FROM PUBLIC;
