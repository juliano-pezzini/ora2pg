-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rxt_atualizar_rxt_campo (nr_seq_fase_p bigint) AS $body$
DECLARE

	nr_seq_campo_w double precision;
	ds_campo_tratamento_w varchar(500);
	ie_tipo_x_w varchar(10);
	ie_tipo_y_w varchar(10);
	qt_tam_x_w bigint;
	qt_tam_y_w bigint;
	qt_x1_w bigint;
	qt_y1_w bigint;
	qt_x2_w bigint;
	qt_y2_w bigint;
	qt_numero_aplicacoes_w bigint;
	qt_dose_tumor_diaria_w bigint;
	qt_ssd_w bigint;
	qt_dose_tumor_real_w bigint;
	qt_angulo_gantry_w bigint;
	qt_angulo_gantry_final_w bigint;
	qt_angulo_colimador_w bigint;
	qt_ang_colimador_final_w bigint;
	qt_angulo_mesa_w bigint;
	qt_unidade_monitor_w bigint;
	nr_seq_energia_rad_w double precision;

c01 CURSOR FOR
    SELECT 	a.nr_seq_campo,
            a.ds_campo_tratamento,
            a.ie_tipo_x,
            a.ie_tipo_y,
            a.qt_tam_x,
            a.qt_tam_y,
            a.qt_x1,
            a.qt_y1,
            a.qt_x2,
            a.qt_y2,
            a.qt_numero_aplicacoes,
            a.qt_dose_tumor_diaria,
            a.qt_ssd,
            a.qt_dose_tumor_real,
            a.qt_angulo_gantry,
            a.qt_angulo_gantry_final,
            a.qt_angulo_colimador,
            a.qt_ang_colimador_final,
            a.qt_angulo_mesa,        
            a.qt_unidade_monitor,    
            a.nr_seq_energia_rad 
    from 	RXT_PLANEJAMENTO_FISICO a
    inner join rxt_fase_tratamento b on a.nr_seq_fase = b.nr_sequencia
    where	a.nr_sequencia in ( 
        SELECT a.nr_sequencia 
        from RXT_PLANEJAMENTO_FISICO a
        inner join rxt_fase_tratamento b on a.nr_seq_fase = b.nr_sequencia
        where /* a.dt_envio_fisico is null
        --and a.dt_lib_fisico is null

        and*/
 ie_situacao = 'A'
        and a.nr_seq_fase = nr_seq_fase
    );


BEGIN
	open c01;
	loop
	fetch c01 into
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
        nr_seq_energia_rad_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
    begin
    update 	RXT_CAMPO
	set		ie_tipo_x				=	ie_tipo_x_w,
			ie_tipo_y				=	ie_tipo_y_w, 
			qt_tam_x				=	qt_tam_x_w, 
			qt_tam_y				=	qt_tam_y_w, 
			qt_x1					=	qt_x1_w, 
			qt_y1					=	qt_y1_w, 
			qt_x2					=	qt_x2_w, 
			qt_y2					=	qt_y2_w, 
			nr_aplicacoes			=	qt_numero_aplicacoes_w, 
			qt_dose_diaria			=	qt_dose_tumor_diaria_w,
			qt_ssd					=	qt_ssd_w, 
			qt_dose_total			=	qt_dose_tumor_real_w, 
			qt_angulo_gantry		=	qt_angulo_gantry_w, 
			qt_angulo_gantry_final	=	qt_angulo_gantry_final_w,
			qt_angulo_colimador		=	qt_angulo_colimador_w,
			qt_ang_colimador_final	=	qt_ang_colimador_final_w,
			qt_angulo_mesa			=	qt_angulo_mesa_w, 
			qt_dose_monitor			=	qt_unidade_monitor_w, 
			nr_seq_energia_rad		=	nr_seq_energia_rad_w
    where	nr_seq_fase 			=	nr_seq_fase_p;
	commit;
	
    end;

    end loop;
    close c01;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rxt_atualizar_rxt_campo (nr_seq_fase_p bigint) FROM PUBLIC;
