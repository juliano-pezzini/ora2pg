-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_edicao_cbhpm (cd_edicao_p bigint, dt_inicio_vigencia_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_edicao_cbhpm_w	varchar(80);
ie_origem_proced_w	bigint;


BEGIN

select 	coalesce(max(ie_origem_proced),1)
into STRICT	ie_origem_proced_w
from 	edicao_amb
where 	ie_situacao = 'A'
and 	cd_edicao_amb = cd_edicao_p;

ds_edicao_cbhpm_w:= null;

if	((cd_edicao_p in (2004,2005)) or (ie_origem_proced_w = 5)) then

	select 	max(ds_edicao_cbhpm)
	into STRICT	ds_edicao_cbhpm_w
	from 	cbhpm_edicao
	where 	dt_vigencia = dt_inicio_vigencia_p;

end if;

return	ds_edicao_cbhpm_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_edicao_cbhpm (cd_edicao_p bigint, dt_inicio_vigencia_p timestamp) FROM PUBLIC;

