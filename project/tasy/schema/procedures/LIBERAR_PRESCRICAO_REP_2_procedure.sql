-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_prescricao_rep_2 ( nr_prescricao_p bigint, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, ie_verifica_apresent_medic_p text, ds_lista_prescr_proc_p INOUT text, ds_interacao_p INOUT text, ie_prescr_lib_prev_p INOUT text, ds_mensagem_p INOUT text, ie_acao_p INOUT text, ie_anamnese_p INOUT text, ie_evolucao_p INOUT text, ie_estoque_p INOUT text, ie_recomendacao_p INOUT text, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_mat_hor_conflito_p INOUT text) AS $body$
DECLARE


ds_lista_prescr_proc_w	varchar(2000);
ds_interacao_w			varchar(4000);
ie_prescr_lib_prev_w	varchar(1);
ie_prescricao_alta_w	varchar(1);
ie_estoque_w			varchar(1);
ie_estoque_ww			varchar(1)	:=	'N';
ie_acao_w				varchar(10);
ie_anamnese_w			varchar(1);
ie_evolucao_w			varchar(1);
ie_diagnostico_w		varchar(1);
ie_consite_hor_dupl_w	varchar(10);
ie_escala_indice_w		varchar(10);
ie_receita_w			varchar(1);
ie_recomendacao_w		varchar(1);
ie_sis_w				varchar(1);
ie_parecer_w			varchar(1);
ie_aval_w				varchar(1);
ie_peso_w				varchar(1);
ds_mensagem_w			varchar(4000);
ds_mensagem_adic_w		varchar(4000);
--ds_internacao_w			varchar2(8000);
qt_material_w			bigint;
qt_procedimento_w		bigint;
cd_protocolo_w			bigint;
dt_prescricao_w			timestamp;
ie_autorizacao_w		varchar(1);
ie_item_prontuario_w	varchar(5);
ie_mat_hor_conflito_w   varchar(1);
ie_posicionar_pep_w		varchar(1);


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin

	CALL verificar_interacao_medic(nr_prescricao_p);

	ds_interacao_w	:= substr(obter_interacao_medic_prescr(nr_prescricao_p),1,4000);

	ds_lista_prescr_proc_w	:= obter_lista_pend_resposta(nr_prescricao_p);

	select	coalesce(max('S'),'N')
	into STRICT	ie_prescr_lib_prev_w
	from	prescr_medica
	where	nr_prescricao	= nr_prescricao_p
	and	(coalesce(dt_liberacao, dt_liberacao_medico) IS NOT NULL AND (coalesce(dt_liberacao, dt_liberacao_medico))::text <> '');

	select	dt_prescricao,
		ie_prescricao_alta
	into STRICT	dt_prescricao_w,
		ie_prescricao_alta_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;

	SELECT * FROM consiste_regra_inf_rep(
		wheb_usuario_pck.get_cd_estabelecimento, nr_atendimento_p, cd_setor_atendimento_p, wheb_usuario_pck.get_cd_perfil, 'L', ie_prescricao_alta_w, dt_prescricao_w, nm_usuario_p, ds_mensagem_w, ds_mensagem_adic_w, ie_acao_w, ie_anamnese_w, ie_evolucao_w, ie_receita_w, ie_diagnostico_w, ie_escala_indice_w, nr_prescricao_p, null, null, ie_recomendacao_w, cd_protocolo_w, ie_parecer_w, ie_peso_w, ie_autorizacao_w, ie_sis_w, ie_aval_w, ie_item_prontuario_w, ie_posicionar_pep_w) INTO STRICT ds_mensagem_w, ds_mensagem_adic_w, ie_acao_w, ie_anamnese_w, ie_evolucao_w, ie_receita_w, ie_diagnostico_w, ie_escala_indice_w, ie_recomendacao_w, cd_protocolo_w, ie_parecer_w, ie_peso_w, ie_autorizacao_w, ie_sis_w, ie_aval_w, ie_item_prontuario_w, ie_posicionar_pep_w;

	--ds_internacao_w	:=	substr(Obter_interacao_medic_prescr(nr_prescricao_p),1,8000);
	ie_estoque_w := obter_param_usuario(924, 128, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_estoque_w);

	if (coalesce(ie_estoque_w,'N') = 'S') then
		begin

		select	coalesce(count(*),0)
		into STRICT	qt_material_w
		from   	prescr_material
		where	nr_prescricao  = nr_prescricao_p;

		select 	coalesce(count(*),0)
		into STRICT	qt_procedimento_w
		from	prescr_procedimento
		where	nr_prescricao  = nr_prescricao_p;

		if (qt_material_w > 0) or (qt_procedimento_w > 0) then
			begin
			ie_estoque_ww	:=	'S';
			end;
		end if;

		end;
	end if;
	
	CALL liberar_prescricao_rep_3(nr_prescricao_p, cd_setor_atendimento_p, ie_verifica_apresent_medic_p, nm_usuario_p);

	ie_consite_hor_dupl_w := obter_param_usuario(924, 218, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_consite_hor_dupl_w);
	
	if (ie_consite_hor_dupl_w = 'S') then
		CALL Consistir_horarios_prescr(nr_prescricao_p);
	end if;

	select	coalesce(max('S'),'N')
	into STRICT	ie_mat_hor_conflito_w
	from	prescr_mat_hor_conflito
	where	nr_prescricao = nr_prescricao_p;

	end;
end if;
commit;
/*
ds_lista_prescr_proc_w	:= ds_lista_prescr_proc_p;
ds_interacao_w		:= ds_interacao_p;
ie_prescr_lib_prev_w	:= ie_prescr_lib_prev_p;
ds_mensagem_w		:= ds_mensagem_p;
ie_acao_w		:= ie_acao_p;
ie_anamnese_w		:= ie_anamnese_p;
ie_evolucao_w		:= ie_evolucao_p;
*/
ds_lista_prescr_proc_p	:=	ds_lista_prescr_proc_w;
ds_interacao_p		:=	ds_interacao_w;
ie_prescr_lib_prev_p	:=	ie_prescr_lib_prev_w;
ds_mensagem_p		:=	ds_mensagem_w;
ie_acao_p		:=	ie_acao_w;
ie_anamnese_p		:=	ie_anamnese_w;
ie_evolucao_p		:=	ie_evolucao_w;
--ds_internacao_p		:=	ds_internacao_w;
ie_estoque_p		:=	ie_estoque_ww;
ie_recomendacao_p	:=	ie_recomendacao_w;
ie_mat_hor_conflito_p := ie_mat_hor_conflito_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_prescricao_rep_2 ( nr_prescricao_p bigint, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, ie_verifica_apresent_medic_p text, ds_lista_prescr_proc_p INOUT text, ds_interacao_p INOUT text, ie_prescr_lib_prev_p INOUT text, ds_mensagem_p INOUT text, ie_acao_p INOUT text, ie_anamnese_p INOUT text, ie_evolucao_p INOUT text, ie_estoque_p INOUT text, ie_recomendacao_p INOUT text, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_mat_hor_conflito_p INOUT text) FROM PUBLIC;

