-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_lote_inventario ( nr_seq_lote_p bigint, nr_seq_inventario_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w		double precision;
ie_contagem_atual_w	varchar(15);


BEGIN

select	ie_contagem_atual
into STRICT	ie_contagem_atual_w
from	inventario
where	nr_sequencia = nr_seq_inventario_p;

select	coalesce(sum(CASE WHEN ie_contagem_atual_w=1 THEN qt_contagem WHEN ie_contagem_atual_w=2 THEN qt_recontagem WHEN ie_contagem_atual_w=3 THEN qt_seg_recontagem WHEN ie_contagem_atual_w=4 THEN qt_terc_recontagem  ELSE qt_contagem END ),0)
into STRICT	qt_retorno_w
from	inventario_material_lote
where	nr_seq_inventario = nr_seq_inventario_p
and	nr_seq_lote_fornec = nr_seq_lote_p;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_lote_inventario ( nr_seq_lote_p bigint, nr_seq_inventario_p bigint) FROM PUBLIC;

