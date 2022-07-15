-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_projeto_testes_migracao ( ie_gerencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_gerencia_w	bigint;
cd_gerente_w		varchar(10);
nr_seq_projeto_w	bigint := null;
nr_seq_cronograma_w	bigint;
nr_seq_atividade_w	bigint;
cd_funcao_w		integer;
ds_funcao_w		varchar(80);
nr_seq_apresent_w	bigint := 1000;
nr_seq_atividade_ww	bigint;

c01 CURSOR FOR
SELECT	cd_funcao,
	ds_funcao
from	funcao_migracao_v
where	ie_gerencia = ie_gerencia_p
order by
	ds_funcao;


BEGIN
if (ie_gerencia_p IS NOT NULL AND ie_gerencia_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	if (ie_gerencia_p = 1) then
		begin
		nr_seq_gerencia_w	:= 7;
		cd_gerente_w		:= '4995';
		end;
	elsif (ie_gerencia_p = 2) then
		begin
		nr_seq_gerencia_w	:= 4;
		cd_gerente_w		:= '442';
		end;
	elsif (ie_gerencia_p = 3) then
		begin
		nr_seq_gerencia_w	:= 3;
		cd_gerente_w		:= '130';
		end;
	end if;

	select	nextval('proj_projeto_seq')
	into STRICT	nr_seq_projeto_w
	;

	insert into proj_projeto(
		nr_sequencia,
		dt_projeto,
		nr_seq_gerencia,
		nr_seq_classif,
		ds_titulo,
		cd_coordenador,
		nr_seq_cliente,
		cd_gerente_cliente,
		nr_seq_estagio,
		ie_status,
		cd_funcao,
		nr_seq_ordem_serv,
		nr_seq_prioridade,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_origem)
	values (
		nr_seq_projeto_w,
		clock_timestamp(),
		nr_seq_gerencia_w,
		14,
		'Testes Projetos Migração',
		'4464',
		1800,
		cd_gerente_w,
		1,
		'P',
		null,
		null,
		null,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		'D');

	select	nextval('proj_cronograma_seq')
	into STRICT	nr_seq_cronograma_w
	;

	insert into proj_cronograma(
		nr_seq_proj,
		nr_sequencia,
		ie_tipo_cronograma,
		dt_inicio,
		ds_objetivo,
		cd_empresa,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_pessoa_cliente,
		ie_estrutura,
		nr_seq_cliente)
	values (
		nr_seq_projeto_w,
		nr_seq_cronograma_w,
		'E',
		clock_timestamp(),
		'.',
		1,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_gerente_w,
		'EL',
		1800);

	select	nextval('proj_cron_etapa_seq')
	into STRICT	nr_seq_atividade_w
	;

	insert into proj_cron_etapa(
		nr_seq_cronograma,
		nr_sequencia,
		ds_atividade,
		ie_fase,
		qt_hora_prev,
		pr_etapa,
		nr_seq_apres,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_modulo,
		ie_tipo_obj_proj_migr,
		nr_seq_superior)
	values (
		nr_seq_cronograma_w,
		nr_seq_atividade_w,
		'Testes Projetos Migração',
		'S',
		0,
		0,
		nr_seq_apresent_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		'N',
		null,
		null);

	open c01;
	loop
	fetch c01 into	cd_funcao_w,
			ds_funcao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		nr_seq_apresent_w := nr_seq_apresent_w + 1000;

		select	nextval('proj_cron_etapa_seq')
		into STRICT	nr_seq_atividade_ww
		;

		insert into proj_cron_etapa(
			nr_seq_cronograma,
			nr_sequencia,
			ds_atividade,
			ie_fase,
			qt_hora_prev,
			pr_etapa,
			nr_seq_apres,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_modulo,
			ie_tipo_obj_proj_migr,
			nr_seq_superior,
			cd_funcao)
		values (
			nr_seq_cronograma_w,
			nr_seq_atividade_ww,
			ds_funcao_w,
			'N',
			0,
			0,
			nr_seq_apresent_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			'N',
			null,
			nr_seq_atividade_w,
			cd_funcao_w);
		end;
	end loop;
	close c01;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_projeto_testes_migracao ( ie_gerencia_p bigint, nm_usuario_p text) FROM PUBLIC;

