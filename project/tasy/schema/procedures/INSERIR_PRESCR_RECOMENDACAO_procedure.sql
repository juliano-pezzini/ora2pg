-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_prescr_recomendacao ( nr_prescricao_p bigint, ds_lista_recomend_p text, nm_usuario_p text, cd_kit_p bigint default null,-- Hudson 
 nr_seq_classif_p bigint DEFAULT NULL, cd_intervalo_p text DEFAULT NULL, nr_seq_topografia_p text DEFAULT NULL, ds_complemento_p text DEFAULT NULL, cd_perfil_p bigint DEFAULT NULL) AS $body$
DECLARE

 
lista_informacao_w		varchar(1000);
ie_contador_w			bigint := 0;
tam_lista_w				bigint;
ie_pos_virgula_w		smallint;
cd_recomendacao_w		bigint;
nr_sequencia_w			bigint;
cd_setor_prescricao_w	bigint;
nr_seq_topografia_w		bigint;
cd_intervalo_w			varchar(7);
hr_prim_horario_w		varchar(5);
ie_recomendacao_alta_w	varchar(5);
dt_hora_inicio_w		timestamp;
cd_estabelecimento_w	smallint;
ie_atualiza_prescr_alta_w varchar(1);
ie_prim_horario_w		varchar(255);
ds_horario1_w			varchar(255);
ds_horario2_w			varchar(255);
ds_complemento_w		prescr_recomendacao.ds_recomendacao%type;
dt_inicio_prescr_w		timestamp;
nr_horas_validade_w		integer;
nr_ocorrencia_w			bigint := 0;
cd_convenio_w			bigint;
nr_seq_agrupamento_w	bigint;
ie_prescr_rec_sem_lib_w	varchar(255);
dt_primeiro_horario_w	timestamp;
ie_seleciona_kit_rec_w	varchar(1);
cd_kit_w				bigint;
varKitMateAutomatico_w	varchar(2);
ds_erro_w				varchar(2000);
ie_limpa_prim_hor_w		varchar(1) := 'N';
ie_sem_aprazamento_w	varchar(1) := 'N';
ie_urgencia_w			varchar(1);
ie_agora_w				varchar(1);
ie_check_intervalo_w	varchar(1);
ie_agora_acm_sn_w		varchar(6);
ie_acm_w 	 			varchar(1);
ie_se_necessario_w 		varchar(1);
varCheckIntervSN_w		varchar(1);
ds_horario_ag_w			varchar(255);

C01 CURSOR FOR 
SELECT	cd_kit 
from	kit_mat_recomendacao 
where	cd_recomendacao 	= cd_recomendacao_w 
and	((coalesce(cd_perfil,0) = 0) or (cd_perfil = cd_perfil_p)) 
and	((coalesce(cd_convenio::text, '') = '') or (cd_convenio = cd_convenio_w)) 
and	((coalesce(nr_seq_agrupamento::text, '') = '') or (nr_seq_agrupamento = nr_seq_agrupamento_w)) 
and	((coalesce(cd_setor_atendimento,0) = 0) or (cd_setor_atendimento = cd_setor_prescricao_w));


BEGIN 
 
select	max(to_char(coalesce(dt_primeiro_horario,dt_inicio_prescr),'hh24:mi')), 
		max(cd_estabelecimento), 
		max(dt_inicio_prescr), 
		max(nr_horas_validade), 
		max(cd_setor_atendimento), 
		max(obter_convenio_atendimento(nr_atendimento)) 
into STRICT	hr_prim_horario_w, 
		cd_estabelecimento_w, 
		dt_inicio_prescr_w, 
		nr_horas_validade_w, 
		cd_setor_prescricao_w, 
		cd_convenio_w 
from	prescr_medica 
where	nr_prescricao	= nr_prescricao_p;
 
select	max(nr_seq_agrupamento) 
into STRICT	nr_seq_agrupamento_w 
from	setor_atendimento 
where	cd_setor_atendimento = cd_setor_prescricao_w;
 
ie_prim_horario_w := Obter_Param_Usuario(924, 208, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_prim_horario_w);
ie_atualiza_prescr_alta_w := obter_param_usuario(924, 409, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_atualiza_prescr_alta_w);
ie_prescr_rec_sem_lib_w := Obter_Param_Usuario(924, 530, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_prescr_rec_sem_lib_w);
ie_seleciona_kit_rec_w := Obter_Param_Usuario(924, 458, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_seleciona_kit_rec_w);
varKitMateAutomatico_w := Obter_Param_Usuario(924, 968, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, varKitMateAutomatico_w);
ie_check_intervalo_w := Obter_Param_Usuario(924, 809, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_check_intervalo_w);
varCheckIntervSN_w := Obter_Param_Usuario(924, 650, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, varCheckIntervSN_w);
 
lista_informacao_w	:= ds_lista_recomend_p;
 
while	(lista_informacao_w IS NOT NULL AND lista_informacao_w::text <> '') or 
		ie_contador_w > 200 loop 
	begin	 
	tam_lista_w			:= length(lista_informacao_w);
	ie_pos_virgula_w	:= position(',' in lista_informacao_w);
 
	/* Obter a sequência lida */
 
	if (ie_pos_virgula_w <> 0) then 
		cd_recomendacao_w	:= substr(lista_informacao_w,1,(ie_pos_virgula_w - 1));
		lista_informacao_w	:= substr(lista_informacao_w,(ie_pos_virgula_w + 1),tam_lista_w);
	end if;
	 
	/* Obtem a nova sequência */
 
	select	coalesce(max(nr_sequencia),0)+1 
	into STRICT	nr_sequencia_w 
	from	prescr_recomendacao 
	where	nr_prescricao		= nr_prescricao_p;
	 
	select	max(nr_seq_topografia), 
			max(ds_complemento), 
			coalesce(cd_intervalo_p,max(cd_intervalo)), 
			coalesce(max(ie_urgencia),'N') 
	into STRICT	nr_seq_topografia_w, 
			ds_complemento_w, 
			cd_intervalo_w, 
			ie_urgencia_w 
	from	tipo_recomendacao 
	where	cd_tipo_recomendacao	= cd_recomendacao_w;
	 
	/* Obtem regra intervalo setor, da Classificação Recomendação, caso houver */
 
	cd_intervalo_w := coalesce(obter_se_interv_setor_rec(cd_recomendacao_w, cd_setor_prescricao_w), cd_intervalo_w);
		 
	if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') or (ie_urgencia_w = 'S') then 
		 
		ie_agora_w := obter_se_intervalo_agora(cd_intervalo_w);
		 
		if (ie_agora_w 	= 'N') 	and (ie_urgencia_w 	= 'S')	then 
			 
			select	max(cd_intervalo) 
			into STRICT	cd_intervalo_w 
			from 	intervalo_prescricao 
			where 	ie_agora = 'S' 
			and 	((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = cd_estabelecimento_w)) 
			and 	Obter_se_intervalo(cd_intervalo,'R') = 'S' 
			and 	ie_situacao = 'A';
		end if;	
		 
		if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '')	then 
			select	coalesce(max(ie_limpa_prim_hor),'N'), 
					coalesce(max(ie_sem_aprazamento),'N') 
			into STRICT	ie_limpa_prim_hor_w, 
					ie_sem_aprazamento_w 
			from	intervalo_prescricao 
			where	cd_intervalo = cd_intervalo_w;
			 
				if (ie_limpa_prim_hor_w = 'S') then 
					hr_prim_horario_w := null;
				elsif (obter_se_intervalo_agora(cd_intervalo_w) = 'S') and (ie_urgencia_w = 'S') then 
					select to_char(clock_timestamp(),'hh24:mi') 
					into STRICT	hr_prim_horario_w 
					;
				else 
					select	coalesce(max(obter_primeiro_horario(cd_intervalo_w, nr_prescricao_p, 0, null)), hr_prim_horario_w) 
					into STRICT	hr_prim_horario_w 
					;
				end if;
		end if;
	end if;
 
	if (ie_prim_horario_w = 'N') then 
		hr_prim_horario_w	:= '';
		if (coalesce(cd_intervalo_w::text, '') = '') then 
			ie_sem_aprazamento_w := 'S';
		end if;	
	end if;
	 
	if (length(hr_prim_horario_w) = 5) then 
		dt_hora_inicio_w := to_date(to_char(dt_inicio_prescr_w,'dd/mm/yyyy') || hr_prim_horario_w || ':00', 'dd/mm/yyyy hh24:mi:ss');
	end if;
	 
	ds_horario1_w 	:= null;
	ds_horario2_w 	:= null;
	ds_horario_ag_w := null;
	 
	if (ie_sem_aprazamento_w = 'N') 	and (ie_limpa_prim_hor_w = 'N')	then 
		SELECT * FROM Calcular_Horario_Prescricao(nr_prescricao_p, cd_intervalo_w, dt_inicio_prescr_w, dt_hora_inicio_w, nr_horas_validade_w, 0, 0, 0, nr_ocorrencia_w, ds_horario1_w, ds_horario2_w, 'N', null) INTO STRICT nr_ocorrencia_w, ds_horario1_w, ds_horario2_w;
	end if;
 
	if (ds_complemento_p IS NOT NULL AND ds_complemento_p::text <> '') then 
		ds_complemento_w := to_char(substr(ds_complemento_p,1,4000));
	end if;
	 
	ie_acm_w 	  		:= 'N';
	ie_se_necessario_w := 'N';
	 
	if (ie_check_intervalo_w = 'S') then 
	begin	 
	ie_agora_acm_sn_w := obter_se_interv_agora_acm_sn(cd_intervalo_w);		
	if (ie_agora_acm_sn_w IS NOT NULL AND ie_agora_acm_sn_w::text <> '') then 
		begin		 
		ie_urgencia_w 	  := 'N';		
		 
		if (ie_agora_acm_sn_w = 'AGORA') then 
			ie_urgencia_w := 'S';
			ds_horario_ag_w := to_char(clock_timestamp(),'hh24:mi');		
		elsif	(ie_agora_acm_sn_w = 'SN' AND varCheckIntervSN_w = 'S') then 
			ie_se_necessario_w := 'S';
		 
		elsif (ie_agora_acm_sn_w = 'ACM') then			 
			ie_acm_w := 'S';			
		end if;
		end;
	end if;	
	end;
	end if;
	 
	insert into prescr_recomendacao( 
		nr_prescricao, 
		nr_sequencia, 
		ie_destino_rec, 
		dt_atualizacao, 
		nm_usuario, 
		cd_recomendacao, 
		nr_seq_classif, 
		ie_suspenso, 
		cd_intervalo, 
		hr_prim_horario, 
		ds_horarios, 
		cd_kit, 
		ds_recomendacao, 
		nr_seq_topografia, 
		ie_urgencia, 
		ie_acm, 
		ie_se_necessario) 
	values ( 
		nr_prescricao_p, 
		nr_sequencia_w, 
		'E', 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_recomendacao_w, 
		nr_seq_classif_p, 
		'N', 
		cd_intervalo_w, 
		coalesce(ds_horario_ag_w, hr_prim_horario_w), 
		coalesce(ds_horario_ag_w, ds_horario1_w || ds_horario2_w), 
		CASE WHEN cd_kit_p=0 THEN null  ELSE cd_kit_p END , 
		ds_complemento_w, 
		coalesce(nr_seq_topografia_p, nr_seq_topografia_w), 
		ie_urgencia_w, 
		ie_acm_w, 
		ie_se_necessario_w);
	commit;
 
	CALL Gerar_proced_assoc_rec(nr_prescricao_p, cd_recomendacao_w, nm_usuario_p,'I');	
	ds_erro_w := Consistir_prescr_recomendacao(nr_prescricao_p, nr_sequencia_w, cd_estabelecimento_w, cd_perfil_p, nm_usuario_p, ds_erro_w);
		 
	if (ie_seleciona_kit_rec_w = 'N') then 
		open C01;
		loop 
		fetch C01 into	 
			cd_kit_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			CALL Inserir_kit_recomendacao(nm_usuario_p, nr_prescricao_p, nr_sequencia_w, cd_recomendacao_w, cd_kit_w);
		end loop;
		close C01;
	end if;
	 
	if (varKitMateAutomatico_w = 'S') then 
	   CALL Gerar_Kit_rec_Prescricao(cd_estabelecimento_w,nr_prescricao_p,nr_sequencia_w,nm_usuario_p,'N','N');	
	end if;
	 
	if (ie_prescr_rec_sem_lib_w = 'S') then 
		CALL Gerar_prescr_hor_sem_lib(nr_prescricao_p,nr_sequencia_w,cd_perfil_p,'N',nm_usuario_p);
	end if;
 
	ie_contador_w	:= ie_contador_w + 1;	
	end;
end loop;
 
select	Obter_se_recomendacao_alta(nr_prescricao_p) 
into STRICT	ie_recomendacao_alta_w
;
 
if (ie_recomendacao_alta_w = 'S') then 
 
	select	max(CASE WHEN ie_atualiza_prescr_alta_w='N' THEN dt_primeiro_horario  ELSE dt_prescricao END ), 
			max(nr_horas_validade) 
	into STRICT	dt_primeiro_horario_w, 
			nr_horas_validade_w 
	from	prescr_medica 
	where	nr_prescricao = nr_prescricao_p;
 
	if (ie_atualiza_prescr_alta_w = 'T') then 
		nr_horas_validade_w	:= 24;		
	end if;
	 
	update	prescr_medica 
    set	ie_prescricao_alta 	= 'S', 
			dT_primeiro_horario 	= dt_primeiro_horario_w, 
			nr_horas_validade	= nr_horas_validade_w 
	where	nr_prescricao = nr_prescricao_p;
	 
	if (ie_atualiza_prescr_alta_w	<> 'N') then 
		CALL Recalcular_hor_prescricao(nr_prescricao_p, nm_usuario_p);
		CALL recalcular_hora_sol(nr_prescricao_p, dt_primeiro_horario_w, cd_estabelecimento_w, cd_perfil_p, nm_usuario_p);
	end if;
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_prescr_recomendacao ( nr_prescricao_p bigint, ds_lista_recomend_p text, nm_usuario_p text, cd_kit_p bigint default null, nr_seq_classif_p bigint DEFAULT NULL, cd_intervalo_p text DEFAULT NULL, nr_seq_topografia_p text DEFAULT NULL, ds_complemento_p text DEFAULT NULL, cd_perfil_p bigint DEFAULT NULL) FROM PUBLIC;

