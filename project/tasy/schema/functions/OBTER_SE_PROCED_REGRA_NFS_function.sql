-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_proced_regra_nfs ( cd_procedimento_p bigint) RETURNS varchar AS $body$
DECLARE


/*Identifica se o procedimento está em alguma regra de agrupamento no cadastro de convenio preços e regras*/

qt_existe_w		bigint;
ie_existe_w		varchar(1) := 'N';


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	parametro_nfs_lista
where	cd_procedimento = cd_procedimento_p;

if (qt_existe_w > 0) then
	ie_existe_w := 'S';
end if;


return	ie_existe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_proced_regra_nfs ( cd_procedimento_p bigint) FROM PUBLIC;
