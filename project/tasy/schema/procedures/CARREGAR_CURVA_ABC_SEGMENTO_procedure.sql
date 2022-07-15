-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE carregar_curva_abc_segmento ( nr_seq_segmento_p bigint, cd_material_p bigint, ie_curva_abc_p text) AS $body$
DECLARE


qt_existe_w			bigint;



BEGIN

select	count(*)
into STRICT	qt_existe_w
from	segmento_compras_estrut
where (cd_material = cd_material_p)
and (nr_seq_segmento = nr_seq_segmento_p);

if (qt_existe_w > 0) and (ie_curva_abc_p IS NOT NULL AND ie_curva_abc_p::text <> '') then
	update	segmento_compras_estrut
	set	ie_curva_abc = ie_curva_abc_p
	where (cd_material = cd_material_p)
	and (nr_seq_segmento = nr_seq_segmento_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carregar_curva_abc_segmento ( nr_seq_segmento_p bigint, cd_material_p bigint, ie_curva_abc_p text) FROM PUBLIC;

