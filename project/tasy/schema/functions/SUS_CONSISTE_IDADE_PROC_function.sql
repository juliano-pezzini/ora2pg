-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_consiste_idade_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_erro_w		varchar(2)	:= 'S';
qt_idade_pac_w		smallint	:= 0;
qt_idade_minima_w	smallint	:= 0;
qt_idade_maxima_w	smallint	:= 0;


BEGIN

/* Obter dados do paciente */

begin
select	obter_idade(a.dt_nascimento,clock_timestamp(),'A')
into STRICT	qt_idade_pac_w
from	pessoa_fisica		a
where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p;
exception
	when others then
		qt_idade_pac_w	:= 0;
end;

/* Obter dados do procedimento */

begin
select	substr(Sus_Converte_Idade_Anos(b.qt_idade_minima,'C'),1,10),
	substr(Sus_Converte_Idade_Anos(b.qt_idade_maxima,'C'),1,10)
into STRICT	qt_idade_minima_w,
	qt_idade_maxima_w
from	sus_procedimento	b,
	procedimento		a
where	a.cd_procedimento	= cd_procedimento_p
and	a.ie_origem_proced	= ie_origem_proced_p
and	a.cd_procedimento	= b.cd_procedimento
and	a.ie_origem_proced	= b.ie_origem_proced;
exception
	when others then
		qt_idade_minima_w	:= 0;
		qt_idade_maxima_w	:= 0;
end;

if	(qt_idade_pac_w > qt_idade_maxima_w AND qt_idade_maxima_w <> 0) or
	(qt_idade_pac_w < qt_idade_minima_w AND qt_idade_minima_w <> 0) then
	ds_erro_w	:= 'N';
end if;

return ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_consiste_idade_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;
