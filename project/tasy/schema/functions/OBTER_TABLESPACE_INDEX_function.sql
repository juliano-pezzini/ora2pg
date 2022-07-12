-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tablespace_index (nm_objeto_p text default null) RETURNS varchar AS $body$
DECLARE


nm_tablespace_w	varchar(40);
nm_user_w	varchar(40);
ie_configurar_w	varchar(1);


BEGIN

EXECUTE 'BEGIN :a := wheb_usuario_pck.get_configurar_tablespace; END;' USING IN OUT ie_configurar_w;

if (nm_objeto_p IS NOT NULL AND nm_objeto_p::text <> '') and (ie_configurar_w = 'S') then
	nm_tablespace_w := OBTER_VALOR_DINAMICO_CHAR_BV('select obter_nome_tablespace(:NM_OBJETO,:IE_TIPO) from dual', 'NM_OBJETO=' || nm_objeto_p || ';' ||
			'IE_TIPO=' || 'INDICE' || ';', nm_tablespace_w);
	if (coalesce(nm_tablespace_w::text, '') = '') then
		select	Obter_Tablespace_Index(null)
		into STRICT	nm_tablespace_w
		;
	end	if;
else
	nm_tablespace_w := OBTER_VALOR_DINAMICO_CHAR_BV(
		'select nvl(vl_parametro,vl_parametro_padrao) '||
		'from 	funcao_parametro '||
		'where	nr_sequencia = 95 ' ||
		'and 	cd_funcao = 0 ', '', nm_tablespace_w);

	if ( coalesce(nm_tablespace_w::text, '') = '' ) then

		select	username
		into STRICT	nm_user_w
		from	user_users;

		select	max(tablespace_name)
		into STRICT	nm_tablespace_w
		from	user_tablespaces
		where	tablespace_name 	= nm_user_w || '_INDEX';

		if (coalesce(nm_tablespace_w::text, '') = '') then
			nm_tablespace_w	:= 'TASY_INDEX';
		end if;
	end if;
end	if;

RETURN nm_tablespace_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tablespace_index (nm_objeto_p text default null) FROM PUBLIC;
