-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ordem_ipasgo_matmed ( nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_diluicao_w			prescr_material.nr_sequencia_diluicao%type;
nr_seq_kit_w				prescr_material.nr_seq_kit%type;
nr_sequencia_prescricao_w		prescr_material.nr_sequencia%type;
nr_prescricao_w				prescr_material.nr_prescricao%type;
ie_agrupador_w				prescr_material.ie_agrupador%type;
ds_material_w				material.ds_material%type;
cd_material_w				material.cd_material%type;
nr_seq_arquivo_w			bigint := 0;

c00 CURSOR FOR
	SELECT	b.nr_sequencia,
		b.nr_prescricao,
		b.ie_agrupador,
		a.cd_material,
		substr(obter_desc_material(a.cd_material),1,100) ds_material
	from	prescr_material b,
		material_atend_paciente a
	where 	b.nr_prescricao = a.nr_prescricao
	and	b.nr_sequencia = a.nr_sequencia_prescricao
	and b.ie_agrupador in ('4')
	and a.nr_interno_conta	= nr_interno_conta_p
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	coalesce(a.nr_seq_proc_pacote::text, '') = ''
	group by b.nr_sequencia,
		b.nr_prescricao,
		b.ie_agrupador,
		b.nr_agrupamento,
		a.cd_material,
		substr(obter_desc_material(a.cd_material),1,100)
	order by	b.nr_prescricao,
		b.nr_agrupamento;

c01 CURSOR FOR
	SELECT	b.nr_sequencia,
		b.nr_prescricao,
		b.ie_agrupador,
		a.cd_material,
		substr(obter_desc_material(a.cd_material),1,100) ds_material
	from	prescr_material b,
		material_atend_paciente a
	where 	b.nr_prescricao = a.nr_prescricao
	and	b.nr_sequencia = a.nr_sequencia_prescricao
	and b.ie_agrupador in ('1','8')
	and a.nr_interno_conta	= nr_interno_conta_p
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	coalesce(a.nr_seq_proc_pacote::text, '') = ''
	group by b.nr_sequencia,
		b.nr_prescricao,
		b.ie_agrupador,
		b.nr_agrupamento,
		a.cd_material,
		substr(obter_desc_material(a.cd_material),1,100)
	order by	b.nr_prescricao,
		b.nr_agrupamento;

c02 CURSOR FOR
	SELECT	b.nr_sequencia,
		b.nr_sequencia_diluicao,
		b.ie_agrupador,
		a.cd_material,
		substr(obter_desc_material(a.cd_material),1,100) ds_material
	from	prescr_material b,
		material_atend_paciente a
	where 	b.nr_prescricao = a.nr_prescricao
	and	b.nr_sequencia = a.nr_sequencia_prescricao
	and b.ie_agrupador in ('3')
	and a.nr_interno_conta	= nr_interno_conta_p
	and	b.nr_sequencia_diluicao = nr_sequencia_prescricao_w
	and	b.nr_prescricao = nr_prescricao_w
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	coalesce(a.nr_seq_proc_pacote::text, '') = ''
	group by b.nr_sequencia,
		b.nr_sequencia_diluicao,
		b.ie_agrupador,
		a.cd_material,
		substr(obter_desc_material(a.cd_material),1,100);

c03 CURSOR FOR
	SELECT	b.nr_sequencia,
		b.ie_agrupador,
		a.cd_material,
		substr(obter_desc_material(a.cd_material),1,100) ds_material
	from	prescr_material b,
		material_atend_paciente a
	where 	b.nr_prescricao = a.nr_prescricao
	and	b.nr_sequencia = a.nr_sequencia_prescricao
	and b.ie_agrupador in ('2')
	and	(b.cd_kit_material IS NOT NULL AND b.cd_kit_material::text <> '')   -- utilizado para consistir se está no kit ou não, se não, entra nos mat/med comuns
	and a.nr_interno_conta	= nr_interno_conta_p
	and	b.nr_seq_kit = nr_sequencia_diluicao_w
	and	b.nr_prescricao = nr_prescricao_w
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	coalesce(a.nr_seq_proc_pacote::text, '') = ''
	group by b.nr_sequencia,
		b.ie_agrupador,
		a.cd_material,
		substr(obter_desc_material(a.cd_material),1,100);

/*
create table w_ipasgo_ordem_matmet (
  -nr_sequencia  number(10),
  ie_agrupador  number(2),
  nr_seq_arquivo number(10),
 - nr_prescricao number(14),
  -nr_interno_conta number(10),
  ie_cursor		number(1),
 - cd_material	number(6),
  ds_material	varchar2(255));

 */
BEGIN

delete FROM w_ipasgo_ordem_matmet where nr_interno_conta = nr_interno_conta_p;

open c00;
loop
fetch c00 into
	nr_sequencia_prescricao_w,
	nr_prescricao_w,
	ie_agrupador_w,
	cd_material_w,
	ds_material_w;
EXIT WHEN NOT FOUND; /* apply on c00 */
    begin

	nr_seq_arquivo_w	:= nr_seq_arquivo_w + 1;

	insert into w_ipasgo_ordem_matmet(
		nr_sequencia,
		ie_agrupador,
		nr_seq_arquivo,
		nr_sequencia_prescricao,
		nr_prescricao,
		nr_interno_conta,
		ie_cursor,
		cd_material,
		ds_material,
		nm_usuario,
		nm_usuario_nrec,
		dt_atualizacao,
		dt_atualizacao_nrec)
	values (
		nextval('w_ipasgo_ordem_matmet_seq'),
		ie_agrupador_w,
		nr_seq_arquivo_w,
		nr_sequencia_prescricao_w,
		nr_prescricao_w,
		nr_interno_conta_p,
		0,
		cd_material_w,
		ds_material_w,
		nm_usuario_p,
		nm_usuario_p,
		clock_timestamp(),
		clock_timestamp());

	end;
end loop;
close c00;

open c01;
loop
fetch c01 into
	nr_sequencia_prescricao_w,
	nr_prescricao_w,
	ie_agrupador_w,
	cd_material_w,
	ds_material_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
    begin

	nr_seq_arquivo_w	:= nr_seq_arquivo_w + 1;

	insert into w_ipasgo_ordem_matmet(
		nr_sequencia,
		ie_agrupador,
		nr_seq_arquivo,
		nr_sequencia_prescricao,
		nr_prescricao,
		nr_interno_conta,
		ie_cursor,
		cd_material,
		ds_material,
		nm_usuario,
		nm_usuario_nrec,
		dt_atualizacao,
		dt_atualizacao_nrec )
	values (
		nextval('w_ipasgo_ordem_matmet_seq'),
		ie_agrupador_w,
		nr_seq_arquivo_w,
		nr_sequencia_prescricao_w,
		nr_prescricao_w,
		nr_interno_conta_p,
		1,
		cd_material_w,
		ds_material_w,
		nm_usuario_p,
		nm_usuario_p,
		clock_timestamp(),
		clock_timestamp());

	open c02;
	loop
	fetch c02 into
		nr_sequencia_prescricao_w,
		nr_sequencia_diluicao_w,
		ie_agrupador_w,
		cd_material_w,
		ds_material_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		nr_seq_arquivo_w	:= nr_seq_arquivo_w + 1;

		insert into w_ipasgo_ordem_matmet(
			nr_sequencia,
			ie_agrupador,
			nr_seq_arquivo,
			nr_sequencia_prescricao,
			nr_prescricao,
			nr_interno_conta,
			ie_cursor,
			cd_material,
			ds_material,
			nm_usuario,
			nm_usuario_nrec,
			dt_atualizacao,
			dt_atualizacao_nrec )
		values (
			nextval('w_ipasgo_ordem_matmet_seq'),
			ie_agrupador_w,
			nr_seq_arquivo_w,
			nr_sequencia_prescricao_w,
			nr_prescricao_w,
			nr_interno_conta_p,
			2,
			cd_material_w,
			ds_material_w,
			nm_usuario_p,
			nm_usuario_p,
			clock_timestamp(),
			clock_timestamp());

		open c03;
		loop
		fetch c03 into
			nr_sequencia_prescricao_w,
			ie_agrupador_w,
			cd_material_w,
			ds_material_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin

			nr_seq_arquivo_w	:= nr_seq_arquivo_w + 1;

			insert into w_ipasgo_ordem_matmet(
				nr_sequencia,
				ie_agrupador,
				nr_seq_arquivo,
				nr_sequencia_prescricao,
				nr_prescricao,
				nr_interno_conta,
				ie_cursor,
				cd_material,
				ds_material,
				nm_usuario,
				nm_usuario_nrec,
				dt_atualizacao,
				dt_atualizacao_nrec )
			values (
				nextval('w_ipasgo_ordem_matmet_seq'),
				ie_agrupador_w,
				nr_seq_arquivo_w,
				nr_sequencia_prescricao_w,
				nr_prescricao_w,
				nr_interno_conta_p,
				3,
				cd_material_w,
				ds_material_w,
				nm_usuario_p,
				nm_usuario_p,
				clock_timestamp(),
				clock_timestamp());

			end;
		end loop;
		close c03;

		end;
	end loop;
	close c02;

	end;
end loop;
close c01;

commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ordem_ipasgo_matmed ( nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;
