-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION schematic_obter_se_pai_wtj (nr_seq_objeto_atual_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w 		varchar(1) := 'N';
nr_seq_obj_pai_w	bigint;
ie_tipo_objeto_w	varchar(15);

c01 CURSOR FOR
SELECT	nr_seq_obj_sup
from	objeto_schematic
where	nr_sequencia = nr_seq_objeto_atual_p;


BEGIN

select	ie_tipo_objeto
into STRICT	ie_tipo_objeto_w
from	objeto_schematic
where	nr_sequencia	= nr_seq_objeto_atual_p;

if (ie_tipo_objeto_w = 'TV') then
	ds_retorno_w := 'S';
else
	begin
		open C01;
		loop
		fetch C01 into
			nr_seq_obj_pai_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			ds_retorno_w := schematic_obter_se_pai_wtj(nr_seq_obj_pai_w);

			end;
		end loop;
		close C01;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION schematic_obter_se_pai_wtj (nr_seq_objeto_atual_p bigint) FROM PUBLIC;
