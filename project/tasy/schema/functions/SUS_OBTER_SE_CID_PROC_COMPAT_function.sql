-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_se_cid_proc_compat (cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_doenca_cid_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1)	:= 'N';
qt_cid_proc_compat_w	integer;
qt_compatibilidade_w	integer;


BEGIN
select	count(*)
into STRICT	qt_compatibilidade_w
from	sus_procedimento_cid
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p;

if (qt_compatibilidade_w	> 0) then
	begin
	select	count(*)
	into STRICT	qt_cid_proc_compat_w
	from	sus_procedimento_cid
	where	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p
	and	cd_doenca_cid		= cd_doenca_cid_p;
	end;
else
	begin
	ds_Retorno_w	:= 'S';
	end;
end if;

if (qt_compatibilidade_w	> 0) and (qt_cid_proc_compat_w	> 0) then
	begin
	ds_retorno_w	:= 'S';
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_se_cid_proc_compat (cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_doenca_cid_p text) FROM PUBLIC;
