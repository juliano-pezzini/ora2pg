-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_item_eif ( nr_seq_item_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_apres_w	bigint;


BEGIN

select	coalesce(max(nr_seq_apres),999)
into STRICT	nr_seq_apres_w
from	eif_escala_item
where	nr_sequencia = nr_seq_item_p;

return	nr_seq_apres_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_item_eif ( nr_seq_item_p bigint) FROM PUBLIC;
