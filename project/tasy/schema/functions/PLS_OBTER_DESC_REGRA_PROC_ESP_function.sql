-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_desc_regra_proc_esp ( nr_sequencia_p text ) RETURNS varchar AS $body$
DECLARE


ds_regra_w		varchar(255);


BEGIN

begin
	select 	substr(ds_regra,1,255)
	into STRICT	ds_regra_w
	from 	pls_oc_proc_especialidade
	where 	nr_sequencia	= nr_sequencia_p
	and	ie_situacao	= 'A';
exception
when others then
	ds_regra_w 	:= '';
end;

return 	ds_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_desc_regra_proc_esp ( nr_sequencia_p text ) FROM PUBLIC;

