-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_limpar_nf_oci_cb (nr_sequencia_p bigint) AS $body$
DECLARE


qt_existe_w	bigint;

BEGIN
select	count(*)
into STRICT	qt_existe_w
from	ordem_compra_item_cb
where	nr_seq_nota = nr_sequencia_p;

if (qt_existe_w > 0) then
	update	ordem_compra_item_cb
	set	nr_seq_nota  = NULL,
		nr_item_nf  = NULL
	where	nr_seq_nota = nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_limpar_nf_oci_cb (nr_sequencia_p bigint) FROM PUBLIC;

