-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_schematic_sup ( nr_seq_objeto_p bigint, nr_seq_superior_p bigint) RETURNS varchar AS $body$
DECLARE


ie_superior_w 	varchar(1) := 'N';
nr_seq_superior_w	bigint := 0;


BEGIN
nr_seq_superior_w := nr_seq_objeto_p;

while(nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') and (ie_superior_w = 'N') loop
	begin
	select	nr_seq_obj_sup
	into STRICT	nr_seq_superior_w
	from	objeto_schematic
	where	nr_sequencia = nr_seq_superior_w;

	if (nr_seq_superior_w = nr_seq_superior_p) then
		ie_superior_w := 'S';
	end if;
	end;
end loop;

return ie_superior_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_schematic_sup ( nr_seq_objeto_p bigint, nr_seq_superior_p bigint) FROM PUBLIC;

