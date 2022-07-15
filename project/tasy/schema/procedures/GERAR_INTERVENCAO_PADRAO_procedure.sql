-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_intervencao_padrao ( nr_sequencia_p bigint, nr_seq_proc_p bigint, nm_usuario_p text) AS $body$
DECLARE


		

nr_seq_diag_w		bigint;
nr_seq_proc_w		bigint;
nr_sequencia_w		bigint;
qt_existe_w		bigint;
nr_seq_result_w		bigint;
cd_intervalo_w		varchar(7);
ds_horario_padrao_w	varchar(2000);
nr_seq_probl_colab_w	bigint;
ds_observacao_padr_w	varchar(255);
ie_adep_w		varchar(1);
vl_prim_hor_w		varchar(15);
hr_prim_horario_w		timestamp;
nr_intervalo_w		real;
ds_horarios_w		varchar(2000);
dt_prescricao_w		timestamp;
qt_horas_validade_w	bigint;
ds_prim_horario_w		varchar(255);
ie_se_necessario_w		varchar(1);
ie_auxiliar_w       varchar(10);
ie_encaminhar_w     varchar(10);
ie_fazer_w          varchar(10);
ie_orientar_w       varchar(10);
ie_supervisionar_w   varchar(10);
ie_Interv_Autom_w	varchar(1);
ie_agora_w			varchar(1);
nr_prescricao_w		bigint;
		
C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.cd_intervalo,
		a.ds_horario_padrao,
		a.ds_observacao_padr,
		a.ie_adep,
		a.ie_auxiliar,
		a.ie_encaminhar,
		a.ie_fazer,
		a.ie_orientar,
		a.ie_supervisionar
	from	pe_procedimento a
	where	a.nr_sequencia	= nr_seq_proc_p
	and	coalesce(a.ie_situacao,'A') = 'A'
	and	not exists (	SELECT	1
					from	pe_prescr_proc x
					where	x.nr_seq_prescr	= nr_sequencia_p
					and	x.nr_seq_proc	= a.nr_sequencia);

BEGIN


vl_prim_hor_w := obter_param_usuario(281, 325, obter_perfil_ativo, nm_usuario_p, 0, vl_prim_hor_w);
ie_Interv_Autom_w := obter_param_usuario(281, 735, obter_perfil_ativo, nm_usuario_p, 0, ie_Interv_Autom_w);

select	max(qt_horas_validade), coalesce(max(nr_prescricao),0)
into STRICT	qt_horas_validade_w, nr_prescricao_w
from	pe_prescricao
where	nr_sequencia	= nr_sequencia_p
and 	coalesce(ie_situacao,'A') = 'A';

open C01;
loop
fetch C01 into	
	nr_seq_proc_w,
	cd_intervalo_w,
	ds_horario_padrao_w,
	ds_observacao_padr_w,
	ie_adep_w,
	ie_auxiliar_w    ,
	ie_encaminhar_w  ,     
	ie_fazer_w       ,     
	ie_orientar_w    ,     
	ie_supervisionar_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	

	select	nextval('pe_prescr_proc_seq')
	into STRICT	nr_sequencia_w
	;

	if (vl_prim_hor_w = '1') then
        hr_prim_horario_w	:= ESTABLISHMENT_TIMEZONE_UTILS.todayAtTime(coalesce(obter_primeiro_horario_sae(cd_intervalo_w,	nr_sequencia_p),'00:00'));
		
	elsif (vl_prim_hor_w = '2') then
		hr_prim_horario_w 	:= trunc(dt_prescricao_w + (1/24),'hh24');
	end if;
	
	if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then
	
		SELECT * FROM calcular_horario_intervencao(cd_intervalo_w, hr_prim_horario_w, coalesce(qt_horas_validade_w,24), nr_intervalo_w, ds_horarios_w, ds_prim_horario_w, ie_se_necessario_w, nr_sequencia_p) INTO STRICT nr_intervalo_w, ds_horarios_w, ds_prim_horario_w, ie_se_necessario_w;
				
		if (coalesce(ds_horario_padrao_w::text, '') = '') then
			ds_horario_padrao_w	:= ds_horarios_w;
		end if;
	end if;	
	
	if (ie_Interv_Autom_w = 'S') then
	
			
		
        select  ESTABLISHMENT_TIMEZONE_UTILS.todayAtTime(coalesce(obter_primeiro_horario_sae(cd_intervalo_w, nr_sequencia_p),'00:00'))
		into STRICT	hr_prim_horario_w
		;				
		
	end if;
	
	select	max(ie_se_necessario),
			max(ie_agora)
	into STRICT	ie_se_necessario_w,
			ie_agora_w
	from	intervalo_prescricao
	where	cd_intervalo = cd_intervalo_w;
	
	insert into pe_prescr_proc(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_proc,
		nr_seq_prescr,
		qt_pontuacao,
		ds_origem,
		nr_seq_apres,
		cd_intervalo,
		ds_horarios,
		qt_intervencao,
		ie_se_necessario,
		ds_observacao,
		ie_suspenso,
		ie_adep,
		hr_prim_horario,
		ie_auxiliar    ,
		ie_encaminhar  ,     
		ie_fazer       ,     
		ie_orientar    ,     
		ie_supervisionar,
		ie_agora)
	values (	nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_proc_w,
		nr_sequencia_p,
		1,
		'A',
		1,
		cd_intervalo_w,
		ds_horario_padrao_w,
		1,
		ie_se_necessario_w,
		ds_observacao_padr_w,
		'N',
		ie_adep_w,
		to_char(hr_prim_horario_w,'hh24:mi'),
		ie_auxiliar_w    ,     
		ie_encaminhar_w  ,     
		ie_fazer_w       ,     
		ie_orientar_w    ,     
		ie_supervisionar_w,
		ie_agora_w);
		
	commit;

	CALL Atualizar_Horarios_SAE(nr_sequencia_w,nm_usuario_p);
	
	if (nr_prescricao_w > 0) then
		CALL gerar_prescr_item_sae(nr_sequencia_p,nr_sequencia_w,nm_usuario_p);
	end if;
	
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_intervencao_padrao ( nr_sequencia_p bigint, nr_seq_proc_p bigint, nm_usuario_p text) FROM PUBLIC;

