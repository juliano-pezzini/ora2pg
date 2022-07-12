-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION med_obter_desc_medicamento (nr_seq_medic_p bigint) RETURNS varchar AS $body$
DECLARE


ds_medicamento_w	varchar(100);


BEGIN

select	ds_material
into STRICT	ds_medicamento_w
from	med_medic_padrao
where	nr_sequencia	= nr_seq_medic_p;

return	ds_medicamento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION med_obter_desc_medicamento (nr_seq_medic_p bigint) FROM PUBLIC;
