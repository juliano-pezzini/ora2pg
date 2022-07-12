-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_qt_min (cd_material_p bigint) RETURNS varchar AS $body$
DECLARE

ie_exibe_quantidade_w	varchar(1);

BEGIN

select 	coalesce(max('S'),'N')
into STRICT	ie_exibe_quantidade_w
from 	regra_mat_quantidade_pepo
where	cd_material = cd_material_p;

return	ie_exibe_quantidade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_qt_min (cd_material_p bigint) FROM PUBLIC;
