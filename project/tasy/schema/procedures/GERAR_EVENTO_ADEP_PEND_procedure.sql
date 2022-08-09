-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evento_adep_pend ( nr_prescricao_p bigint, nr_seq_item_p bigint, ie_alteracao_p bigint, ds_justificativa_p text, ie_tipo_item_p text, nr_atendimento_p bigint, cd_item_p bigint, nm_usuario_p text, nr_seq_motivo_susp_p bigint, ie_acm_sn_p text, nr_seq_horario_p bigint default 0) AS $body$
DECLARE

				
nr_seq_alter_w		bigint;	
ds_motivo_susp_w	varchar(255);	
nr_seq_horario_w	prescr_mat_hor.nr_sequencia%type;
nr_seq_lote_w		prescr_mat_hor.nr_seq_lote%type;
dt_horario_w		prescr_mat_hor.dt_horario%type;		
nr_seq_proc_interno_w	prescr_procedimento.nr_seq_proc_interno%type;
nr_seq_proc_w		prescr_procedimento.nr_sequencia%type;
nr_seq_prot_glic_w	prescr_procedimento.nr_seq_prot_glic%type;
nr_seq_solucao_w	prescr_solucao_evento.nr_seq_solucao%type;
nr_seq_material_w	prescr_mat_hor.nr_seq_material%type;
cd_procedimento_w	prescr_procedimento.cd_procedimento%type;
ds_erro_w			varchar(2000);


BEGIN

begin

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (ie_tipo_item_p IS NOT NULL AND ie_tipo_item_p::text <> '') and (cd_item_p IS NOT NULL AND cd_item_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (ie_alteracao_p IS NOT NULL AND ie_alteracao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	
	select	substr(max(ds_motivo_susp),1,255)
	into STRICT	ds_motivo_susp_w
	from	prescr_medica
	where	nr_prescricao	= nr_prescricao_p;	
	
	if (nr_seq_horario_p > 0) then
		begin
		
		nr_seq_horario_w	:= nr_seq_horario_p;
		
		select	max(nr_seq_lote),
				max(dt_horario),				
				max(nr_seq_solucao),
				max(nr_seq_material)				
		into STRICT	nr_seq_lote_w,
				dt_horario_w,							
				nr_seq_solucao_w,
				nr_seq_material_w				
		from	prescr_mat_hor
		where	nr_sequencia = nr_seq_horario_p;
		
		end;
	end if;
	
	if (ie_tipo_item_p in ('M', 'IAH', 'IAG')) then
	
	
	    select	nextval('prescr_mat_alteracao_seq')
		into STRICT	nr_seq_alter_w
		;

	    insert into prescr_mat_alteracao(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_prescricao,
						nr_seq_prescricao,
						dt_alteracao,
						cd_pessoa_fisica,
						ie_alteracao,
						ds_justificativa,
						ie_tipo_item,
						nr_atendimento,
						cd_item,
						nr_seq_motivo_susp,
						ie_acm_sn,
						nr_seq_horario,
						nr_seq_lote,
						dt_horario
						)
		values (
						nr_seq_alter_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_prescricao_p,
						nr_seq_item_p,
						clock_timestamp(),
						obter_dados_usuario_opcao(nm_usuario_p,'C'),
						ie_alteracao_p,
						substr(coalesce(ds_justificativa_p, ds_motivo_susp_w),1,255),
						ie_tipo_item_p,
						nr_atendimento_p,
						cd_item_p,
						nr_seq_motivo_susp_p,
						ie_acm_sn_p,
						nr_seq_horario_w,
						nr_seq_lote_w,
						dt_horario_w
						);	
	elsif (ie_tipo_item_p in ('G')) then
	
		select	nextval('prescr_mat_alteracao_seq')
		into STRICT	nr_seq_alter_w
		;
	
		select	max(a.nr_seq_prot_glic),
				max(a.nr_sequencia),
				max(a.cd_procedimento),
				max(a.nr_seq_proc_interno)
		into STRICT	nr_seq_prot_glic_w,
				nr_seq_proc_w,
				cd_procedimento_w,
				nr_seq_proc_interno_w
		from	prescr_procedimento a,
				prescr_material b
		where	a.nr_prescricao = b.nr_prescricao
		and		b.nr_sequencia = nr_seq_material_w
		and		a.nr_prescricao = nr_prescricao_p;
		
	
		insert into prescr_mat_alteracao(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_prescricao,
						nr_seq_procedimento,
						dt_alteracao,
						cd_pessoa_fisica,
						ie_alteracao,
						ds_justificativa,
						ie_tipo_item,
						nr_atendimento,
						cd_item,
						nr_seq_motivo_susp,
						ie_acm_sn,
						nr_seq_horario,
						nr_seq_lote,
						dt_horario,
						nr_seq_proc_interno,
						nr_seq_prot_glic
						)
		values (
						nr_seq_alter_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_prescricao_p,
						nr_seq_proc_w,
						clock_timestamp(),
						obter_dados_usuario_opcao(nm_usuario_p,'C'),
						ie_alteracao_p,
						coalesce(ds_justificativa_p, ds_motivo_susp_w),
						ie_tipo_item_p,
						nr_atendimento_p,
						cd_procedimento_w,
						nr_seq_motivo_susp_p,
						ie_acm_sn_p,
						nr_seq_horario_w,
						nr_seq_lote_w,
						dt_horario_w,
						nr_seq_proc_interno_w,
						nr_seq_prot_glic_w
						);	
						
	else
	
		select	nextval('prescr_solucao_evento_seq')
		into STRICT	nr_seq_alter_w
		;
	
		insert  into prescr_solucao_evento(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_prescricao,
						nr_seq_solucao,
						ie_tipo_solucao,
						nr_atendimento,						
						cd_pessoa_fisica,
						ie_alteracao,
						dt_alteracao,
						ie_evento_valido,
						dt_horario)
				values (nr_seq_alter_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_prescricao_p,
						nr_seq_solucao_w,
						1,
						nr_atendimento_p,
						obter_dados_usuario_opcao(nm_usuario_p,'C'),
						ie_alteracao_p,
						clock_timestamp(),
						'N',
						dt_horario_w
						);
						
	end if;	
					
	
end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

exception when others then
	ds_erro_w	:= substr(sqlerrm,1,1800);
	CALL gravar_log_tasy(8963, 'nr_prescricao_p='||nr_prescricao_p||';nr_seq_horario_p='||nr_seq_horario_p||';Erro='||ds_erro_w, nm_usuario_p);
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evento_adep_pend ( nr_prescricao_p bigint, nr_seq_item_p bigint, ie_alteracao_p bigint, ds_justificativa_p text, ie_tipo_item_p text, nr_atendimento_p bigint, cd_item_p bigint, nm_usuario_p text, nr_seq_motivo_susp_p bigint, ie_acm_sn_p text, nr_seq_horario_p bigint default 0) FROM PUBLIC;
