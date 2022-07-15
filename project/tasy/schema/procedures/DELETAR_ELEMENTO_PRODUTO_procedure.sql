-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE deletar_elemento_produto ( nr_seq_material_p bigint, nr_seq_nut_pac_p bigint) AS $body$
DECLARE


nr_sequencia_w	bigint;
qt_w			bigint;


BEGIN

select	max(b.nr_sequencia)
into STRICT	nr_sequencia_w
from	nut_elem_material c,
		nut_Elemento b,
		nut_pac_elem_mat a
where	a.cd_material	= c.cd_material
and		a.nr_seq_nut_pac	= nr_seq_nut_pac_p
and		c.nr_seq_elemento	= b.nr_sequencia
and		a.nr_sequencia		= nr_seq_material_p
and		exists (SELECT 1 from nut_pac_elemento x where x.nr_seq_nut_pac = nr_seq_nut_pac_p and x.nr_seq_elemento = b.nr_sequencia)
and		coalesce(c.ie_tipo,'NPT')	= 'NPT';

select	count(*)
into STRICT	qt_w
from	nut_elem_material c,
		nut_Elemento b,
		nut_pac_elem_mat a
where	a.cd_material	= c.cd_material
and		a.nr_seq_nut_pac	= nr_seq_nut_pac_p
and		c.nr_seq_elemento	= b.nr_sequencia
and		a.nr_sequencia		<> nr_seq_material_p
and		b.nr_sequencia 	= nr_sequencia_w
and		exists (SELECT 1 from nut_pac_elemento x where x.nr_seq_nut_pac = nr_seq_nut_pac_p and x.nr_seq_elemento = b.nr_sequencia)
and		coalesce(c.ie_tipo,'NPT')	= 'NPT';

if (qt_w = 0) then
	delete from nut_pac_elemento
	where 	nr_seq_elemento = nr_sequencia_w
	and		nr_seq_nut_pac = nr_seq_nut_pac_p;
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE deletar_elemento_produto ( nr_seq_material_p bigint, nr_seq_nut_pac_p bigint) FROM PUBLIC;

