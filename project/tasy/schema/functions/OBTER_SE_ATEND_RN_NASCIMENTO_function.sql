-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atend_rn_nascimento (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

qt_reg_w		bigint;
cd_pessoa_fisica_w	varchar(10);
qt_idade_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_reg_w
from	nascimento
where	nr_atend_rn	= nr_atendimento_p
and	nr_atendimento	<> nr_Atend_rn;

if (qt_reg_w	> 0) then
	return  'S';

else
	return 'N';

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atend_rn_nascimento (nr_atendimento_p bigint) FROM PUBLIC;

