-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_unid_med_atc ( cd_unidade_medida_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(80);

BEGIN

select	substr(ds_unid_med,1,80)
into STRICT	ds_retorno_w
from	atc_unid_med
where	cd_unid_med	= cd_unidade_medida_p;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_unid_med_atc ( cd_unidade_medida_p text) FROM PUBLIC;
