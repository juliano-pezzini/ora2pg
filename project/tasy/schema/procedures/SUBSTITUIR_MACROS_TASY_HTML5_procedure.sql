-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE substituir_macros_tasy_html5 ( ds_macro_p text, cd_pessoa_fisica_p text, cd_pessoa_usuario_p text, nr_atendimento_p bigint, ds_texto_saida_p INOUT text) AS $body$
DECLARE

	C01 CURSOR FOR 
		SELECT nm_macro, nm_atributo 
		from macro_prontuario 
		where nm_atributo <> 'IE_SUBS' 
		and	 upper(nm_macro) = upper(ds_macro_p) 
		order by position('@FORMULA' in upper(nm_macro)),length(nm_macro) desc,nm_macro;
		
	nm_macro_w			varchar(50);
	nm_atributo_w		varchar(50);
	ds_resultado_w		varchar(256);
	ds_parametros_w		varchar(2000);


BEGIN 
 
  
	 
	open C01;
	loop 
	 
	fetch C01 into 
		nm_macro_w, 
		nm_atributo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		if (upper(nm_atributo_w) = 'CD_PESSOA_FISICA') then 
			ds_resultado_w := cd_pessoa_fisica_p;
		elsif (upper(nm_atributo_w) = 'NR_ATENDIMENTO') then 
			ds_resultado_w := to_char(nr_atendimento_p);
		elsif (upper(nm_atributo_w) = 'CD_PESSOA_USUARIO') then 
			ds_resultado_w := cd_pessoa_usuario_p;
		end if;
		 
		 
		ds_parametros_w	:= substituir_macro_texto_tasy(UPPER(nm_macro_w),nm_atributo_w,ds_resultado_w);
		 
	 
		end;
	end loop;
	close C01;
	 
	ds_texto_saida_p := ds_parametros_w;
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE substituir_macros_tasy_html5 ( ds_macro_p text, cd_pessoa_fisica_p text, cd_pessoa_usuario_p text, nr_atendimento_p bigint, ds_texto_saida_p INOUT text) FROM PUBLIC;

