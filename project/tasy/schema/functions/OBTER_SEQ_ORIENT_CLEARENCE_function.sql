-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_orient_clearence ( cd_material_p bigint, cd_estabelecimento_p bigint, qt_clearence_p bigint) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_seq_ficha_tecnica_w	bigint;


BEGIN

select	coalesce(max(nr_seq_ficha_tecnica),0)
into STRICT	nr_seq_ficha_tecnica_w
from	material
where	cd_material	= cd_material_p;

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_sequencia_w
from	medic_clearance_creat
where	nr_seq_ficha		= nr_seq_ficha_tecnica_w
and	qt_clearence_p between qt_clearance_min and qt_clearance_max;

return	nr_sequencia_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_orient_clearence ( cd_material_p bigint, cd_estabelecimento_p bigint, qt_clearence_p bigint) FROM PUBLIC;

