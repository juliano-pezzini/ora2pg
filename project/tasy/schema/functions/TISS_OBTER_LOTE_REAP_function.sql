-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_lote_reap ( nr_seq_lote_audit_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_lote_reap_w	bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_lote_reap_w
from	tiss_reap_lote
where	nr_seq_lote_audit	= nr_seq_lote_audit_p;

return	nr_seq_lote_reap_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_lote_reap ( nr_seq_lote_audit_p bigint) FROM PUBLIC;

