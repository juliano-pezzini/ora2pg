-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_filme_abramge (nr_interno_conta_p bigint) RETURNS bigint AS $body$
DECLARE


vl_filme_w	double precision	:= 0;


BEGIN

select 	coalesce(sum(vl_item),0)
into STRICT	vl_filme_w
from 	w_conta_abramge_item a
where 	nr_interno_conta 	= nr_interno_conta_p
and 	ie_tipo_item		= 2
and 	substr(upper(ds_item),1,5) = 'FILME'
and 	cd_grupo_item = 5
and 	vl_item > 0;

return	vl_filme_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_filme_abramge (nr_interno_conta_p bigint) FROM PUBLIC;
