-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lista_pedido_kit_agenda ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


nr_sequencia_ww 	bigint := 0;
nr_sequencia_w		bigint;
ds_kit_material_w	varchar(80);
ds_retorno_w		varchar(2000) := null;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	substr(obter_descricao_padrao('KIT_MATERIAL','DS_KIT_MATERIAL',b.cd_kit_material),1,80) ds_kit_material
from	agenda_pac_pedido a,
	agenda_pac_pedido_kit b
where	a.nr_sequencia	= b.nr_seq_pedido
and	a.nr_seq_agenda = nr_sequencia_p
order by 1;


BEGIN

OPEN C01;
LOOP
FETCH C01 into
	nr_sequencia_w,
	ds_kit_material_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	if (nr_sequencia_ww = 0) or (nr_sequencia_ww <> nr_sequencia_w) then
		ds_retorno_w	:= substr(ds_retorno_w || 'Seq : '|| nr_sequencia_w || chr(13) || chr(10),1,2000);
	end if;
	ds_retorno_w	:= substr(ds_retorno_w || ds_kit_material_w || chr(13) || chr(10),1,2000);
	nr_sequencia_ww := nr_sequencia_w;
end loop;
close c01;

return	substr(ds_retorno_w,1,2000);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lista_pedido_kit_agenda ( nr_sequencia_p bigint) FROM PUBLIC;

