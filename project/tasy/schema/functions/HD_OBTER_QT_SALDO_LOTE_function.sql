-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_qt_saldo_lote ( nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w		bigint;
qt_material_lote_w	bigint;
qt_material_utiliz_w	bigint;

BEGIN
qt_material_utiliz_w	:= 0;
qt_material_lote_w	:= 0;
if (coalesce(nr_sequencia_p,0) > 0) then

	select 	coalesce(sum(coalesce(qt_material,0)),0)
	into STRICT	qt_material_lote_w
	from	hd_lote_medic_ext
	where	nr_sequencia = nr_sequencia_p;


	select 	coalesce(sum(coalesce(qt_medicamento,0)),0)
	into STRICT	qt_material_utiliz_w
	from	hd_dialise_med_ext
	where	nr_seq_lote = nr_sequencia_p;

end if;

if (coalesce(qt_material_lote_w,0) > 0) or (coalesce(qt_material_utiliz_w,0) > 0) then
	ds_retorno_w	:= (qt_material_lote_w - qt_material_utiliz_w);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_qt_saldo_lote ( nr_sequencia_p bigint) FROM PUBLIC;

