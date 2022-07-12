-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pcs_obter_composicao_formula (ds_macro_p text) RETURNS varchar AS $body$
DECLARE


ds_resultado_w	varchar(3999);

BEGIN

Select	ds_composicao
into STRICT	ds_resultado_w
from	pcs_formulas
where	upper(ds_macro) = upper(ds_macro_p);

return	ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pcs_obter_composicao_formula (ds_macro_p text) FROM PUBLIC;

