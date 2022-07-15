-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_participante_fanep ( cd_participante_p text, ie_funcao_p text, ie_opcao_funcao_p text, nr_seq_pepo_p bigint, ie_commit_p text default 'S', nm_usuario_p text DEFAULT NULL) AS $body$
DECLARE


/*
ie_opcao_funcao_p
'A' - Anestesista
*/
nr_sequencia_w		bigint;
qt_registro_w		integer := 0;


BEGIN
if (ie_funcao_p IS NOT NULL AND ie_funcao_p::text <> '') and (coalesce(nr_seq_pepo_p,0) > 0) then
	select 	count(*)
	into STRICT	qt_registro_w
	from	pepo_participante
	where	nr_seq_pepo		=	nr_seq_pepo_p
	and	cd_pessoa_fisica	=	cd_participante_p
	and	ie_funcao		=	ie_funcao_p;

	if (qt_registro_w = 0) then
		insert into pepo_participante(
			nr_seq_pepo,
			nr_sequencia,
			ie_funcao,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			cd_pessoa_fisica)
		values (
			nr_seq_pepo_p,
			nextval('pepo_participante_seq'),
			ie_funcao_p,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			cd_participante_p);
	end if;

	if (ie_commit_p = 'S') then
		commit;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_participante_fanep ( cd_participante_p text, ie_funcao_p text, ie_opcao_funcao_p text, nr_seq_pepo_p bigint, ie_commit_p text default 'S', nm_usuario_p text DEFAULT NULL) FROM PUBLIC;

