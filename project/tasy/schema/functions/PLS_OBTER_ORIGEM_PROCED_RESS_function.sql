-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_origem_proced_ress ( cd_procedimento_p text) RETURNS varchar AS $body$
DECLARE


ie_origem_proced_w		varchar(15);


BEGIN

select 	max(ie_origem_proced)
into STRICT	ie_origem_proced_w
from 	procedimento
where 	cd_procedimento	= cd_procedimento_p;

return	ie_origem_proced_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_origem_proced_ress ( cd_procedimento_p text) FROM PUBLIC;

