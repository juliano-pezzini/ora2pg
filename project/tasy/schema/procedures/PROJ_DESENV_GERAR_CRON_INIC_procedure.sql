-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_desenv_gerar_cron_inic ( nr_seq_projeto_p bigint, nm_usuario_p text, nr_seq_cronograma_p INOUT bigint, ie_classificacao_p text default null) AS $body$
DECLARE


nr_seq_cronograma_w	bigint;
nr_seq_cliente_w		bigint;
cd_gerente_cliente_w	varchar(10);
nr_seq_raiz_w		bigint;
ie_tipo_ativ_met_w		varchar(15);
ds_tipo_ativ_met_w		varchar(255);
nr_seq_apresent_w		bigint;

c01 CURSOR FOR
SELECT	vl_dominio,
	ds_valor_dominio,
	nr_seq_apresent
from	valor_dominio
where	cd_dominio = 3556
and 	substr(vl_dominio,1,1) = 'I'
and	ie_situacao = 'A'
order by
	nr_seq_apresent;


BEGIN
if (nr_seq_projeto_p IS NOT NULL AND nr_seq_projeto_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select	max(nr_seq_cliente),
		max(cd_gerente_cliente)
	into STRICT	nr_seq_cliente_w,
		cd_gerente_cliente_w
	from	proj_projeto
	where	nr_sequencia = nr_seq_projeto_p;

	select	nextval('proj_cronograma_seq')
	into STRICT	nr_seq_cronograma_w
	;

	nr_seq_cronograma_p := nr_seq_cronograma_w;

	insert into proj_cronograma(
		nr_sequencia,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_atualizacao,
		nm_usuario,
		nr_seq_cliente,
		cd_empresa,
		cd_pessoa_cliente,
		ie_estrutura,
		nr_seq_proj,
		ie_tipo_cronograma,
		dt_inicio,
		ds_objetivo,
		ie_situacao,
		ie_classificacao)
	values (
		nr_seq_cronograma_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_cliente_w,
		1,
		cd_gerente_cliente_w,
		'EL',
		nr_seq_projeto_p,
		'I',
		clock_timestamp(),
		' ',
		'A',
		ie_classificacao_p);

	select	nextval('proj_cron_etapa_seq')
	into STRICT	nr_seq_raiz_w
	;

	insert into proj_cron_etapa(
		nr_sequencia,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_atualizacao,
		nm_usuario,
		qt_hora_prev,
		pr_etapa,
		ie_modulo,
		ie_fase,
		nr_seq_apres,
		nr_seq_cronograma,
		ds_atividade,
		ie_tipo_ativ_met,
		nr_seq_superior)
	values (
		nr_seq_raiz_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		0,
		0,
		'N',
		'S',
		1,
		nr_seq_cronograma_w,
		'Cronograma de Iniciação',
		null,
		null);

	open c01;
	loop
	fetch c01 into	ie_tipo_ativ_met_w,
			ds_tipo_ativ_met_w,
			nr_seq_apresent_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		insert into proj_cron_etapa(
			nr_sequencia,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_atualizacao,
			nm_usuario,
			qt_hora_prev,
			pr_etapa,
			ie_modulo,
			ie_fase,
			nr_seq_apres,
			nr_seq_cronograma,
			ds_atividade,
			ie_tipo_ativ_met,
			nr_seq_superior)
		values (
			nextval('proj_cron_etapa_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			0,
			0,
			'N',
			'S',
			nr_seq_apresent_w,
			nr_seq_cronograma_w,
			ds_tipo_ativ_met_w,
			ie_tipo_ativ_met_w,
			nr_seq_raiz_w);
		end;
	end loop;
	close c01;

	CALL gerar_classif_etapa_proj(nr_seq_cronograma_w, nm_usuario_p);
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_desenv_gerar_cron_inic ( nr_seq_projeto_p bigint, nm_usuario_p text, nr_seq_cronograma_p INOUT bigint, ie_classificacao_p text default null) FROM PUBLIC;

