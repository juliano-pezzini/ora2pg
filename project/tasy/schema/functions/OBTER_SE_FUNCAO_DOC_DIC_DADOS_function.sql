-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_funcao_doc_dic_dados (cd_funcao_p bigint) RETURNS varchar AS $body$
DECLARE


ie_doc_w	varchar(1) := 'N';


BEGIN
if (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') then
	begin
	if (cd_funcao_p in (10018,934,11111,-260,-1,-100,-101)) then
		begin
		ie_doc_w := 'S';
		end;
	else
		begin
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_doc_w
		from	funcao
		where	cd_funcao = cd_funcao_p;
		end;
	end if;
	end;
end if;
return ie_doc_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_funcao_doc_dic_dados (cd_funcao_p bigint) FROM PUBLIC;

