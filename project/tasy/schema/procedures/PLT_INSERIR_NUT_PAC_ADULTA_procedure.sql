-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_inserir_nut_pac_adulta ( nr_prescricao_p bigint, nr_sequencia_p bigint, VarVlEquipo_p bigint, ie_calculo_auto_p text, nm_usuario_p text) AS $body$
DECLARE

 
 
qt_ano_w		bigint;
qt_mes_w		bigint;
qt_dia_w		bigint;
cont_w			bigint;
qt_altura_cm_w 	real;
qt_peso_w		real;
qt_peso_ww		real;
nr_atendimento_w	bigint;
nr_seq_nut_w	bigint;
hr_prim_horario_w	varchar(5);

BEGIN
 
select	coalesce(max(a.nr_atendimento),0), 
	coalesce(coalesce(max(a.qt_altura_cm),max(b.qt_altura_cm)),0), 
	coalesce(max(a.qt_peso),0), 
	coalesce(max(substr(obter_idade(coalesce(b.dt_nascimento,clock_timestamp()),clock_timestamp(),'A'),1,5)),0) qt_ano, 
	coalesce(max(substr(obter_idade(coalesce(b.dt_nascimento,clock_timestamp()),clock_timestamp(),'MM'),1,5)),0) qt_mes, 
	coalesce(max(substr(obter_idade(coalesce(b.dt_nascimento,clock_timestamp()),clock_timestamp(),'DI'),1,5)),0) qt_dia, 
	coalesce(to_char(max(a.dt_inicio_prescr),'hh24:mi'),to_char(clock_timestamp(),'hh24:mi')) 
into STRICT	nr_atendimento_w, 
		qt_altura_cm_w, 
		qt_peso_w, 
		qt_ano_w, 
		qt_mes_w, 
		qt_dia_w, 
		hr_prim_horario_w 
from	prescr_medica a, 
		pessoa_fisica b 
where	nr_prescricao = nr_prescricao_p 
and		a.cd_pessoa_fisica = b.cd_pessoa_fisica;
 
 
qt_peso_ww := obter_sinal_vital(nr_atendimento_w,'Peso');
select	count(distinct(trunc(dt_prescricao))) + 1 
into STRICT	cont_w 
from 	prescr_medica b,  
		nut_pac a         
where 	a.nr_prescricao = b.nr_prescricao 
and		trunc(b.dt_prescricao) <> trunc(clock_timestamp()) 
and	 	b.nr_atendimento = nr_atendimento_w;
 
 
 
if (nr_prescricao_p > 0) then 
	select	nextval('nut_pac_seq') 
	into STRICT	nr_seq_nut_w 
	;
	insert into nut_pac(dt_atualizacao, 
						 ie_npt_adulta, 
						 nr_sequencia, 
						 qt_dia_npt, 
						 qt_equipo, 
						 qt_idade_ano, 
						 qt_idade_dia,       
						 qt_idade_mes,  
						 nm_usuario ,       
						 nr_prescricao,  														 
						 qt_peso, 
						 nr_seq_protocolo, 
						 qt_altura_cm, 
						 ie_ajustar_potassio, 
						 ie_calculo_auto, 
						 ie_correcao,       
						 ie_emissao, 
						 qt_fase_npt,          
						 qt_kcal_kg,        
						 qt_kcal_total, 
						 pr_proteina, 
						 ie_editado, 
						 ie_bomba_infusao, 
						 ie_calcula_vel, 
						 hr_prim_horario, 
						 ie_forma) 
				values ( 
						 clock_timestamp(), 
						 'S', 
						 nr_seq_nut_w, 
						 cont_w, 
						 coalesce(VarVlEquipo_p,0), 
						 qt_ano_w, 
						 qt_dia_w, 
						 qt_mes_w, 
						 nm_usuario_p, 
						 nr_prescricao_p, 
						 coalesce(qt_peso_w,qt_peso_ww), 
						 nr_sequencia_p, 
						 qt_altura_cm_w, 
						 'N', 
						 ie_calculo_auto_p, 
						 'N', 
						 0, 
						 1, 
						 0, 
						 0, 
						 0, 
						 'N', 
						 'S', 
						 'S', 
						 hr_prim_horario_w, 
						 'P');
CALL Calcular_nut_pac_adulto(nr_seq_nut_w,nm_usuario_p);	
CALL atualizar_status_item_prescr(nr_prescricao_p,nr_seq_nut_w,'P','NPT',nm_usuario_p);
				 
end if;
commit;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_inserir_nut_pac_adulta ( nr_prescricao_p bigint, nr_sequencia_p bigint, VarVlEquipo_p bigint, ie_calculo_auto_p text, nm_usuario_p text) FROM PUBLIC;
