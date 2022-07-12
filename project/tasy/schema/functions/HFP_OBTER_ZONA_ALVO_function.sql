-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hfp_obter_zona_alvo ( nr_seq_paciente_p bigint) RETURNS varchar AS $body$
DECLARE

vl_zona_min	smallint;
vl_zona_max	smallint;
ds_resultado	varchar(10);

BEGIN
ds_resultado := '';

if (coalesce(nr_seq_paciente_p,0) > 0) then
	begin

	select	vl_zona_alvo_min,
		vl_zona_alvo_max
	into STRICT	vl_zona_min,
		vl_zona_max
	from	hfp_paciente
	where	nr_sequencia = nr_seq_paciente_p;

	if (vl_zona_min > 0 AND vl_zona_max > 0) then
		ds_resultado := (vl_zona_min || ' - ' || vl_zona_max);
	end if;
	end;
end if;

return ds_resultado;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hfp_obter_zona_alvo ( nr_seq_paciente_p bigint) FROM PUBLIC;
