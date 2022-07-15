-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aprazar_item_dialise (nr_prescricao_p bigint, nr_seq_material_p bigint, nr_seq_dialise_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
nr_sequencia_w		bigint;
cd_setor_prescr_w	bigint;
nr_agrupamento_w	bigint;
nr_atendimento_w	bigint;
ie_gerar_lote_ww	varchar(1);
ie_classif_urgente_w	classif_lote_disp_far.ie_classif_urgente%type;
ie_controlado_w		classif_lote_disp_far.ie_controlado%type;
ie_padronizado_w	classif_lote_disp_far.ie_padronizado%type;
nr_seq_classif_w	classif_lote_disp_far.nr_sequencia%type;
nr_seq_classif_param_w prescr_mat_hor.nr_seq_classif%type;
nr_seq_hor_w		bigint;
ie_gerar_proc_gedipa_job_w	varchar(1);

c01 CURSOR FOR 
	SELECT	nr_sequencia, 
		ie_classif_urgente, 
		ie_controlado, 
		ie_padronizado 
	from	classif_lote_disp_far 
	where	cd_estabelecimento = cd_estabelecimento_p 
	and	ie_situacao = 'A' 
	order by ie_classif_urgente, 
		ie_controlado desc, 
		ie_padronizado desc;


BEGIN 
 
ie_gerar_lote_ww := obter_param_usuario(1113, 342, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_lote_ww);
nr_seq_classif_param_w := obter_param_usuario(1113, 498, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, nr_seq_classif_param_w);		
 
select	coalesce(max(ie_gerar_proc_gedipa_job),'S') 
into STRICT	ie_gerar_proc_gedipa_job_w 
from	parametros_farmacia 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
select	max(nr_sequencia) 
into STRICT	nr_sequencia_w 
from	prescr_mat_hor 
where	nr_prescricao	= nr_prescricao_p 
and	nr_seq_material	= nr_seq_material_p 
and	nr_seq_dialise	= nr_seq_dialise_p;
 
if (nr_sequencia_w > 0) then 
 
	select	max(cd_setor_atendimento), 
		max(nr_atendimento) 
	into STRICT	cd_setor_prescr_w, 
		nr_atendimento_w 
	from	prescr_medica 
	where	nr_prescricao	= nr_prescricao_p;
	 
	select	max(nr_agrupamento) 
	into STRICT	nr_agrupamento_w 
	from	prescr_material 
	where	nr_prescricao	= nr_prescricao_p 
	and	nr_sequencia	= nr_seq_material_p;
	 
	select	nextval('prescr_mat_hor_seq') 
	into STRICT	nr_seq_hor_w 
	;
	 
	insert into prescr_mat_hor(cd_local_estoque        , 
		cd_material           , 
		cd_motivo_baixa         , 
		cd_setor_exec          , 
		cd_unidade_medida        , 
		cd_unidade_medida_conta     , 
		cd_unidade_medida_dose     , 
		cd_unid_med_hor         , 
		ds_cor             , 
		ds_diluicao           , 
		ds_horario           , 
		ds_horario_char         , 
		ds_motivo_susp         , 
		ds_turno            , 
		dt_atualizacao      , 
		dt_atualizacao_nrec    ,    
		dt_checagem        ,   
		dt_disp_farmacia      ,   
		dt_emissao_farmacia     ,  
		dt_fim_horario        ,  
		dt_horario           , 
		dt_inicio_horario        , 
		dt_interrupcao         , 
		dt_lib_horario         , 
		dt_prev_fim_horario       , 
		dt_recusa            , 
		dt_suspensao          , 
		ie_adep             , 
		ie_agrupador       , 
		ie_aprazado       , 
		ie_checagem        ,    
		ie_ciente         ,   
		ie_classif_urgente     ,   
		ie_controlado        ,  
		ie_dispensar_farm       ,  
		ie_dose_especial        , 
		ie_etapa_especial        , 
		ie_gedipa            , 
		ie_gerar_lote          , 
		ie_horario_especial       , 
		ie_nec_etiqueta         , 
		ie_padronizado         , 
		ie_pendente           , 
		ie_separado           , 
		ie_situacao           , 
		ie_somente_pt          , 
		ie_suspenso_adep        , 
		ie_tipo_item_processo      , 
		ie_transferido         , 
		ie_urgente        , 
		nm_usuario        , 
		nm_usuario_adm      ,    
		nm_usuario_checagem    ,   
		nm_usuario_inicio      ,   
		nm_usuario_inter       ,  
		nm_usuario_nrec        ,  
		nm_usuario_reaprazamento    , 
		nm_usuario_susp         , 
		nr_agrupamento         , 
		nr_etapa_sol          , 
		nr_motivo_disp         , 
		nr_ocorrencia          , 
		nr_ordem_compra         , 
		nr_prescricao      , 
		nr_seq_area_prep     ,    
		nr_seq_assinatura_susp   ,   
		nr_seq_classif       ,   
		nr_seq_dialise        ,  
		nr_seq_digito         ,  
		nr_seq_etiqueta        , 
		nr_seq_jejum_susp        , 
		nr_seq_lote           , 
		nr_seq_lote_fornec       , 
		nr_seq_material     , 
		nr_seq_motivo_susp    ,    
		nr_seq_processo      ,   
		nr_seq_regra_area_prep   ,   
		nr_seq_regra_disp      ,  
		nr_seq_solucao        ,  
		nr_seq_superior        , 
		nr_seq_turno          , 
		nr_sequencia       , 
		qt_conta         ,    
		qt_dispensar        ,   
		qt_dispensar_hor      ,   
		qt_dose           ,  
		qt_horario          ,  
		qt_hor_reaprazamento, 
		nr_atendimento) 
	SELECT	cd_local_estoque        , 
		cd_material           , 
		0, 
		cd_setor_exec          , 
		cd_unidade_medida        , 
		cd_unidade_medida_conta     , 
		cd_unidade_medida_dose     , 
		cd_unid_med_hor         , 
		ds_cor             , 
		ds_diluicao           , 
		to_char(clock_timestamp(),'hh24:mi')   , 
		ds_horario_char         , 
		ds_motivo_susp         , 
		ds_turno            , 
		clock_timestamp()      , 
		clock_timestamp()    ,    
		dt_checagem        ,   
		dt_disp_farmacia      ,   
		dt_emissao_farmacia     ,  
		null        ,  
		clock_timestamp()           , 
		null        , 
		null         , 
		clock_timestamp()         , 
		dt_prev_fim_horario       , 
		null            , 
		null          , 
		ie_adep             , 
		ie_agrupador       , 
		ie_aprazado       , 
		ie_checagem        ,    
		ie_ciente         ,   
		ie_classif_urgente     ,   
		ie_controlado        ,  
		ie_dispensar_farm       ,  
		ie_dose_especial        , 
		ie_etapa_especial        , 
		ie_gedipa            , 
		ie_gerar_lote          , 
		ie_horario_especial       , 
		ie_nec_etiqueta         , 
		ie_padronizado         , 
		ie_pendente           , 
		ie_separado           , 
		ie_situacao           , 
		ie_somente_pt          , 
		ie_suspenso_adep        , 
		ie_tipo_item_processo      , 
		ie_transferido         , 
		ie_urgente        , 
		nm_usuario_p        , 
		null      ,    
		null    ,   
		null      ,   
		null       ,  
		nm_usuario_p        ,  
		nm_usuario_reaprazamento    , 
		null         , 
		nr_agrupamento         , 
		nr_etapa_sol          , 
		nr_motivo_disp         , 
		nr_ocorrencia          , 
		nr_ordem_compra         , 
		nr_prescricao      , 
		nr_seq_area_prep     ,    
		nr_seq_assinatura_susp   ,   
		nr_seq_classif       ,   
		nr_seq_dialise_p        ,  
		nr_seq_digito         ,  
		nr_seq_etiqueta        , 
		nr_seq_jejum_susp        , 
		nr_seq_lote           , 
		nr_seq_lote_fornec       , 
		nr_seq_material_p     , 
		null    ,    
		nr_seq_processo      ,   
		nr_seq_regra_area_prep   ,   
		nr_seq_regra_disp      ,  
		nr_seq_solucao        ,  
		nr_seq_superior        , 
		nr_seq_turno          , 
		nr_seq_hor_w, 
		qt_conta         ,    
		qt_dispensar        ,   
		qt_dispensar_hor      ,   
		qt_dose           ,  
		qt_horario          ,  
		qt_hor_reaprazamento, 
		nr_atendimento 
	from	prescr_mat_hor 
	where	nr_sequencia	= nr_sequencia_w;
 
	if (ie_gerar_proc_gedipa_job_w	= 'N') then 
		CALL Gedipa_Gerar_Proc_Instantaneo(nr_prescricao_p,null,null,nr_seq_hor_w);
	end if;
	 
	CALL aprazar_itens_dependentes(cd_estabelecimento_p, cd_setor_prescr_w, nr_atendimento_w, nr_prescricao_p, nr_seq_material_p, nr_agrupamento_w, clock_timestamp(), 'S', nm_usuario_p, nr_seq_dialise_p, null, null, null, 'AID');
	 
	-- Chamar a geração de lotes, pois foi retirado da proc aprazar_itens_dependentes (após cursor c06) 
	if (coalesce(nr_seq_classif_param_w ,0) > 0)	then 
		begin 
								 
		update	prescr_mat_hor 
		set		nr_seq_classif	= nr_seq_classif_param_w 
		where	nr_prescricao	= nr_prescricao_p 
		and		nr_sequencia	= nr_seq_hor_w;
		 
		end;
	else	 
	 
		open c01;
		loop 
		fetch c01 into	 
			nr_seq_classif_w, 
			ie_classif_urgente_w, 
			ie_controlado_w, 
			ie_padronizado_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin 
					 
			if (ie_controlado_w = 'A') and (ie_padronizado_w = 'A') then 
				update	prescr_mat_hor 
				set	nr_seq_classif		= nr_seq_classif_w 
				where	nr_prescricao		= nr_prescricao_p 
				and	ie_classif_urgente	= ie_classif_urgente_w 
				and	nr_sequencia	= nr_seq_hor_w;
			elsif (ie_controlado_w = 'A') and (ie_padronizado_w = 'S') then 
				update	prescr_mat_hor 
				set	nr_seq_classif		= nr_seq_classif_w 
				where	nr_prescricao		= nr_prescricao_p 
				and	ie_padronizado		= 'S' 
				and	ie_classif_urgente	= ie_classif_urgente_w 
				and	nr_sequencia	= nr_seq_hor_w;				
			elsif (ie_controlado_w = 'A') and (ie_padronizado_w = 'N') then 
				update	prescr_mat_hor 
				set	nr_seq_classif		= nr_seq_classif_w 
				where	nr_prescricao		= nr_prescricao_p 
				and	ie_padronizado		= 'N' 
				and	ie_classif_urgente	= ie_classif_urgente_w 
				and	nr_sequencia	= nr_seq_hor_w;				
			elsif (ie_controlado_w = 'N') and (ie_padronizado_w = 'A') then 
				update	prescr_mat_hor 
				set	nr_seq_classif		= nr_seq_classif_w 
				where	nr_prescricao		= nr_prescricao_p 
				and	ie_controlado		= 'N' 
				and	ie_classif_urgente	= ie_classif_urgente_w 
				and	nr_sequencia	= nr_seq_hor_w;				
			elsif (ie_controlado_w = 'N') and (ie_padronizado_w = 'N') then 
				update	prescr_mat_hor 
				set	nr_seq_classif		= nr_seq_classif_w 
				where	nr_prescricao		= nr_prescricao_p 
				and	ie_controlado		= 'N' 
				and	ie_padronizado		= 'N' 
				and	ie_classif_urgente	= ie_classif_urgente_w 
				and	nr_sequencia	= nr_seq_hor_w;				
			elsif (ie_controlado_w = 'N') and (ie_padronizado_w = 'S') then 
				update	prescr_mat_hor 
				set	nr_seq_classif		= nr_seq_classif_w 
				where	nr_prescricao		= nr_prescricao_p 
				and	ie_controlado		= 'N' 
				and	ie_padronizado		= 'S' 
				and	ie_classif_urgente	= ie_classif_urgente_w 
				and	nr_sequencia	= nr_seq_hor_w;				
			elsif (ie_controlado_w = 'S') and (ie_padronizado_w = 'A') then 
				update	prescr_mat_hor 
				set	nr_seq_classif		= nr_seq_classif_w 
				where	nr_prescricao		= nr_prescricao_p 
				and	ie_controlado		= 'S' 
				and	ie_classif_urgente	= ie_classif_urgente_w 
				and	nr_sequencia	= nr_seq_hor_w;				
			elsif (ie_controlado_w = 'S') and (ie_padronizado_w = 'N') then 
				update	prescr_mat_hor 
				set	nr_seq_classif		= nr_seq_classif_w 
				where	nr_prescricao		= nr_prescricao_p 
				and	ie_controlado		= 'S' 
				and	ie_padronizado		= 'N' 
				and	ie_classif_urgente	= ie_classif_urgente_w 
				and	nr_sequencia	= nr_seq_hor_w;				
			elsif (ie_controlado_w = 'S') and (ie_padronizado_w = 'S') then 
				update	prescr_mat_hor 
				set	nr_seq_classif		= nr_seq_classif_w 
				where	nr_prescricao		= nr_prescricao_p 
				and	ie_controlado		= 'S' 
				and	ie_padronizado		= 'S' 
				and	ie_classif_urgente	= ie_classif_urgente_w 
				and	nr_sequencia	= nr_seq_hor_w;				
			end if;
		 
			end;
		end loop;
		close c01;
	 
	end if;
 
	--Estava sendo chamado na aprazar_itens_dependentes	 
	CALL Gerar_Lote_Atend_Prescricao(nr_prescricao_p, 0, 0, 'S', nm_usuario_p, 'AIP');	
		 
	commit;
 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aprazar_item_dialise (nr_prescricao_p bigint, nr_seq_material_p bigint, nr_seq_dialise_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

