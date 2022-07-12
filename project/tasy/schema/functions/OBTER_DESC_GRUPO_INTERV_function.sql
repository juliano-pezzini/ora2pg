-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_grupo_interv (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_grupo_w	varchar(255);


BEGIN

select	coalesce(max(ds_grupo),obter_desc_expressao(781470)/*'SAE sem grupo'*/
)
into STRICT	ds_grupo_w
from	grupo_interv_enf
where	nr_sequencia	= nr_sequencia_p;

return	ds_grupo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_grupo_interv (nr_sequencia_p bigint) FROM PUBLIC;

