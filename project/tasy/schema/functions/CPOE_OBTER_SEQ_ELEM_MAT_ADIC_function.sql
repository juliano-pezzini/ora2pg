-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_seq_elem_mat_adic (cd_material_p bigint) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w		nut_elem_material.nr_sequencia%type;


BEGIN

select	max(d.nr_sequencia)
into STRICT	nr_sequencia_w
from	material c,
		nut_elem_material d
where	c.cd_material	= d.cd_material
and		c.cd_material = cd_material_p
and		coalesce(d.ie_situacao, 'A') = 'A'
and		coalesce(d.ie_tipo,'NPT') = 'NPT';

return nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_seq_elem_mat_adic (cd_material_p bigint) FROM PUBLIC;

