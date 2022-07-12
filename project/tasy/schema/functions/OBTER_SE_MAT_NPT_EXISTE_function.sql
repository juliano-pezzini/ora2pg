-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_mat_npt_existe ( cd_material_p bigint, nr_seq_nut_pac_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1) := 'N';

BEGIN

select	coalesce(max('S'),'N')
into STRICT	ie_retorno_w
from	nut_pac_elem_mat
where	nr_seq_nut_pac = nr_seq_nut_pac_p
and		cd_material = cd_material_p
and		nr_sequencia <> nr_sequencia_p;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_mat_npt_existe ( cd_material_p bigint, nr_seq_nut_pac_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

