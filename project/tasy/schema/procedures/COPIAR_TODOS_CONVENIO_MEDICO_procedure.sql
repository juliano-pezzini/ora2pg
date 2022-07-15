-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_todos_convenio_medico ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_convenio_w		integer;
cd_convenio_dest_w	integer;
ie_conveniado_w		varchar(1);
ie_auditor_w		varchar(1);
ie_plantonista_w	varchar(1);
cd_estabelecimento_w	smallint;
nr_sequencia_w		bigint;
ie_tipo_servico_sus_w	smallint;
qt_registro_w		bigint;
cd_pessoa_fisica_w	varchar(10);

c01 CURSOR FOR
	SELECT	cd_convenio
	from	convenio
	where	ie_situacao = 'A'
	and	cd_convenio <> cd_convenio_w;


BEGIN

select	cd_convenio,
	ie_conveniado,
	ie_auditor,
	ie_plantonista,
	cd_estabelecimento,
	ie_tipo_servico_sus,
	cd_pessoa_fisica
into STRICT	cd_convenio_w,
	ie_conveniado_w,
	ie_auditor_w,
	ie_plantonista_w,
	cd_estabelecimento_w,
	ie_tipo_servico_sus_w,
	cd_pessoa_fisica_w
from	medico_convenio
where	nr_sequencia = nr_sequencia_p;


if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then

	open c01;
	loop
	fetch c01 into	cd_convenio_dest_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	medico_convenio
	where	cd_pessoa_fisica = cd_pessoa_fisica_w
	and	cd_convenio = cd_convenio_dest_w;

	if (qt_registro_w = 0) then
		insert into medico_convenio(
			nr_sequencia,
			cd_pessoa_fisica,
			cd_convenio,
			dt_atualizacao,
			nm_usuario,
			ie_conveniado,
			ie_auditor,
			ie_plantonista,
			cd_estabelecimento,
			ie_tipo_servico_sus)
		values (	nextval('medico_convenio_seq'),
			cd_pessoa_fisica_w,
			cd_convenio_dest_w,
			clock_timestamp(),
			nm_usuario_p,
			ie_conveniado_w,
			ie_auditor_w,
			ie_plantonista_w,
			cd_estabelecimento_w,
			ie_tipo_servico_sus_w);
	end if;
	end;
	end loop;
	close c01;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_todos_convenio_medico ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

