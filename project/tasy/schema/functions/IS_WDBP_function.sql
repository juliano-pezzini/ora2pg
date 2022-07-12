-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION is_wdbp (nr_sequence bigint) RETURNS varchar AS $body$
DECLARE


ds_return varchar(2) := 'N';


BEGIN

	begin
		select	'S'
		into STRICT	ds_return
		from	objeto_schematic
		where	nr_sequencia = nr_sequence
		and	ie_tipo_componente = 'WDBP';

	exception
	when no_data_found then
		return ds_return;
	end;

return ds_return;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION is_wdbp (nr_sequence bigint) FROM PUBLIC;
