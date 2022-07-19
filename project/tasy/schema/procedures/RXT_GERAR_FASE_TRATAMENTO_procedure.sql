-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rxt_gerar_fase_tratamento ( nr_seq_planejamento_fisico_p bigint, nm_usuario_p text ) AS $body$
DECLARE

			
nr_sequencia_w 		bigint;
nr_seq_campo_w   		bigint;
ds_campo_tratamento_w 	varchar(80);
ie_tipo_x_w 		varchar(1);
ie_tipo_y_w 		varchar(1);
qt_tam_x_w 		double precision;
qt_tam_y_w 		double precision;
qt_x1_w 			double precision;
qt_y1_w 			double precision;
qt_x2_w 			double precision;
qt_y2_w 			double precision;
qt_numero_aplicacoes_w 	 double precision;
qt_dose_tumor_diaria_w 	 double precision;
qt_ssd_w  		double precision;
qt_dose_tumor_real_w  	double precision;
qt_angulo_gantry_w  	double precision;
qt_angulo_gantry_final_w 	 double precision;
qt_angulo_colimador_w  	double precision;
qt_ang_colimador_final_w 	double precision;
qt_angulo_mesa_w 		double precision;
qt_unidade_monitor_w 	double precision;
nr_seq_energia_rad_w  	bigint;
nr_seq_ene_fotons_w 	bigint;
cd_estabelecimento_w 	smallint;
dt_atualizacao_w 		timestamp;
nm_usuario_w 		varchar(15);
dt_atualizacao_nrec_w 	timestamp;
nm_usuario_nrec_w 	varchar(15);
nr_seq_fase_w 		bigint;
nr_seq_rxt_campo_w 	bigint;
ie_situacao_w  		varchar(1);


BEGIN

	select
	nr_sequencia, 
	nr_seq_campo, 
	ds_campo_tratamento, 
	ie_tipo_x, 
	ie_tipo_y, 
	qt_tam_x, 
	qt_tam_y, 
	qt_x1, 
	qt_y1, 
	qt_x2, 
	qt_y2, 
	qt_numero_aplicacoes, 
	qt_dose_tumor_diaria,
	qt_ssd, 
	qt_dose_tumor_real, 
	qt_angulo_gantry, 
	qt_angulo_gantry_final, 
	qt_angulo_colimador,
	qt_ang_colimador_final, 
	qt_angulo_mesa, 
	qt_unidade_monitor, 
	nr_seq_energia_rad,
	nr_seq_ene_fotons, 
	cd_estabelecimento, 
	dt_atualizacao, 
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_fase,
	nr_seq_rxt_campo, 
	ie_situacao
	into STRICT
	nr_sequencia_w, 
	nr_seq_campo_w,
	ds_campo_tratamento_w,
	ie_tipo_x_w, 
	ie_tipo_y_w, 
	qt_tam_x_w, 
	qt_tam_y_w, 
	qt_x1_w, 
	qt_y1_w, 
	qt_x2_w, 
	qt_y2_w, 
	qt_numero_aplicacoes_w, 
	qt_dose_tumor_diaria_w,
	qt_ssd_w, 
	qt_dose_tumor_real_w, 
	qt_angulo_gantry_w, 
	qt_angulo_gantry_final_w, 
	qt_angulo_colimador_w,
	qt_ang_colimador_final_w, 
	qt_angulo_mesa_w, 
	qt_unidade_monitor_w, 
	nr_seq_energia_rad_w,
	nr_seq_ene_fotons_w, 
	cd_estabelecimento_w, 
	dt_atualizacao_w, 
	nm_usuario_w,
	dt_atualizacao_nrec_w,
	nm_usuario_nrec_w,
	nr_seq_fase_w,
	nr_seq_rxt_campo_w, 
	ie_situacao_w
	from rxt_planejamento_fisico
	where nr_sequencia = nr_seq_planejamento_fisico_p
	and nm_usuario = nm_usuario_p;


	insert into rxt_campo(
	nr_sequencia,
	nr_seq_campo,
	ds_campo,
	ie_tipo_x,
	ie_tipo_y,
	qt_tam_x,
	qt_tam_y,
	qt_x1,
	qt_y1,
	qt_x2,
	qt_y2,
	nr_aplicacoes,
	qt_dose_diaria,
	qt_ssd,
	qt_dose_total,
	qt_angulo_gantry,
	qt_angulo_gantry_final,
	qt_angulo_colimador,
	qt_ang_colimador_final,
	qt_angulo_mesa,
	qt_dose_monitor,
	nr_seq_energia_rad,
	nr_seq_ene_fotons,
	NR_SEQ_FASE,
	nm_usuario,
	nm_usuario_nrec,
	dt_atualizacao,
	dt_atualizacao_nrec,
	dt_envio_fisico,
	dt_lib_fisico)
	values (
	nextval('rxt_campo_seq'),
	nr_seq_campo_W,
	ds_campo_tratamento_w,
	ie_tipo_x_w,
	ie_tipo_y_w,
	qt_tam_x_w,
	qt_tam_y_w,
	qt_x1_w,
	qt_y1_w,
	qt_x2_w,
	qt_y2_w,
	qt_numero_aplicacoes_w,
	qt_dose_tumor_diaria_w,
	qt_ssd_w,
	qt_dose_tumor_real_w,
	qt_angulo_gantry_w,
	qt_angulo_gantry_final_w,
	qt_angulo_colimador_w,
	qt_ang_colimador_final_w,
	qt_angulo_mesa_w,
	qt_unidade_monitor_w,
	nr_seq_energia_rad_w,
	nr_seq_ene_fotons_w,
	NR_SEQ_FASE_w,
	nm_usuario_p,
	nm_usuario_p,
	clock_timestamp(),
	clock_timestamp(),
	clock_timestamp(),
	clock_timestamp()
	);
		
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rxt_gerar_fase_tratamento ( nr_seq_planejamento_fisico_p bigint, nm_usuario_p text ) FROM PUBLIC;

