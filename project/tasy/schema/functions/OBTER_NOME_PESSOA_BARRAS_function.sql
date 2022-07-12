-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_pessoa_barras ( cd_barras_p bigint, ie_tipo_doc_interno_p text) RETURNS varchar AS $body$
DECLARE
	
 
nm_pessoa_fisica_w	varchar(255):=null;
ie_tipo_doc_interno_w	varchar(15):= 'B';
						

BEGIN 
 
if (ie_tipo_doc_interno_p IS NOT NULL AND ie_tipo_doc_interno_p::text <> '') then 
	ie_tipo_doc_interno_w := ie_tipo_doc_interno_p;
end if;	
 
if (coalesce(cd_barras_p,0) > 0) then 
	if (ie_tipo_doc_interno_w = 'B') then 
		select 	max(SUBSTR(OBTER_NOME_PF(b.CD_PESSOA_FISICA), 0, 255)) 
		into STRICT	nm_pessoa_fisica_w 
		from	pessoa_fisica b, 
			usuario a 
		where	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
		and	Campo_numerico_parametro(a.cd_barras,'999999999999999999999999999D9999') = cd_barras_p;
	elsif (ie_tipo_doc_interno_w = 'C') then 
		select 	max(SUBSTR(OBTER_NOME_PF(b.CD_PESSOA_FISICA), 0, 255)) 
		into STRICT	nm_pessoa_fisica_w 
		from	pessoa_fisica b, 
			medico a 
		where	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
		and	Campo_numerico_parametro(a.nr_crm,'999999999999999999999999999D9999') = cd_barras_p;
	end if;	
		 
end if;	
 
return 	nm_pessoa_fisica_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_pessoa_barras ( cd_barras_p bigint, ie_tipo_doc_interno_p text) FROM PUBLIC;
