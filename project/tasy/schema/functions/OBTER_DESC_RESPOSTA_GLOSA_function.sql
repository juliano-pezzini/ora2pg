-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_resposta_glosa (cd_resposta_p text) RETURNS varchar AS $body$
DECLARE


ds_resposta_w	varchar(2000);


BEGIN

select	coalesce(max(ds_resposta),'')
into STRICT	ds_resposta_w
from	motivo_resp_glosa
where	to_char(cd_resposta) = coalesce(cd_resposta_p,'-1');


return ds_resposta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_resposta_glosa (cd_resposta_p text) FROM PUBLIC;

