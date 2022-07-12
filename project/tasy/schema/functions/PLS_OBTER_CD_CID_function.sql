-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_cd_cid ( id_cid_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(50):= null;


BEGIN

	select 	max(cd_cid)
	into STRICT	ds_retorno_w
	from	pls_cad_cid_monitoramento
	where	nr_id_cid_10 = id_cid_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_cd_cid ( id_cid_p text) FROM PUBLIC;

