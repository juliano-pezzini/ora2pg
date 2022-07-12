-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_desc_motivo_falta ( nr_seq_motivo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_motivo_w			varchar(255);


BEGIN

select	ds_motivo
into STRICT	ds_motivo_w
from	rxt_motivo_falta
where	nr_sequencia = nr_seq_motivo_p;

return	ds_motivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_desc_motivo_falta ( nr_seq_motivo_p bigint) FROM PUBLIC;

