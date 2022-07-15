-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_horarios_recalculados ( nr_seq_lote_p bigint, ie_qt_adicional_p text, nr_motivo_p bigint, ds_motivo_p text, nr_seq_lote_out_p INOUT bigint) AS $body$
DECLARE


nr_prescricao_w			bigint;
ds_itens_liberar_w		varchar(4000);
nr_prescricao_out_w		bigint;
prescr_medica_w			prescr_medica%rowtype;
ds_itens_liberados_w		varchar(4000);
ie_inconsistencia_w		varchar(4000);
ds_lista_proc_susp_out_w	varchar(4000);
ds_inconsist_lib_out_w		varchar(4000);
ds_prescr_geradas_full_w	varchar(4000);
nr_seq_mat_cpoe_w		bigint;
nr_seq_material_w		bigint;
prescr_mat_hor_w		prescr_mat_hor%rowtype;
qt_dispensar_w			prescr_mat_hor.qt_dispensar%type;
nm_usuario_w			varchar(255)	:= obter_usuario_ativo;
nr_seq_historico_w		ap_lote_historico.nr_sequencia%type;


C01 CURSOR FOR
	SELECT	*
	from	w_ap_lote_desdob
	where	nr_seq_lote	= nr_seq_lote_p;

BEGIN

select	max(nr_prescricao)
into STRICT	nr_prescricao_w
from	ap_lote
where	nr_sequencia = nr_seq_lote_p;

select	*
into STRICT	prescr_medica_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_w;


for r_c01 in c01 loop
	begin
	
	select	coalesce(max(b.nr_seq_mat_cpoe),0),
		max(b.nr_sequencia)
	into STRICT	nr_seq_mat_cpoe_w,
		nr_seq_material_w
	from	prescr_medica a,
		prescr_material	b,
		cpoe_material c,
		prescr_mat_hor d
	where	a.nr_prescricao 	= b.nr_prescricao
	and	b.nr_seq_mat_cpoe 	= c.nr_sequencia
	and 	b.nr_prescricao 	= d.nr_prescricao
	and 	b.nr_sequencia 		= d.nr_seq_material
	and 	a.nr_prescricao		= nr_prescricao_w
	and 	d.nr_sequencia 		= r_c01.nr_seq_mat_hor;
		
	qt_dispensar_w	:= r_c01.qt_ajuste;
	
	select	*
	into STRICT	prescr_mat_hor_w
	from	prescr_mat_hor
	where	nr_sequencia		= r_c01.nr_seq_mat_hor;
	
	select	nextval('prescr_mat_hor_seq')
	into STRICT	prescr_mat_hor_w.nr_sequencia
	;
	
	prescr_mat_hor_w.nm_usuario		:= nm_usuario_w;
	prescr_mat_hor_w.nm_usuario_nrec	:= nm_usuario_w;
	prescr_mat_hor_w.dt_atualizacao		:= clock_timestamp();
	prescr_mat_hor_w.dt_atualizacao_nrec	:= clock_timestamp();
	prescr_mat_hor_w.ie_gerar_lote		:= 'S';
	prescr_mat_hor_w.ie_aprazado		:= 'S';
	prescr_mat_hor_w.qt_dispensar		:= qt_dispensar_w;
	prescr_mat_hor_w.qt_dispensar_hor	:= qt_dispensar_w;
	prescr_mat_hor_w.dt_horario		:= clock_timestamp();
	prescr_mat_hor_w.nr_seq_lote		:= null;
	prescr_mat_hor_w.dt_fim_horario		:= null;
	prescr_mat_hor_w.dt_suspensao		:= null;
	prescr_mat_hor_w.ie_horario_especial	:= 'S';
	prescr_mat_hor_w.dt_disp_farmacia	:= null;

	insert	into prescr_mat_hor values (prescr_mat_hor_w.*);
	
	update	prescr_material
	set	ie_gerar_lote		= 'S',
		cd_motivo_baixa		= 0,
		dt_baixa		 = NULL
	where	nr_prescricao 		= nr_prescricao_w
	and	nr_sequencia		= nr_seq_material_w;
	
	CALL Gerar_Lote_Atend_Prescricao(	nr_prescricao_w,
					nr_seq_material_w,
					prescr_mat_hor_w.nr_sequencia,
					'S',
					nm_usuario_w,
					'AIP');
					
	select	coalesce(max(nr_seq_lote),0)
	into STRICT	nr_seq_lote_out_p
	from	prescr_mat_hor
	where	nr_sequencia = prescr_mat_hor_w.nr_sequencia;
	
	if (nr_seq_lote_out_p > 0) then
		select	nextval('ap_lote_historico_seq')
		into STRICT	nr_seq_historico_w
		;
		
		insert into ap_lote_historico(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_lote,
			nr_seq_mot_desdobrar,
			ds_evento,
			ds_log,
			ie_tipo_motivo)
		values (
			nr_seq_historico_w,
			clock_timestamp(),
			nm_usuario_w,
			nr_seq_lote_out_p,
			nr_motivo_p,
			obter_desc_expressao(728860),
			ds_motivo_p,
			'DM');
	end if;
	
	end;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_horarios_recalculados ( nr_seq_lote_p bigint, ie_qt_adicional_p text, nr_motivo_p bigint, ds_motivo_p text, nr_seq_lote_out_p INOUT bigint) FROM PUBLIC;

