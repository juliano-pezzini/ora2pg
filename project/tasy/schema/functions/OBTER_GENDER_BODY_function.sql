-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_gender_body (ie_sexo_p text, qt_idade_p bigint) RETURNS varchar AS $body$
DECLARE


nr_idade_menor_w			bigint;
nr_subt_idade_w				bigint;
qt_idade_ano_max_w			corpo_humano_repres_idade.qt_idade_ano_max%type;
ds_retorno_w				corpo_humano_repres_idade.ie_representacao_idade%type;
ds_repres_idade_w			corpo_humano_repres_idade.ie_representacao_idade%type;
ie_representacao_idade_w		corpo_humano_repres_idade.ie_representacao_idade%type;

c01 CURSOR FOR
SELECT ie_representacao_idade, qt_idade_ano_max
from corpo_humano_repres_idade
where ie_situacao = 'A'
order by qt_idade_ano_max;


BEGIN
	nr_idade_menor_w := 99999;
	ds_retorno_w 	 := 'NULL';

	select max(ie_representacao_idade)
		into STRICT ds_repres_idade_w
	from corpo_humano_repres_idade
	where ie_situacao = 'A'
	and qt_idade_p between qt_idade_ano_min and qt_idade_ano_max;

	if ( coalesce(ds_repres_idade_w::text, '') = '' and qt_idade_p = 0 ) then
		return ds_retorno_w;

	elsif ( coalesce(ds_repres_idade_w::text, '') = '' ) then
		open c01;
		loop
		fetch C01 into	
			ie_representacao_idade_w,
			qt_idade_ano_max_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
				nr_subt_idade_w := ABS(qt_idade_ano_max_w - qt_idade_p);
				if ( nr_subt_idade_w < nr_idade_menor_w) then
					nr_idade_menor_w  := nr_subt_idade_w;
					ds_repres_idade_w := ie_representacao_idade_w;
				end if;
			end;
		end loop;
		close c01;
	end if;


	if (ds_repres_idade_w IS NOT NULL AND ds_repres_idade_w::text <> '') then
		select  case trim(both ds_repres_idade_w)
			 when 'I' then
				case ie_sexo_p
				  when 'M' then 'AM'
				  when 'F' then 'AF'
				  else 'AM'
				  end
			 when 'A' then
				case ie_sexo_p
				  when 'M' then 'AM'
				  when 'F' then 'AF'
				  else 'AM'
				  end
			 when 'C' then
				case ie_sexo_p
				  when 'M' then 'CM'
				  when 'F' then 'CF'
				  else 'CM'
				  end
			 when 'B' then
				case ie_sexo_p
				  when 'M' then 'IM'
				  when 'F' then 'IF'
				  else 'IM'
				  end
			 else 'NULL'
		  end as ie_gender
		into STRICT ds_retorno_w
		;
	end if;

	return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_gender_body (ie_sexo_p text, qt_idade_p bigint) FROM PUBLIC;
