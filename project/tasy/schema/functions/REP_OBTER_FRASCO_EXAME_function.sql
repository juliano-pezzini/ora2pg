-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rep_obter_frasco_exame ( nr_seq_exame_p bigint, cd_material_exame_p text) RETURNS varchar AS $body$
DECLARE


ds_frasco_w		varchar(255);
nr_seq_material_w	bigint;


BEGIN

if (coalesce(nr_seq_exame_p,0) > 0) and (cd_material_exame_p IS NOT NULL AND cd_material_exame_p::text <> '') then

	select	max(nr_sequencia)
	into STRICT	nr_seq_material_w
	from	material_exame_lab
	where	cd_material_exame = cd_material_exame_p;

	select	max(LAB_Obter_Frasco_Exame(nr_seq_exame_p, nr_seq_material_w))
	into STRICT	ds_frasco_w
	;

end if;

return	ds_frasco_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rep_obter_frasco_exame ( nr_seq_exame_p bigint, cd_material_exame_p text) FROM PUBLIC;
