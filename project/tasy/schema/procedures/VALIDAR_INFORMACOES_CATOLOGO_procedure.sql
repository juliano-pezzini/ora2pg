-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE validar_informacoes_catologo ( nm_usuario_p text) AS $body$
DECLARE


qt_registros_w		bigint;


BEGIN

	if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	begin

		select  count(*)
		into STRICT	qt_registros_w
		from    w_config_carga_endereco
		where   nm_usuario = nm_usuario_p
		and     nm_atributo_carga in ('CD_ENDERECO_CATALOGO','DS_ENDERECO');

		if (qt_registros_w < 2) then

			select  count(*)
			into STRICT	qt_registros_w
			from    w_config_carga_endereco
			where   nm_usuario = nm_usuario_p
			and     nm_atributo_carga in ('CD_AND_DS');

			if (qt_registros_w < 1) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(1055830);
			end if;
		end if;

		select	count(*)
		into STRICT	qt_registros_w
		from	w_config_carga_endereco
		where	nm_usuario = nm_usuario_p
		and	nm_atributo_carga = 'CD_ENDERECO_SUPERIOR';

		if (qt_registros_w > 1) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1058695);
		end if;

		select count(*)
		into STRICT	qt_registros_w
		from	w_config_carga_endereco a
		where	nm_usuario = nm_usuario_p
		and	nm_atributo_carga = 'CD_SUP_COMP'
		and (coalesce(nr_nivel_composicao::text, '') = ''
		or exists (SELECT 1
						from w_config_carga_endereco x
						where x.nm_usuario = nm_usuario_p
						and x.nm_atributo_carga = 'CD_SUP_COMP'
						and x.nm_coluna_arquivo != a.nm_coluna_arquivo
						and x.nr_nivel_composicao = a.nr_nivel_composicao));

		if (qt_registros_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1058696);
		end if;

	end;

	end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE validar_informacoes_catologo ( nm_usuario_p text) FROM PUBLIC;
