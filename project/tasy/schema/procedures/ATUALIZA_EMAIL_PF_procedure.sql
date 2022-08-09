-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_email_pf ( cd_pessoa_fisica_p text, ds_email_p text, ie_tipo_endereco_p bigint default 1, nm_usuario_p text DEFAULT NULL) AS $body$
DECLARE


nr_sequencia_w		bigint;
qt_existe_telefone_w	bigint;


BEGIN

begin
	select	1
	into STRICT	qt_existe_telefone_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	ie_tipo_complemento = ie_tipo_endereco_p  LIMIT 1;
exception
	when	no_data_found then
		qt_existe_telefone_w := 0;
end;

If (qt_existe_telefone_w = 0) then
	select	coalesce(max(nr_sequencia),0) + 1
	into STRICT	nr_sequencia_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;

	insert into compl_pessoa_fisica(nr_sequencia,
		cd_pessoa_fisica,
		ie_tipo_complemento,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nm_usuario,
		dt_atualizacao,
		ds_email)
	values (nr_sequencia_w,
		cd_pessoa_fisica_p,
		ie_tipo_endereco_p,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		ds_email_p);
else
	update	compl_pessoa_fisica
	set	ds_email = ds_email_p
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	ie_tipo_complemento = ie_tipo_endereco_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_email_pf ( cd_pessoa_fisica_p text, ds_email_p text, ie_tipo_endereco_p bigint default 1, nm_usuario_p text DEFAULT NULL) FROM PUBLIC;
