-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE criar_tasy_objeto_help ( cd_seq_funcao_p bigint, ie_tipo_objeto_p text, nm_usuario_p text) AS $body$
DECLARE


qt_existe_w			bigint;
ds_funcao_w			varchar(80);
nm_modulo_w			varchar(40);


BEGIN

qt_existe_w := 0;

if (cd_seq_funcao_p <> 0) then

	if (ie_tipo_objeto_p = 'F') then

		select	count(*)
		into STRICT	qt_existe_w
		from	tasy_objeto_help
		where	cd_funcao = cd_seq_funcao_p
		and	ie_tipo_objeto = 'F';

		if (qt_existe_w = 0) then

			select	ds_funcao
			into STRICT	ds_funcao_w
			from	funcao
			where	cd_funcao = cd_seq_funcao_p;

			insert into tasy_objeto_help(
				nr_sequencia,
				ds_objeto,
				dt_atualizacao,
				nm_usuario,
				ie_tipo_objeto,
				cd_funcao,
				nm_objeto,
				nm_tabela,
				ie_banco,
				nr_seq_mod_impl)
			values (nextval('tasy_objeto_help_seq'),
				ds_funcao_w,
				clock_timestamp(),
				nm_usuario_p,
				'F',
				cd_seq_funcao_p,
				null,
				null,
				null,
				null);

		end if;

	end if;

	if (ie_tipo_objeto_p = 'M') then

		select	count(*)
		into STRICT	qt_existe_w
		from	tasy_objeto_help
		where	nr_seq_mod_impl = cd_seq_funcao_p
		and	ie_tipo_objeto = 'M';

		if (qt_existe_w = 0) then

			select	nm_modulo
			into STRICT	nm_modulo_w
			from	modulo_implantacao
			where	nr_sequencia = cd_seq_funcao_p;

			insert into tasy_objeto_help(
				nr_sequencia,
				ds_objeto,
				dt_atualizacao,
				nm_usuario,
				ie_tipo_objeto,
				cd_funcao,
				nm_objeto,
				nm_tabela,
				ie_banco,
				nr_seq_mod_impl)
			values (nextval('tasy_objeto_help_seq'),
				nm_modulo_w,
				clock_timestamp(),
				nm_usuario_p,
				'M',
				null,
				null,
				null,
				null,
				cd_seq_funcao_p);

		end if;

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE criar_tasy_objeto_help ( cd_seq_funcao_p bigint, ie_tipo_objeto_p text, nm_usuario_p text) FROM PUBLIC;

