-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_filtro_usuario ( nm_usuario_origem_p text, nm_usuario_destino_p text, nm_usuario_p text) AS $body$
DECLARE


cd_dominio_w			bigint;
cd_estabelecimento_w		integer;
cd_funcao_w			bigint;
cd_perfil_w			bigint;
nm_usuario_w			varchar(15);
ds_filtro_w			varchar(80);
ie_origem_w			varchar(3);
ds_sql_w				varchar(2000);
ie_tipo_filtro_w			varchar(1);
vl_campo_w			varchar(4000);
nr_seq_tipo_localizar_w		bigint;
nr_seq_filtro_w			bigint;
nm_filtro_w			varchar(80);
ds_filtro_dinamico_w		varchar(4000);
ie_tipo_campo_w			varchar(1);
ds_campo_w			varchar(50);



c01 CURSOR FOR
	SELECT	cd_dominio,
		cd_estabelecimento,
		cd_funcao,
		cd_perfil,
		ds_campo,
		ds_filtro,
		ds_filtro_dinamico,
		ds_sql,
		ie_origem,
		ie_tipo_campo,
		ie_tipo_filtro,
		nm_filtro,
		nr_seq_filtro,
		nr_seq_tipo_localizar,
		vl_campo
	from	funcao_filtro
	where	nm_usuario = nm_usuario_origem_p;


BEGIN

--delete from funcao_filtro where nm_usuario = nm_usuario_p;
open C01;
loop
fetch C01 into
	cd_dominio_w,
	cd_estabelecimento_w,
	cd_funcao_w,
	cd_perfil_w,
	ds_campo_w,
	ds_filtro_w,
	ds_filtro_dinamico_w,
	ds_sql_w,
	ie_origem_w,
	ie_tipo_campo_w,
	ie_tipo_filtro_w,
	nm_filtro_w,
	nr_seq_filtro_w,
	nr_seq_tipo_localizar_w,
	vl_campo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	insert into funcao_filtro(
			nr_sequencia,
			cd_dominio,
			cd_estabelecimento,
			cd_funcao,
			cd_perfil,
			ds_campo,
			ds_filtro,
			ds_filtro_dinamico,
			ds_sql,
			ie_origem,
			ie_tipo_campo,
			ie_tipo_filtro,
			nm_filtro,
			nr_seq_filtro,
			nr_seq_tipo_localizar,
			vl_campo,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nm_usuario_ref)
		values (	nextval('funcao_filtro_seq'),
			cd_dominio_w,
			cd_estabelecimento_w,
			cd_funcao_w,
			cd_perfil_w,
			ds_campo_w,
			ds_filtro_w,
			ds_filtro_dinamico_w,
			ds_sql_w,
			ie_origem_w,
			ie_tipo_campo_w,
			ie_tipo_filtro_w,
			nm_filtro_w,
			nr_seq_filtro_w,
			nr_seq_tipo_localizar_w,
			vl_campo_w,
			nm_usuario_destino_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_destino_p);

	commit;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_filtro_usuario ( nm_usuario_origem_p text, nm_usuario_destino_p text, nm_usuario_p text) FROM PUBLIC;

