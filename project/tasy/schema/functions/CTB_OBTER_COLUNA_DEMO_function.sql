-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_coluna_demo ( nr_seq_demo_p bigint, nr_seq_coluna_p bigint) RETURNS varchar AS $body$
DECLARE



ds_coluna_w			varchar(50);


BEGIN

select coalesce(a.ds_coluna, to_char(ctb_obter_mes_ref(a.nr_seq_mes_ref),'mm/yyyy'))
into STRICT	ds_coluna_w
from	ctb_demo_mes a
where	a.NR_SEQ_COLUNA	= nr_seq_coluna_p
and	a.NR_SEQ_DEMO		= nr_seq_demo_p;

return	ds_coluna_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_coluna_demo ( nr_seq_demo_p bigint, nr_seq_coluna_p bigint) FROM PUBLIC;

