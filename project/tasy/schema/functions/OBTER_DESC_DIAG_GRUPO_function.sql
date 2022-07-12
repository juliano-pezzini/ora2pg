-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_diag_grupo (nr_seq_grupo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_grupo_w	varchar(240);


BEGIN

select	coalesce(ds_grupo,'')
into STRICT	ds_grupo_w
from	diagnostico_grupo
where	nr_sequencia = nr_seq_grupo_p;

return ds_grupo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_diag_grupo (nr_seq_grupo_p bigint) FROM PUBLIC;

