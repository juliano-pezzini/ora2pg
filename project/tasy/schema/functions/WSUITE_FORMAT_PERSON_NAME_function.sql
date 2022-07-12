-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION wsuite_format_person_name ( type_return_p text ) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finality: Return script to format the person name on the screen
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Caution:  type_return_p   CD - Code   SC - Script

Country
1	Brasil (BR)
2	México (MX)
3	Colômbia (CO)
4	Argentina (AR)
5	Estados Unidos (US)
6	Reino Unido (UK)
7	Alemanha (DE)
8	Arábia Saudita (SA) - Script 757963
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type := wsuite_login_pck.wsuite_data_configuration('CDE');
ds_parametro_203_w	varchar(15);
nr_seq_objeto_w		dic_objeto.nr_sequencia%type;
ds_retorno_w		varchar(4000);


BEGIN

if (cd_estabelecimento_w IS NOT NULL AND cd_estabelecimento_w::text <> '') then

	ds_parametro_203_w := coalesce(pkg_i18n.get_user_locale, 'pt_BR');

	--Arábia Saudita (SA)
	if ( ds_parametro_203_w = 'ar_SA' ) then
		nr_seq_objeto_w := 757963;
	end if;

	if ( type_return_p = 'CD' ) then
		ds_retorno_w := nr_seq_objeto_w;

	elsif ( type_return_p = 'SC' )  then

		select 	ds_sql
		into STRICT	ds_retorno_w
		from	dic_objeto
		where	nr_sequencia = nr_seq_objeto_w;
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wsuite_format_person_name ( type_return_p text ) FROM PUBLIC;

