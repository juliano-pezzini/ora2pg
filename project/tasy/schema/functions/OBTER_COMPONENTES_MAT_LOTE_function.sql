-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_componentes_mat_lote ( nr_lote_producao_p bigint) RETURNS varchar AS $body$
DECLARE


Resultado_w	 	varchar(2000);
ds_material_w		varchar(100);

c01 CURSOR FOR

SELECT	substr(obter_desc_redu_material(cd_material),1,20)
from	lote_producao_comp
where	nr_lote_producao = nr_lote_producao_p;


BEGIN

--Resultado_w := '';
open C01;
loop
fetch C01 into
	ds_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	Resultado_w := Resultado_w || ds_material_w || ', ';

	end;
end loop;

return resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_componentes_mat_lote ( nr_lote_producao_p bigint) FROM PUBLIC;
