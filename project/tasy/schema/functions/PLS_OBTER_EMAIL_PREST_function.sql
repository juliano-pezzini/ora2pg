-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_email_prest ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text) RETURNS varchar AS $body$
DECLARE

 
ds_email_w	varchar(4000);
ds_email_ww	varchar(255);

C01 CURSOR FOR 
SELECT	ds_email 
from	compl_pessoa_fisica 
where	cd_pessoa_fisica = cd_pessoa_fisica_p 
and 	(ds_email IS NOT NULL AND ds_email::text <> '') 
and	ie_tipo_complemento in ('2','9') 
order by 1;

 
 

BEGIN 
 
if (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then 
	ds_email_w :=	 substr(obter_dados_pf_pj_estab(cd_estabelecimento_p,null,cd_cgc_p,'M'),1,255);
else 
	open C01;
	loop 
	fetch C01 into	 
		ds_email_ww;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		ds_email_w := substr((ds_email_w || ds_email_ww || ';'),1,4000);
 
		end;
	end loop;
	close C01;
 
	ds_email_w := substr(ds_email_w,1,length(ds_email_w) - 1);
end if;
 
return	ds_email_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_email_prest ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text) FROM PUBLIC;
