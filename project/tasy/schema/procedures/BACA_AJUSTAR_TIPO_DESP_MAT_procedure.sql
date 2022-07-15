-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_tipo_desp_mat () AS $body$
DECLARE


nr_seq_material_w	bigint;
ie_tipo_despesa_w	varchar(5);

c01 CURSOR FOR
SELECT	nr_sequencia,
	ie_tipo_despesa
from	pls_material;


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_material_w,
	ie_tipo_despesa_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	update	pls_conta_mat
	set	ie_tipo_despesa = ie_tipo_despesa_w
	where	nr_seq_material	= nr_seq_material_w;

end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_tipo_desp_mat () FROM PUBLIC;

