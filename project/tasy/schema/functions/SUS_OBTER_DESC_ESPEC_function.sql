-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_desc_espec ( cd_especialidade_p bigint) RETURNS varchar AS $body$
DECLARE



ds_retorno_w	varchar(40);



BEGIN

select	coalesce(max(ds_especialidade),'')
into STRICT	ds_retorno_w
from	sus_especialidade
where	cd_especialidade	= cd_especialidade_p;

return	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_desc_espec ( cd_especialidade_p bigint) FROM PUBLIC;
