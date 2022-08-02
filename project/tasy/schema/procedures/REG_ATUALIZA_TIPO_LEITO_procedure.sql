-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_atualiza_tipo_leito ( cd_tipo_leito_p text, nr_ordem_p text, nr_sus_p text, nm_usuario_p text) AS $body$
DECLARE

qt_registro_w		smallint;


BEGIN
if (coalesce(cd_tipo_leito_p, 0) > 0) then

	select	count(*)
	into STRICT	qt_registro_w
	from	regulacao_tipo_leito
	where	cd_tipo_leito = cd_tipo_leito_p;

	if (qt_registro_w = 0) then

		insert into regulacao_tipo_leito(
			nr_sequencia,
			cd_tipo_leito,
			nr_ordem,
			nr_sus,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec
		) values (
			nextval('regulacao_tipo_leito_seq'),
			cd_tipo_leito_p,
			nr_ordem_p,
			nr_sus_p,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp()
		);
	else
		update	regulacao_tipo_leito
		set	cd_tipo_leito = cd_tipo_leito_p,
			nr_ordem = nr_ordem_p,
			nr_sus = nr_sus_p,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	cd_tipo_leito = cd_tipo_leito_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_atualiza_tipo_leito ( cd_tipo_leito_p text, nr_ordem_p text, nr_sus_p text, nm_usuario_p text) FROM PUBLIC;

