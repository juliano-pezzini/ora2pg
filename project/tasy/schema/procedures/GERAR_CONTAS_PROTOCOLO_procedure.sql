-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_contas_protocolo (nr_seq_protocolo_p bigint, cd_convenio_p bigint, cd_estabelecimento_p bigint, ie_tipo_atendimento_p text, ie_tipo_atend_bpa_p bigint, cd_setor_atendimento_p bigint, cd_classif_setor_p bigint, ie_internado_p bigint, cd_especialidade_p bigint, cd_procedencia_p bigint, nr_seq_etapa_p bigint, cd_plano_p text, ie_retorno_p text, nm_usuario_p text, cd_medico_atend_p text, cd_setor_paciente_p bigint, nr_seq_classificacao_p bigint, ie_ultrapassou_limite_p INOUT text) AS $body$
DECLARE



nr_protocolo_w		varchar(40);
dt_mesano_ref_par_w	timestamp;
dt_periodo_inicial_w	timestamp;
dt_periodo_final_w		timestamp;
nr_interno_conta_w		bigint;
nr_atendimento_w		bigint;
ie_atualiza_w		varchar(01)	:= 'S';
ie_tipo_convenio_w		smallint;
ie_tipo_protocolo_w		smallint;
ie_tipo_atend_w		smallint;
cd_categoria_w		varchar(10);
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
qt_contas_w		bigint 	:= 0;
qt_conta_protocolo_w	integer	:= 0;
nr_seq_protocolo_w	bigint;
nr_seq_protocolo_ww	bigint;
qt_protocolo_w		bigint	:= 1;
ie_gerar_contas_prot_w	varchar(1);
nr_protocolo_ww		varchar(40);
sql_errm_w		varchar(2000);
qt_guias_w		bigint	:= 0;
qt_guias_atual_w	bigint	:= 0;
qt_guias_protocolo_w	bigint	:= 0;
ie_consiste_qt_guias_w	varchar(1);

ie_criacao_ok_w		varchar(1);


c01 CURSOR FOR
	SELECT	a.nr_atendimento,
		a.nr_interno_conta,
		b.ie_tipo_atendimento
	from	atendimento_paciente b,
		conta_paciente a
	where	a.nr_protocolo = '0'
	and	a.ie_status_acerto = 2
	and	a.nr_atendimento = b.nr_atendimento
	and	a.dt_periodo_inicial	between dt_periodo_inicial_w and dt_periodo_final_w
	and	a.cd_convenio_parametro = cd_convenio_p
	and	((coalesce(cd_categoria_w::text, '') = '') or (a.cd_categoria_parametro = cd_categoria_w))
	and	a.cd_estabelecimento = cd_estabelecimento_p;



BEGIN

ie_gerar_contas_prot_w	:= coalesce(Obter_Valor_Param_Usuario(85,169, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento),'N');
ie_consiste_qt_guias_w	:= coalesce(Obter_Valor_Param_Usuario(85,158, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento),'N');
nr_seq_protocolo_w		:= nr_seq_protocolo_p;

select	max(nr_protocolo)
into STRICT	nr_protocolo_ww
from	protocolo_convenio
where	nr_seq_protocolo	= nr_seq_protocolo_w;

ie_ultrapassou_limite_p	:= 'N';	

select	nr_protocolo,
	dt_mesano_ref_par,
	dt_periodo_inicial,
	dt_periodo_final,
	ie_tipo_protocolo,
	cd_categoria,
	cd_procedimento,
	ie_origem_proced
into STRICT	nr_protocolo_w,
	dt_mesano_ref_par_w,
	dt_periodo_inicial_w,
	dt_periodo_final_w,
	ie_tipo_protocolo_w,
	cd_categoria_w,
	cd_procedimento_w,
	ie_origem_proced_w
from	protocolo_convenio
where	nr_seq_protocolo	= nr_seq_protocolo_w;

select	ie_tipo_convenio
into STRICT	ie_tipo_convenio_w
from	convenio
where	cd_convenio		= cd_convenio_p;

select	coalesce(max(qt_conta_protocolo),99999)
into STRICT	qt_conta_protocolo_w
from	convenio_estabelecimento
where	cd_convenio 		= cd_convenio_p
and	cd_estabelecimento 	= cd_estabelecimento_p;

select	coalesce(max(qt_guias_protocolo),0)
into STRICT	qt_guias_protocolo_w
from	tiss_parametros_convenio
where	cd_convenio = cd_convenio_p
and	cd_estabelecimento = cd_estabelecimento_p;

open	c01;
loop
fetch	c01 into
	nr_atendimento_w,
	nr_interno_conta_w,
	ie_tipo_atend_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	
	ie_atualiza_w	:= 'S';

	if	((coalesce(ie_tipo_atendimento_p::text, '') = '') or (ie_tipo_atendimento_p <> ' ') or (ie_tipo_atendimento_p <> '')) and (ie_tipo_atendimento_p <> '1,7,3,8,0') and (ie_tipo_atendimento_p <> '0,0,0,0,0') and (position(ie_tipo_atend_w in ie_tipo_atendimento_p) = 0) then
		ie_atualiza_w	:= 'N';
	end if;

	if (coalesce(obter_conta_paciente_etapa(nr_interno_conta_w,'P'),'S') = 'N')  and (ie_atualiza_w = 'S') then
		ie_atualiza_w	:= 'N';
	end if;

	if (ie_tipo_atend_bpa_p IS NOT NULL AND ie_tipo_atend_bpa_p::text <> '') and (ie_atualiza_w = 'S') then
		select	coalesce(max('S'), 'N')
		into STRICT	ie_atualiza_w
		from 	atendimento_paciente k
		where 	k.nr_atendimento 	= nr_atendimento_w
		and 	k.ie_tipo_atend_bpa 	= ie_tipo_atend_bpa_p;
	end if;

	if (cd_plano_p IS NOT NULL AND cd_plano_p::text <> '') and (ie_atualiza_w = 'S') then
		select	coalesce(max('S'), 'N')
		into STRICT	ie_atualiza_w
		from 	atend_categoria_convenio c,
			atendimento_paciente k 
		where 	k.nr_atendimento 	= nr_atendimento_w
		and	k.nr_atendimento	= c.nr_atendimento
		and 	c.cd_plano_convenio	= cd_plano_p;
	end if;
	
	if (nr_seq_etapa_p IS NOT NULL AND nr_seq_etapa_p::text <> '') and (ie_atualiza_w = 'S') then
		select	coalesce(max('S'), 'N')
		into STRICT	ie_atualiza_w
		from 	conta_paciente
		where 	nr_interno_conta	= nr_interno_conta_w
		and 	somente_numero(coalesce(obter_conta_paciente_etapa(nr_interno_conta,'C'),0)) = nr_seq_etapa_p;
	end if;	
	
	
	if (cd_procedencia_p IS NOT NULL AND cd_procedencia_p::text <> '') and (ie_atualiza_w = 'S') then
		select	coalesce(max('S'), 'N')
		into STRICT	ie_atualiza_w
		from 	atendimento_paciente
		where 	nr_atendimento 	= nr_atendimento_w
		and	cd_procedencia	= cd_procedencia_p;
	end if;

	if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') and (ie_atualiza_w = 'S') then
		select	coalesce(max('S'), 'N')
		into STRICT	ie_atualiza_w
		from 	valores_atend_paciente_v k
		where 	k.nr_interno_conta	= nr_interno_conta_w
		and 	k.cd_setor_atendimento 	= cd_setor_atendimento_p
		and 	k.quantidade 		<> 0
		and	coalesce(k.cd_motivo_exc_conta::text, '') = '';
	end if;
	if (cd_setor_paciente_p IS NOT NULL AND cd_setor_paciente_p::text <> '') and (ie_atualiza_w = 'S') then
		select	coalesce(max('S'),'N')
		into STRICT	ie_atualiza_w
		from	atend_paciente_unidade
		where	nr_atendimento = nr_atendimento_w
		and	cd_setor_atendimento = cd_setor_paciente_p;
	end if;
	if (nr_seq_classificacao_p IS NOT NULL AND nr_seq_classificacao_p::text <> '') and (ie_atualiza_w = 'S') then
		select	coalesce(max('S'),'N')
		into STRICT	ie_atualiza_w
		from	atendimento_paciente
		where	nr_atendimento = nr_atendimento_w
		and	nr_seq_classificacao = nr_seq_classificacao_p;
	end if;
	if (cd_classif_setor_p IS NOT NULL AND cd_classif_setor_p::text <> '') and (ie_atualiza_w = 'S') then
		select	coalesce(max('S'), 'N')
		into STRICT	ie_atualiza_w
		from 	setor_atendimento z, valores_atend_paciente_v k
		where 	k.cd_setor_atendimento	= z.cd_setor_atendimento
		and	k.nr_interno_conta	= nr_interno_conta_w
		and 	z.cd_classif_setor	= cd_classif_setor_p
		and 	k.quantidade 		<> 0
		and	coalesce(k.cd_motivo_exc_conta::text, '') = '';
	end if;

	if (cd_especialidade_p IS NOT NULL AND cd_especialidade_p::text <> '') and (ie_atualiza_w = 'S') then
		select	coalesce(max('S'), 'N')
		into STRICT	ie_atualiza_w
		from 	grupo_proc f,
			procedimento e,
			procedimento_paciente d	
		where 	d.nr_interno_conta 	= nr_interno_conta_w
		and 	d.cd_procedimento 	= e.cd_procedimento
		and 	d.ie_origem_proced 	= e.ie_origem_proced
		and 	e.cd_grupo_proc 	= f.cd_grupo_proc
		and 	f.cd_especialidade 	= cd_especialidade_p;
	end if;	


	if (ie_internado_p	= 1) and (ie_atualiza_w = 'S') then
		select	coalesce(max('S'), 'N')
		into STRICT	ie_atualiza_w
		from 	setor_atendimento s,
			valores_atend_paciente_v y
		where 	s.cd_setor_atendimento	= y.cd_setor_atendimento
		and 	s.cd_classif_setor 	in (3,4,8)
		and 	y.nr_interno_conta 	= nr_interno_conta_w
		and 	y.quantidade 		<> 0
		and 	coalesce(y.cd_motivo_exc_conta::text, '') = '';
	elsif (ie_internado_p	= 2) and (ie_atualiza_w = 'S') then
		select	coalesce(max('N'), 'S')
		into STRICT	ie_atualiza_w
		from 	setor_atendimento s,
			valores_atend_paciente_v y
		where 	s.cd_setor_atendimento	= y.cd_setor_atendimento
		and 	s.cd_classif_setor 	in (3,4,8)
		and 	y.nr_interno_conta 	= nr_interno_conta_w
		and 	y.quantidade 		<> 0
		and 	coalesce(y.cd_motivo_exc_conta::text, '') = '';
	end if;

	
	if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (ie_atualiza_w = 'S') then
		select	coalesce(max('S'), 'N')
		into STRICT	ie_atualiza_w
		from 	atendimento_paciente_v a
		where 	a.nr_atendimento 	= nr_atendimento_w
		and	a.cd_proc_principal	= cd_procedimento_w;
	end if;
	
	

	if (ie_retorno_p	= 'S') and (ie_atualiza_w = 'S') then
		select	coalesce(max('S'), 'N')
		into STRICT	ie_atualiza_w
		from	atendimento_paciente
		where	nr_atendimento		= nr_atendimento_w
		and	(nr_atend_original IS NOT NULL AND nr_atend_original::text <> '');
	end if;		

	if (ie_tipo_convenio_w 	= 3) and (ie_tipo_protocolo_w 	= 1) and (ie_atualiza_w = 'S') then
		select	coalesce(max('S'), 'N')
		into STRICT	ie_atualiza_w
		from	sus_aih
		where	nr_atendimento	= nr_atendimento_w;
	end if;
	
	if (cd_medico_atend_p IS NOT NULL AND cd_medico_atend_p::text <> '') and (ie_atualiza_w = 'S') then
		select	coalesce(max('S'), 'N')
		into STRICT	ie_atualiza_w
		from	atendimento_paciente
		where	nr_atendimento		= nr_atendimento_w
		and	cd_medico_resp		= cd_medico_atend_p;
	end if;
	
	if (ie_atualiza_w = 'S') then
		qt_contas_w	:= qt_contas_w + 1;
		
		if (ie_consiste_qt_guias_w = 'T') and (qt_guias_protocolo_w > 0) then
		
			select	count(*)
			into STRICT	qt_guias_atual_w
			from	tiss_conta_guia
			where	nr_interno_conta = nr_interno_conta_w;
			
			qt_guias_w	:= qt_guias_w + qt_guias_atual_w;
		
		end if;
		
		if (qt_contas_w <= qt_conta_protocolo_w) and (qt_guias_w <= qt_guias_protocolo_w) then
			update	conta_paciente
			set	nr_protocolo		= nr_protocolo_w,
				nr_seq_protocolo	= nr_seq_protocolo_w,
				dt_mesano_referencia	= CASE WHEN dt_mesano_ref_par_w = NULL THEN  null  ELSE dt_mesano_ref_par_w END ,
				nm_usuario		= nm_usuario_p
			where	nr_interno_conta	= nr_interno_conta_w;
		end if;
		
		if	(ie_gerar_contas_prot_w = 'S' AND qt_contas_w > qt_conta_protocolo_w) or
			((ie_gerar_contas_prot_w = 'T') and ((qt_contas_w > qt_conta_protocolo_w) or (qt_guias_w > qt_guias_protocolo_w))) then
			
			select	nextval('protocolo_convenio_seq')
			into STRICT	nr_seq_protocolo_ww
			;
			
			qt_contas_w	:= 1;
			qt_guias_w	:= qt_guias_atual_w;
			ie_criacao_ok_w	:= 'S';
			
			begin
			insert into protocolo_convenio(
					cd_ans,
					cd_categoria,             
					cd_classif_setor,         
					cd_convenio,              
					cd_especialidade,         
					cd_estabelecimento,       
					cd_interface_envio,       
					cd_plano,                 
					cd_prestador_convenio,    
					cd_prestador_convenio_ri, 
					cd_procedencia,           
					cd_procedimento,          
					cd_setor_atendimento,     
					ds_arquivo_envio,         
					ds_arquivo_retorno,       
					ds_inconsistencia,        
					ds_observacao,            
					ds_parametro_atend,       
					dt_atualizacao,           
					dt_consistencia,          
					dt_controle_proc_sus,     
					dt_definitivo,            
					dt_entrega_convenio,      
					dt_envio,                 
					dt_geracao,               
					dt_integracao_cr,         
					dt_mesano_referencia,     
					dt_mesano_ref_par,        
					dt_periodo_final,         
					dt_periodo_inicial,       
					dt_retorno,               
					dt_vencimento,            
					ie_complexidade_sus,      
					ie_credenciamento_sus,    
					ie_origem_proced,         
					ie_periodo_final,         
					ie_receb_financeiro,      
					ie_status_protocolo,      
					ie_tipo_atend_bpa,        
					ie_tipo_bpa,              
					ie_tipo_financ_sus,       
					ie_tipo_protocolo,        
					nm_usuario,               
					nm_usuario_envio,         
					nm_usuario_geracao,       
					nm_usuario_retorno,       
					nr_protocolo,             
					nr_protocolo_cons,        
					nr_protocolo_honor,       
					nr_protocolo_ri,          
					nr_protocolo_spsadt,      
					nr_seq_doc_convenio,      
					nr_seq_envio_convenio,    
					nr_seq_etapa,             
					nr_seq_int_envio,         
					nr_seq_int_envio_inicial, 
					nr_seq_lote_grat,         
					nr_seq_lote_protocolo,    
					nr_seq_lote_receita,      
					nr_seq_lote_repasse,      
					nr_seq_pq_protocolo,      
					nr_seq_protocolo,         
					vl_recebimento)  
				(SELECT
					cd_ans,                   
					cd_categoria,             
					cd_classif_setor,         
					cd_convenio,              
					cd_especialidade,         
					cd_estabelecimento,       
					cd_interface_envio,       
					cd_plano,                 
					cd_prestador_convenio,    
					cd_prestador_convenio_ri, 
					cd_procedencia,           
					cd_procedimento,          
					cd_setor_atendimento,     
					ds_arquivo_envio,         
					ds_arquivo_retorno,       
					ds_inconsistencia,        
					ds_observacao,            
					ds_parametro_atend,       
					dt_atualizacao,           
					dt_consistencia,          
					dt_controle_proc_sus,     
					dt_definitivo,            
					dt_entrega_convenio,      
					dt_envio,                 
					dt_geracao,               
					dt_integracao_cr,         
					dt_mesano_referencia,     
					dt_mesano_ref_par,        
					dt_periodo_final,         
					dt_periodo_inicial,       
					dt_retorno,               
					dt_vencimento,            
					ie_complexidade_sus,      
					ie_credenciamento_sus,    
					ie_origem_proced,         
					ie_periodo_final,         
					ie_receb_financeiro,      
					ie_status_protocolo,      
					ie_tipo_atend_bpa,        
					ie_tipo_bpa,              
					ie_tipo_financ_sus,       
					ie_tipo_protocolo,        
					nm_usuario_p,               
					nm_usuario_envio,         
					nm_usuario_geracao,       
					nm_usuario_retorno,       
					nr_protocolo_ww || '_' || qt_protocolo_w,             
					nr_protocolo_cons,        
					nr_protocolo_honor,       
					nr_protocolo_ri,          
					nr_protocolo_spsadt,      
					nr_seq_doc_convenio,      
					nr_seq_envio_convenio,    
					nr_seq_etapa,             
					nr_seq_int_envio,         
					nr_seq_int_envio_inicial, 
					nr_seq_lote_grat,         
					nr_seq_lote_protocolo,    
					nr_seq_lote_receita,      
					nr_seq_lote_repasse,      
					nr_seq_pq_protocolo,      
					nr_seq_protocolo_ww,         
					vl_recebimento
				from	protocolo_convenio
				where	nr_seq_protocolo = nr_seq_protocolo_w);	
			exception
				when others then
				ie_criacao_ok_w		:= 'N';				
			end;
				
			commit;
			
			nr_protocolo_w		:= nr_protocolo_ww || '_' || qt_protocolo_w;
			nr_seq_protocolo_w	:= nr_seq_protocolo_ww;
			qt_protocolo_w		:= qt_protocolo_w + 1;
			
			if (ie_criacao_ok_w = 'S') then
							
				update	conta_paciente
				set	nr_protocolo		= nr_protocolo_w,
					nr_seq_protocolo	= nr_seq_protocolo_w,
					dt_mesano_referencia	= CASE WHEN dt_mesano_ref_par_w = NULL THEN  null  ELSE dt_mesano_ref_par_w END ,
					nm_usuario		= nm_usuario_p
				where	nr_interno_conta	= nr_interno_conta_w;	
				
			end if;
		end if;		
		
	end if;	

	end;
end loop;
close c01;

if (qt_contas_w > qt_conta_protocolo_w) then
	ie_ultrapassou_limite_p	:= 'S';
elsif (qt_guias_w > qt_guias_protocolo_w) then
	ie_ultrapassou_limite_p	:= 'G';
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_contas_protocolo (nr_seq_protocolo_p bigint, cd_convenio_p bigint, cd_estabelecimento_p bigint, ie_tipo_atendimento_p text, ie_tipo_atend_bpa_p bigint, cd_setor_atendimento_p bigint, cd_classif_setor_p bigint, ie_internado_p bigint, cd_especialidade_p bigint, cd_procedencia_p bigint, nr_seq_etapa_p bigint, cd_plano_p text, ie_retorno_p text, nm_usuario_p text, cd_medico_atend_p text, cd_setor_paciente_p bigint, nr_seq_classificacao_p bigint, ie_ultrapassou_limite_p INOUT text) FROM PUBLIC;

