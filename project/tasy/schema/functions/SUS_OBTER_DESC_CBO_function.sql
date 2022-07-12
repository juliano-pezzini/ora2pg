-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_desc_cbo ( cd_cbo_p text) RETURNS varchar AS $body$
DECLARE



ds_retorno_w		varchar(255);



BEGIN

select	coalesce(max(substr(ds_cbo,1,255)),'')
into STRICT	ds_retorno_w
from	sus_cbo
where	cd_cbo	= cd_cbo_p;

return	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_desc_cbo ( cd_cbo_p text) FROM PUBLIC;

