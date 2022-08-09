-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_setor_prescricao ( nr_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_setor_anterior_p bigint, nm_usuario_p text) AS $body$
DECLARE

		
nr_prescricao_w			bigint;
ie_ajusta_proc_lote_w		varchar(1);
ie_transf_prescr_w			varchar(1);
ie_transf_prescr_fim_cir_w 		varchar(1);
cd_estabelecimento_w		smallint;
cd_estab_prescr_w			smallint;
ie_gedipa_atual_w			varchar(1);
ie_gedipa_anterior_w		varchar(1);
ds_classif_setores_w		varchar(100);
ds_classif_setor_entra_w		varchar(100);
ds_setores_w               		varchar(100);
ie_rn_mae_w			varchar(1);
nr_atendimento_w			bigint;
ie_atualiza_estab_w		varchar(1);
nr_seq_procedimento_w		integer;
nr_seq_exame_w			bigint;
cd_setor_atual_usuario_w		integer;
cd_setor_procedimento_w		integer;
cd_setor_regra_proc_w		integer;
nm_usuario_proc_w			varchar(15);
cd_material_exame_w		varchar(20);
cd_setor_atend_w			varchar(255);
cd_setor_col_w			varchar(255);
cd_setor_entrega_w		varchar(255):= null;
qt_dia_entrega_w			numeric(20);
ie_emite_mapa_w			varchar(255);
ds_hora_fixa_w			varchar(255);
ie_data_resultado_w		varchar(255);
qt_min_entrega_w			bigint;
ie_atualizar_recoleta_w		varchar(255);
ie_urgencia_w			varchar(1);
ie_dia_semana_final_w 		bigint;
ie_forma_atual_dt_result_w		exame_lab_regra_setor.ie_atul_data_result%type;
qt_min_atraso_w		    	bigint;
cd_funcao_ativa_w			varchar(5);

ds_log_w				varchar(2000);


c01 CURSOR FOR
SELECT	a.nr_prescricao,
		a.cd_estabelecimento
from	prescr_medica a
where	a.nr_atendimento	= nr_atendimento_p
and		coalesce(a.dt_baixa::text, '') = ''
and		obter_se_contido(obter_classif_setor(a.cd_setor_atendimento),ds_classif_setores_w) = 'N'
and		obter_se_contido(obter_classif_setor(a.cd_setor_atendimento),ds_classif_setor_entra_w) = 'S'
and		obter_se_contido(a.cd_setor_atendimento,ds_setores_w) = 'N'
and		((CASE WHEN cd_funcao_ativa_w='900' THEN ie_transf_prescr_fim_cir_w WHEN cd_funcao_ativa_w='872' THEN ie_transf_prescr_fim_cir_w  ELSE ie_transf_prescr_w END  not in ('V','I')) or (a.dt_validade_prescr	> clock_timestamp()))
and		((not exists (	SELECT	1
								from	prescr_material b
								where	a.nr_prescricao	= b.nr_prescricao)) or ((CASE WHEN cd_funcao_ativa_w='900' THEN ie_transf_prescr_fim_cir_w WHEN cd_funcao_ativa_w='872' THEN ie_transf_prescr_fim_cir_w  ELSE ie_transf_prescr_w END  in ('T','I')) or (exists (		select	1
																																										from	prescr_material b
																																										where	a.nr_prescricao	= b.nr_prescricao
																																										and		b.cd_motivo_baixa	= 0))))
and		not exists (select	1
							from	cirurgia x
							where	x.nr_prescricao = a.nr_prescricao)
and	coalesce(ie_prescr_emergencia, 'N') <> 'S';

c02 CURSOR FOR
SELECT	nr_atendimento
from	atendimento_paciente
where	nr_atendimento_mae	= nr_atendimento_p;

c03 CURSOR FOR
SELECT	nr_sequencia,
	nr_seq_exame,
	coalesce(nm_usuario_nrec,nm_usuario),
	cd_material_exame,
	coalesce(ie_urgencia,'N'),
	cd_setor_atendimento
from	prescr_procedimento
where	nr_prescricao	= nr_prescricao_w
and	(nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '');
		

BEGIN
cd_funcao_ativa_w := to_char(wheb_usuario_pck.get_cd_funcao);

select	coalesce(max(cd_estabelecimento),0)
into STRICT	cd_estabelecimento_w
from	atendimento_paciente
where	nr_atendimento	=	nr_atendimento_p;

ie_transf_prescr_w := Obter_Param_Usuario(3111, 46, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_transf_prescr_w);
ie_transf_prescr_fim_cir_w := Obter_Param_Usuario(900, 552, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_transf_prescr_fim_cir_w);
ie_ajusta_proc_lote_w := Obter_Param_Usuario(3111, 73, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_ajusta_proc_lote_w);
ds_classif_setor_entra_w := Obter_Param_Usuario(3111, 90, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ds_classif_setor_entra_w);
ds_classif_setores_w := Obter_Param_Usuario(3111, 145, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ds_classif_setores_w);
ds_setores_w := Obter_Param_Usuario(3111, 217, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ds_setores_w);

select	coalesce(max(ie_processo_gedipa),'N')
into STRICT	ie_gedipa_atual_w
from	setor_atendimento
where	cd_setor_atendimento = cd_setor_atendimento_p;

select	coalesce(max(ie_processo_gedipa),'N'),
		coalesce(max(ie_rn_mae),'N')
into STRICT	ie_gedipa_anterior_w,
		ie_rn_mae_w
from	setor_atendimento
where	cd_setor_atendimento = cd_setor_anterior_p;

ds_log_w	:= substr('nr_atendimento_p='||nr_atendimento_p||';cd_setor_atendimento_p='||cd_setor_atendimento_p||';cd_setor_anterior_p='||cd_setor_anterior_p||';nm_usuario_p='||nm_usuario_p||
				';obter_perfil_ativo='||obter_perfil_ativo||';Obter_Funcao_Ativa='||cd_funcao_ativa_w||';ie_gedipa_atual_w='||ie_gedipa_atual_w||';cd_estabelecimento_w='||cd_estabelecimento_w||
				';ie_gedipa_anterior_w='||ie_gedipa_anterior_w||';ie_rn_mae_w='||ie_rn_mae_w||';ie_transf_prescr_w='||ie_transf_prescr_w||';ie_transf_prescr_fim_cir_w='||ie_transf_prescr_fim_cir_w||
				';ie_ajusta_proc_lote_w='||ie_ajusta_proc_lote_w||';ds_classif_setor_entra_w='||ds_classif_setor_entra_w||';ds_classif_setores_w='||ds_classif_setores_w||';ds_setores_w='||ds_setores_w,1,2000);
		
CALL gravar_log_tasy(4582, ds_log_w, nm_usuario_p);

ds_log_w	:= null;

open c01;
loop
fetch c01 into
	nr_prescricao_w,
	cd_estab_prescr_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	ds_log_w	:= substr(ds_log_w || ' Prescr='||nr_prescricao_w||';Est='||cd_estab_prescr_w||';',1,2000);
	
	ie_atualiza_estab_w	:= 'N';
	
	begin
						
		if	(ie_gedipa_anterior_w = 'S' AND ie_gedipa_atual_w = 'N') then
			update	ap_lote
			set	cd_setor_atendimento	= cd_setor_atendimento_p
			where	ie_status_lote 		= 'G'
			and	dt_atend_lote > clock_timestamp()
			and	nr_prescricao = nr_prescricao_w
			and coalesce(ie_agrupamento,'N') = 'N';
		else
			update	ap_lote
			set	cd_setor_atendimento	= cd_setor_atendimento_p
			where	ie_status_lote 		= 'G'
			and	nr_prescricao = nr_prescricao_w
			and coalesce(ie_agrupamento,'N') = 'N';
		end if;
		
		if (cd_estabelecimento_w	> 0) and (cd_estab_prescr_w		<> cd_estabelecimento_w) then
			cd_estab_prescr_w	:= cd_estabelecimento_w;
			ie_atualiza_estab_w	:= 'S';
		end if;	
		
	exception when others then
		ds_log_w	:= 'Erro1='||substr(sqlerrm,1,1800)||';nr_prescricao_w='||nr_prescricao_w;
	end;
	
	
	begin	
	
		update	prescr_medica
		set		cd_setor_atendimento	= cd_setor_atendimento_p,
				cd_estabelecimento		= cd_estab_prescr_w
		where	nr_prescricao			= nr_prescricao_w;

        if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
		
	exception when others then
		ds_log_w	:= 'Erro2='||substr(sqlerrm,1,1800)||';nr_prescricao_w='||nr_prescricao_w;
	end;
	
	begin
	
	
		if (ie_atualiza_estab_w	= 'S') then
			
			open C03;
			loop
			fetch C03 into	
				nr_seq_procedimento_w,
				nr_seq_exame_w,
				nm_usuario_proc_w,
				cd_material_exame_w,
				ie_urgencia_w,
				cd_setor_procedimento_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin
				
				cd_setor_atual_usuario_w	:= obter_setor_usuario(nm_usuario_proc_w);
				
				SELECT * FROM obter_setor_exame_lab(	nr_prescricao_w, nr_seq_exame_w, cd_setor_atual_usuario_w, cd_material_exame_w, null, 'N', cd_setor_atend_w, cd_setor_col_w, cd_setor_entrega_w, qt_dia_entrega_w, ie_emite_mapa_w, ds_hora_fixa_w, ie_data_resultado_w, qt_min_entrega_w, ie_atualizar_recoleta_w, ie_urgencia_w, ie_dia_semana_final_w, ie_forma_atual_dt_result_w, qt_min_atraso_w) INTO STRICT cd_setor_atend_w, cd_setor_col_w, cd_setor_entrega_w, qt_dia_entrega_w, ie_emite_mapa_w, ds_hora_fixa_w, ie_data_resultado_w, qt_min_entrega_w, ie_atualizar_recoleta_w, ie_dia_semana_final_w, ie_forma_atual_dt_result_w, qt_min_atraso_w;
				
				if (cd_setor_atend_w IS NOT NULL AND cd_setor_atend_w::text <> '') and (somente_numero(cd_setor_atend_w) > 0) then 
					cd_setor_regra_proc_w	:= gerar_setor_exame_lab(cd_setor_atend_w);
				end if;

				if (cd_setor_regra_proc_w <> cd_setor_procedimento_w) then
					
					update	prescr_procedimento
					set	cd_setor_atendimento = cd_setor_regra_proc_w
					where	nr_prescricao = nr_prescricao_w
					and	nr_sequencia	= nr_seq_procedimento_w;
					
				end if;				

				end;
			end loop;
			close C03;
			
		end if;
		
	exception when others then
		ds_log_w	:= 'Erro3='||substr(sqlerrm,1,1800)||';nr_prescricao_w='||nr_prescricao_w;
	end;
		
	begin
	
		if (ie_ajusta_proc_lote_w <> 'N') then
			CALL define_local_disp_prescr(nr_prescricao_w, null, obter_perfil_ativo, nm_usuario_p );
			CALL gedipa_atual_prescr_transf_pac(nr_atendimento_p, nr_prescricao_w, cd_setor_anterior_p, cd_setor_atendimento_p, nm_usuario_p);
		end if;
		
	exception when others then
		ds_log_w	:= 'Erro4='||substr(sqlerrm,1,1800)||';nr_prescricao_w='||nr_prescricao_w;
	end;
	
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
	
	end;
end loop;
close c01;

begin
	CALL cpoe_atualizar_setor_tranf(nr_atendimento_p, cd_setor_atendimento_p, nm_usuario_p, cd_estabelecimento_w,cd_setor_anterior_p);
exception when others then
	ds_log_w	:= 'Erro5='||substr(sqlerrm,1,1800)||';nr_prescricao_w='||nr_prescricao_w;
end;

CALL gravar_log_tasy(4583, substr(ds_log_w,1,2000), nm_usuario_p);

CALL swisslog_movimentacao_pac(nr_atendimento_p, cd_setor_atendimento_p, cd_setor_anterior_p, 4, nm_usuario_p);

/* Rotina para integracao padrao */

CALL intpd_lote_movimentacao_pac(nr_atendimento_p, cd_setor_atendimento_p, cd_setor_anterior_p, 4, nm_usuario_p);

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

if (ie_rn_mae_w	= 'S') then

	open C02;
	loop
	fetch C02 into	
		nr_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		CALL Atualizar_setor_prescricao(nr_atendimento_w,cd_setor_atendimento_p,cd_setor_anterior_p,nm_usuario_p);

		end;
	end loop;
	close C02;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_setor_prescricao ( nr_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_setor_anterior_p bigint, nm_usuario_p text) FROM PUBLIC;
