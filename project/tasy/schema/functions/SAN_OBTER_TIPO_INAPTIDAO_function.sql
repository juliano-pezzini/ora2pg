-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_tipo_inaptidao (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

 
nm_pessoa_fisica_w	varchar(255);
dt_nascimneto_w		varchar(255);
ie_sexo_w			varchar(1);
ie_retorno_w		varchar(1);
dt_limite_inap_w	varchar(255);

C01 CURSOR FOR 
	SELECT 	ie_definitivo, 
			to_char(dt_limite_inaptidao,'dd/mm/yyyy') 
	from 	san_doador_inapto 
	where (cd_pessoa_fisica = cd_pessoa_fisica_p 
	or		upper(nm_pessoa_fisica) = nm_pessoa_fisica_w) 
	and		dt_nascimento = to_date(dt_nascimneto_w) 
	and		coalesce(ie_sexo, ie_sexo_w) = ie_sexo_w 
	and		coalesce(dt_inativacao::text, '') = '';


BEGIN 
 
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then 
	select 	upper(elimina_acentuacao(substr(obter_nome_pf(cd_pessoa_fisica),1,100))), 
			dt_nascimento, 
			ie_sexo 
	into STRICT	nm_pessoa_fisica_w, 
			dt_nascimneto_w, 
			ie_sexo_w 
	from 	pessoa_fisica 
	where 	cd_pessoa_fisica = cd_pessoa_fisica_p;
	 
	open C01;
	loop 
	fetch C01 into	 
		ie_retorno_w, 
		dt_limite_inap_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
			if (ie_retorno_w = 'D') then 
				return	ie_retorno_w;
			end if;
			 
			if (ie_retorno_w = 'T') and (dt_limite_inap_w >= to_char(clock_timestamp(), 'dd/mm/yyyy')) then 
				return ie_retorno_w;
			elsif (ie_retorno_w = 'T') and (dt_limite_inap_w < to_char(clock_timestamp(), 'dd/mm/yyyy')) then 
				ie_retorno_w := 'N';
			end if;
		 
		end;
	end loop;
	close C01;
	 
end if;
 
return	ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_tipo_inaptidao (cd_pessoa_fisica_p text) FROM PUBLIC;

