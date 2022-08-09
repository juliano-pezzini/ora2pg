-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_categoria_plano ( cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, cd_estab_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w	smallint;
qt_categoria_plano_w 	bigint;


BEGIN

cd_estabelecimento_w := cd_estab_p;
if (cd_estabelecimento_w = 0) then
	cd_estabelecimento_w := null;
end if;

if (cd_categoria_p IS NOT NULL AND cd_categoria_p::text <> '') and (cd_plano_p IS NOT NULL AND cd_plano_p::text <> '') then

	select 	count(*)
	into STRICT 	qt_categoria_plano_w
	from 	categoria_plano
	where	cd_categoria = cd_categoria_p
	and		cd_plano = cd_plano_p
	and     cd_convenio = cd_convenio_p
	and		coalesce(cd_estabelecimento,0) = coalesce(cd_estabelecimento_w,0)
	and		ie_situacao = 'A';

	if (qt_categoria_plano_w = 0) then

		insert into categoria_plano(
			nr_sequencia,
			cd_convenio,
			cd_categoria,
			cd_plano,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_estabelecimento,
			ie_situacao,
			dt_inicio_vigencia,
			dt_final_vigencia)
		 values (	nextval('categoria_plano_seq'),
			cd_convenio_p,
			cd_categoria_p,
			cd_plano_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_estabelecimento_w,
			'A',
			null,
			null);

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_categoria_plano ( cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, cd_estab_p bigint, nm_usuario_p text) FROM PUBLIC;
