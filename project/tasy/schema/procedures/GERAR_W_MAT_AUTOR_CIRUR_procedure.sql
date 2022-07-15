-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_mat_autor_cirur (nr_atendimento_p bigint, nr_seq_agenda_p bigint, nr_cirurgia_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_material_w		bigint;
ds_material_w		varchar(255);
qt_mat_lib_w		smallint;
qt_material_w		smallint;
nr_sequencia_w		bigint;
ds_obs_mat_w		varchar(255);
ie_exige_just_w		varchar(1);
nr_seq_aut_mat_w	bigint;

c01 CURSOR FOR
	SELECT	b.cd_material,
		SUBSTR(obter_desc_material(b.cd_material),1,255) ds_materiais,
		b.qt_material qt_material,
		b.qt_material qt_materia_lib,
		'' ds_observacao,
		SUBSTR(obter_se_mat_exibe_desc_cir(b.cd_material,nr_cirurgia_p,'J'),1,2) ie_exige_justif,
		b.nr_sequencia
	FROM    autorizacao_cirurgia a,
		material_autor_cirurgia b
	WHERE   b.nr_seq_autorizacao = a.nr_sequencia
	AND     coalesce(b.qt_material,0) > 0
	and	coalesce(a.nr_atendimento,0)	= coalesce(nr_atendimento_p,a.nr_atendimento)
	and	coalesce(a.nr_seq_agenda,0) 	= coalesce(nr_seq_agenda_p,a.nr_seq_agenda)
	AND	SUBSTR(obter_se_mat_exibe_desc_cir(b.cd_material,nr_cirurgia_p,''),1,2) = 'S'
	and	a.ie_estagio_autor <> 6
	
UNION

	SELECT 	x.cd_material,
		SUBSTR(obter_desc_material(x.cd_material),1,255) ds_materiais,
		x.qt_material qt_material,
		x.qt_material qt_materia_lib,
		'' ds_observacao,
		SUBSTR(obter_se_mat_exibe_desc_cir(x.cd_material,nr_cirurgia_p,'J'),1,2) ie_exige_justif,
		null nr_sequencia
	FROM   	prescr_material x,
		cirurgia a
	WHERE  	a.nr_prescricao = x.nr_prescricao
	and	a.nr_cirurgia	= nr_cirurgia_p
	AND	coalesce(x.qt_material,0) > 0
	AND    	SUBSTR(obter_se_mat_exibe_desc_cir(x.cd_material,nr_cirurgia_p,''),1,2) = 'S';


BEGIN
if (coalesce(nr_atendimento_p,0) > 0) or (coalesce(nr_seq_agenda_p,0) > 0) then
	open C01;
	loop
	fetch C01 into
		cd_material_w,
		ds_material_w,
		qt_mat_lib_w,
		qt_material_w,
		ds_obs_mat_w,
		ie_exige_just_w,
		nr_seq_aut_mat_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		select 	nextval('pepo_mat_proc_justif_autor_seq')
		into STRICT	nr_sequencia_w
		;

		insert into  pepo_mat_proc_justif_autor(nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_cirurgia,
							cd_procedimento,
							cd_material,
							ie_origem_proced,
							qt_solicitada,
							qt_realizada,
							ds_justificativa,
							ds_material,
							ie_exige_justificativa,
							nr_seq_mat_autor_cir)
		values (	nr_sequencia_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_cirurgia_p,
							null,
							cd_material_w,
							null,
							coalesce(qt_mat_lib_w,0),
							coalesce(qt_material_w,0),
							null,
							ds_material_w,
							ie_exige_just_w,
							nr_seq_aut_mat_w);

		end;
	end loop;
	close c01;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_mat_autor_cirur (nr_atendimento_p bigint, nr_seq_agenda_p bigint, nr_cirurgia_p bigint, nm_usuario_p text) FROM PUBLIC;

