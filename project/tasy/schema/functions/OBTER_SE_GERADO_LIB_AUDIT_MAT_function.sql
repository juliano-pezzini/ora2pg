-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_gerado_lib_audit_mat ( nr_seq_item_p bigint, ie_auditoria_p text) RETURNS varchar AS $body$
DECLARE


ie_ajuste_w	varchar(1)	:=	'N';
qt_audit_w	bigint	:=	0;


BEGIN

if (ie_auditoria_p in ('A','S')) then
	begin
	select 	count(*)
	into STRICT	qt_audit_w
	from 	auditoria_matpaci
	where 	nr_seq_matpaci = nr_seq_item_p;
	exception
		when others then
		 	qt_audit_w:= 0;
	end;
end if;

if (qt_audit_w = 0) then
	ie_ajuste_w:= 'S';
end if;

return ie_ajuste_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_gerado_lib_audit_mat ( nr_seq_item_p bigint, ie_auditoria_p text) FROM PUBLIC;
