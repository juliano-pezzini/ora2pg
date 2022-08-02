-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_inserir_modulo_consultor (cd_modulo_p bigint, nr_seq_consultor_p bigint, nm_usuario_p text, cd_pessoa_fisica_p text default null) AS $body$
DECLARE


nr_sequencia_w		bigint;
ie_tipo_consultor_w	varchar(5);


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	select	max(CASE WHEN coalesce(ie_tipo_consultor,'A')='CO' THEN 'O' WHEN coalesce(ie_tipo_consultor,'A')='CP' THEN 'P'  ELSE 'A' END )
	into STRICT	ie_tipo_consultor_w
	from	com_canal_consultor
	where	cd_pessoa_fisica	=	cd_pessoa_fisica_p;
else
	select	max(CASE WHEN coalesce(ie_tipo_consultor,'A')='CO' THEN 'O' WHEN coalesce(ie_tipo_consultor,'A')='CP' THEN 'P'  ELSE 'A' END )
	into STRICT	ie_tipo_consultor_w
	from	com_canal_consultor
	where	nr_sequencia	=	nr_seq_consultor_p;
end if;

if (cd_modulo_p	is	not	null)	then
	begin

		select	nextval('com_cons_gest_con_mod_seq')
		into STRICT	nr_sequencia_w
		;

		insert	into	com_cons_gest_con_mod(nr_sequencia,
							nr_seq_consultor,
							nr_seq_mod_impl,
							nr_seq_etapa,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec)
						values (	nr_sequencia_w,
							nr_seq_consultor_p,
							cd_modulo_p,
							null,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p);

		CALL com_gerar_funcao_conhecimento(	nr_sequencia_w,
						cd_modulo_p,
						nm_usuario_p,
						ie_tipo_consultor_w);
	end;
end	if;

commit;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_inserir_modulo_consultor (cd_modulo_p bigint, nr_seq_consultor_p bigint, nm_usuario_p text, cd_pessoa_fisica_p text default null) FROM PUBLIC;

