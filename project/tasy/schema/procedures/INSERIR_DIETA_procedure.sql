-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_dieta (nr_prescricao_p bigint, cd_dieta_p bigint, nm_usuario_p text, cd_intervalo_p text) AS $body$
DECLARE

 
nr_sequencia_w			integer;
ie_prescr_dieta_sem_lib_w	varchar(30);
cd_estabelecimento_w		smallint;
ds_erro_w				varchar(2000);
ds_horarios1_w			varchar(2000);
ds_horarios2_w			varchar(2000);
hr_primeiro_horario_w	varchar(5);
ds_horarios_w			varchar(2000);
dt_inicio_medic_w		timestamp;
cd_intervalo_w			dieta.cd_intervalo%type;
cd_setor_prescr_w		prescr_medica.cd_setor_atendimento%type;
dt_primeiro_horario_w	timestamp;
dt_inicio_prescr_w		timestamp;
nr_horas_validade_w		integer;
nr_intervalo_w			bigint := 0;


BEGIN 
 
select	max(cd_estabelecimento) 
into STRICT	cd_estabelecimento_w 
from	usuario 
where	nm_usuario = nm_usuario_p;
 
ie_prescr_dieta_sem_lib_w := Obter_Param_Usuario(924, 530, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_prescr_dieta_sem_lib_w);
nr_intervalo_w := 0;
 
select	max(dt_primeiro_horario), 
		max(dt_inicio_prescr), 
		max(nr_horas_validade) 
into STRICT	 
		dt_primeiro_horario_w, 
		dt_inicio_prescr_w, 
		nr_horas_validade_w 
from	prescr_medica 
where	nr_prescricao		= nr_prescricao_p;
 
select 	obter_primeiro_horario(cd_intervalo_p,nr_prescricao_p,null,null) 
into STRICT		hr_primeiro_horario_w
;
 
select	converte_char_data(to_char(dt_primeiro_horario_w,'dd/mm/yyyy'),hr_primeiro_horario_w,dt_inicio_prescr_w) 
into STRICT		dt_inicio_medic_w
;
 
select	max(cd_intervalo) 
into STRICT 	cd_intervalo_w 
from	dieta 
where	cd_dieta = cd_dieta_p;
 
if (obter_se_limpa_prim_hor(coalesce(cd_intervalo_p, cd_intervalo_w), cd_setor_prescr_w) = 'S') then	 
	ds_horarios_w		:= '';
	dt_inicio_medic_w	:= null;			
end if;
	 
SELECT * FROM Calcular_Horario_Prescricao(nr_prescricao_p, coalesce(cd_intervalo_p, cd_intervalo_w), dt_primeiro_horario_w, dt_inicio_medic_w, nr_horas_validade_w, null, null, null, nr_intervalo_w, ds_horarios1_w, ds_horarios2_w, 'N', null) INTO STRICT nr_intervalo_w, ds_horarios1_w, ds_horarios2_w;
 
if (dt_inicio_medic_w IS NOT NULL AND dt_inicio_medic_w::text <> '') then 
	ds_horarios_w := substr(ds_horarios1_w||ds_horarios2_w,1,2000);
end if;
 
select	coalesce(max(nr_sequencia),0) + 1 
into STRICT	nr_sequencia_w 
from 	prescr_dieta 
where	nr_prescricao	= nr_prescricao_p;
 
insert into prescr_dieta( 
	nr_prescricao, 
	nr_sequencia, 
	cd_dieta, 
	dt_atualizacao, 
	nm_usuario, 
	ie_suspenso, 
	cd_intervalo, 
	ds_horarios, 
  hr_prim_horario) 
values (	nr_prescricao_p, 
	nr_sequencia_w, 
	cd_dieta_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	'N', 
	cd_intervalo_p, 
	ds_horarios_w, 
	hr_primeiro_horario_w);
 
	 
commit;
ds_erro_w := Consistir_prescr_dieta(nr_prescricao_p, nr_sequencia_w, cd_estabelecimento_w, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, ds_erro_w);
 
CALL gerar_suplementos_dieta(nr_prescricao_p,nr_sequencia_w,nm_usuario_p,obter_perfil_ativo);
 
if (ie_prescr_dieta_sem_lib_w = 'S') then 
	CALL Gerar_prescr_dieta_hor_sem_lib(nr_prescricao_p,nr_sequencia_w,obter_perfil_ativo,'N','','N',nm_usuario_p);
end if;
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_dieta (nr_prescricao_p bigint, cd_dieta_p bigint, nm_usuario_p text, cd_intervalo_p text) FROM PUBLIC;

