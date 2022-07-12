-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_taxa_item ( nr_seq_taxa_item_p bigint) RETURNS bigint AS $body$
DECLARE


tx_item_w			double precision;


BEGIN

select	coalesce(max(tx_item),100)
into STRICT	tx_item_w
from	pls_taxa_item
where	nr_sequencia	= nr_seq_taxa_item_p;

return	tx_item_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_taxa_item ( nr_seq_taxa_item_p bigint) FROM PUBLIC;

