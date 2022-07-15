-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_endereco_numero ( cd_pessoa_fisica_p text, ie_tipo_endereco_p bigint default 1, nr_endereco_p text default '0', nm_usuario_p text DEFAULT NULL) AS $body$
DECLARE


nr_sequencia_w		bigint;
qt_existe_cadastrado_w	bigint;
nr_endereco_w		integer;
tag_pais_w		varchar(15);


BEGIN

nr_endereco_w := substr(nr_endereco_p, 1, 5);

begin
	select	1
	into STRICT	qt_existe_cadastrado_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	ie_tipo_complemento = ie_tipo_endereco_p  LIMIT 1;
exception
	when	no_data_found then
		qt_existe_cadastrado_w := 0;
end;

select	max(ds_locale)
into STRICT	tag_pais_w
from	user_locale 
where	nm_user = nm_usuario_p;
	
If (qt_existe_cadastrado_w = 0) then
	select	coalesce(max(nr_sequencia),0) + 1
	into STRICT	nr_sequencia_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	
	if (tag_pais_w in ('de_DE', 'de_AT'))then
		insert into compl_pessoa_fisica(nr_sequencia,
			cd_pessoa_fisica,
			ie_tipo_complemento,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nm_usuario,
			dt_atualizacao,
			ds_compl_end)
		values (nr_sequencia_w,
			cd_pessoa_fisica_p,
			ie_tipo_endereco_p,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nr_endereco_w);
	else
		insert into compl_pessoa_fisica(nr_sequencia,
			cd_pessoa_fisica,
			ie_tipo_complemento,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nm_usuario,
			dt_atualizacao,
			nr_endereco)
		values (nr_sequencia_w,
			cd_pessoa_fisica_p,
			ie_tipo_endereco_p,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nr_endereco_w);
	end if;
else
	if (tag_pais_w in ('de_DE', 'de_AT'))then
		update	compl_pessoa_fisica
		set	ds_compl_end = nr_endereco_w,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	cd_pessoa_fisica = cd_pessoa_fisica_p
		and	ie_tipo_complemento = ie_tipo_endereco_p;
	else
		update	compl_pessoa_fisica
		set	nr_endereco = nr_endereco_w,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	cd_pessoa_fisica = cd_pessoa_fisica_p
		and	ie_tipo_complemento = ie_tipo_endereco_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_endereco_numero ( cd_pessoa_fisica_p text, ie_tipo_endereco_p bigint default 1, nr_endereco_p text default '0', nm_usuario_p text DEFAULT NULL) FROM PUBLIC;

