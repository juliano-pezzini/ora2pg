-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_motivo_solic_ext (nr_seq_motivo_solic_externa_p bigint) RETURNS varchar AS $body$
DECLARE

ds_motivo_solic_ext_w	varchar(90);

BEGIN

select	ds_motivo
into STRICT	ds_motivo_solic_ext_w
from	motivo_transf_externa
where	nr_sequencia = nr_seq_motivo_solic_externa_p;


return	ds_motivo_solic_ext_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_motivo_solic_ext (nr_seq_motivo_solic_externa_p bigint) FROM PUBLIC;

