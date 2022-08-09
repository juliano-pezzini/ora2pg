-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rop_calcular_inv_reposicao ( nr_seq_inventario_p bigint, nr_sequencia_p bigint, qt_contagem_p bigint, nm_usuario_p text, qt_repor_p INOUT bigint) AS $body$
DECLARE


pr_reposicao_w		smallint;
nr_seq_roupa_w		bigint;
nr_seq_kit_w		bigint;
qt_minimo_w		integer;
qt_maximo_w		integer;
qt_repor_w		integer := 0;


BEGIN

select	pr_reposicao
into STRICT	pr_reposicao_w
from	rop_inv_reposicao
where	nr_sequencia = nr_seq_inventario_p;

select	coalesce(max(nr_seq_roupa),0),
	max(qt_minimo),
	max(qt_maximo)
into STRICT	nr_seq_roupa_w,
	qt_minimo_w,
	qt_maximo_w
from	rop_inv_reposicao_item
where	nr_sequencia = nr_sequencia_p
and	(nr_seq_roupa IS NOT NULL AND nr_seq_roupa::text <> '')
and	qt_contagem_p < qt_maximo
and	qt_contagem_p > 0;

if (nr_seq_roupa_w > 0) then
	qt_repor_w	:= 0;
	qt_repor_w	:= dividir((qt_maximo_w * pr_reposicao_w),100) - qt_contagem_p;
end if;

select	coalesce(max(nr_seq_kit),0),
	max(qt_minimo),
	max(qt_maximo)
into STRICT	nr_seq_kit_w,
	qt_minimo_w,
	qt_maximo_w
from	rop_inv_reposicao_item
where	nr_Sequencia = nr_Sequencia_p
and	(nr_seq_kit IS NOT NULL AND nr_seq_kit::text <> '')
and	qt_contagem_p < qt_maximo
and	qt_contagem_p > 0;

if (nr_seq_kit_w > 0) then
	qt_repor_w	:= 0;
	qt_repor_w	:= dividir((qt_maximo_w * pr_reposicao_w),100) - qt_contagem_p;
end if;

qt_repor_p := qt_repor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rop_calcular_inv_reposicao ( nr_seq_inventario_p bigint, nr_sequencia_p bigint, qt_contagem_p bigint, nm_usuario_p text, qt_repor_p INOUT bigint) FROM PUBLIC;
