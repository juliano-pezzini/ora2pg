-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_tipo_checkup ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*Cursores*/

c01 CURSOR FOR
	SELECT	*
	from	empresa_tipo_checkup
	where	nr_seq_tipo_checkup = nr_sequencia_p;

C02 CURSOR FOR
	SELECT	nr_seq_etapa,
		nr_sequencia
	from	TIPO_CHECKUP_ETAPA
	where	nr_seq_tipo_checkup = nr_sequencia_p;

C03 CURSOR FOR
	SELECT	*
	from	tipo_checkup_lib
	where	nr_seq_tipo_checkup = nr_sequencia_p;

/*variáveis*/

empresa_tipo_checkup_seq_w	bigint;
c01_w				c01%rowtype;
tipo_checkup_seq_w		bigint;
tipo_checkup_etapa_seq_w	bigint;
c03_w			c03%rowtype;
tipo_checkup_lib_seq_w		bigint;
nr_seq_etapa_w			bigint;
nr_sequencia_w			bigint;
nr_seq_etapa_requerida_w	bigint;
etapa_checkup_requerida_w	bigint;


c04 CURSOR FOR
	SELECT	nr_seq_etapa
	from	etapa_checkup_requerida
	where	nr_seq_checkup_etapa = nr_sequencia_w;


BEGIN

select 	nextval('tipo_checkup_seq')
into STRICT	tipo_checkup_seq_w
;

insert into tipo_checkup(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ds_tipo_checkup,
	ie_sexo,
	qt_idade_min,
	qt_idade_max,
	ie_situacao)
SELECT	tipo_checkup_seq_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	obter_desc_expressao(735670)||' '||nm_usuario_p||' '||ds_tipo_checkup,
	ie_sexo,
	qt_idade_min,
	qt_idade_max,
	ie_situacao
from	tipo_checkup
where	nr_sequencia = nr_sequencia_p;

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	nextval('empresa_tipo_checkup_seq')
	into STRICT	empresa_tipo_checkup_seq_w
	;

	insert into empresa_tipo_checkup(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_tipo_checkup,
	cd_empresa )
	 values (
	empresa_tipo_checkup_seq_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	tipo_checkup_seq_w,
	c01_w.cd_empresa );
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into
	nr_seq_etapa_w,
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	select	nextval('tipo_checkup_etapa_seq')
	into STRICT	tipo_checkup_etapa_seq_w
	;

	insert into tipo_checkup_etapa(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_tipo_checkup,
		nr_seq_etapa)
	SELECT	tipo_checkup_etapa_seq_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		tipo_checkup_seq_w,
		nr_seq_etapa_w
	from	tipo_checkup_etapa
	where	nr_sequencia = nr_sequencia_w;

	open C04;
	loop
	fetch C04 into
		nr_seq_etapa_requerida_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin

		select	nextval('etapa_checkup_requerida_seq')
		into STRICT	etapa_checkup_requerida_w
		;


		insert into etapa_checkup_requerida(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_checkup_etapa,
			nr_seq_etapa )
		 values (
			etapa_checkup_requerida_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			tipo_checkup_etapa_seq_w,
			nr_seq_etapa_requerida_w );
		end;
	end loop;
	close C04;

	end;
end loop;
close C02;

open C03;
loop
fetch C03 into
	c03_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin

	select	nextval('tipo_checkup_lib_seq')
	into STRICT	tipo_checkup_etapa_seq_w
	;

	insert into tipo_checkup_lib(
	nr_sequencia,
	cd_estabelecimento,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_tipo_checkup )
	 values (
	tipo_checkup_etapa_seq_w,
	c03_w.cd_estabelecimento,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	tipo_checkup_seq_w );


	end;
end loop;
close C03;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_tipo_checkup ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
