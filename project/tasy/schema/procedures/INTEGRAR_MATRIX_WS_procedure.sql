-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE integrar_matrix_ws ( nr_seq_evento_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, nm_usuario_p text, ie_commit_p text default 'N') AS $body$
DECLARE

		
ds_sep_bv_w					varchar(100);
ds_param_integr_w			varchar(4000);
ds_log_w					varchar(2000);
ie_envia_msg_w				varchar(1);
		
recebePedido_w				smallint := 249;
recebeConfirmacaoColeta_w	smallint := 252;
cancelaPedido_w				smallint := 414;
		

BEGIN

ds_sep_bv_w := ';';

if (nr_Seq_evento_p in (	recebePedido_w,
							recebeConfirmacaoColeta_w,
							cancelaPedido_w
							)) then

	if (nr_seq_evento_p = recebePedido_w) then
	
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_envia_msg_w
		from	matrix_procedimento_ws_v a
		where	a.numero_atendimento = nr_prescricao_p;
		
		if (ie_envia_msg_w = 'S') then
			ds_param_integr_w	:=	'NR_PRESCRICAO=' || to_char(nr_prescricao_p) || ds_sep_bv_w ||
									'NR_SEQUENCIA=0' || ds_sep_bv_w;	
		end if;
		
		ds_log_w				:=	'Matrix Diagnosis - NR_SEQ_EVENTO_P: '||to_char(nr_seq_evento_p)||
									' - NR_PRESCRICAO_P: '|| to_char(nr_prescricao_p)||
									' - IE_ENVIA_MSG_W: '|| ie_envia_msg_w;
		
	elsif (nr_seq_evento_p = recebeConfirmacaoColeta_w) then
		
		select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
		into STRICT	ie_envia_msg_w
		from	lab_exame_equip a,
				equipamento_lab b
		where	a.cd_equipamento = b.cd_equipamento
		AND		b.ds_sigla = 'MATRIX'
		and		a.nr_seq_exame	= nr_seq_exame_p;
		
		if (ie_envia_msg_w = 'S') then
			ds_param_integr_w 	:= 	'NR_PRESCRICAO=' || to_char(nr_prescricao_p) || ds_sep_bv_w ||
									'NR_SEQUENCIA=' || to_char(nr_seq_prescr_p) || ds_sep_bv_w;		
		end if;
		
		ds_log_w				:= 	'Matrix Diagnosis - NR_SEQ_EVENTO_P: '||to_char(nr_seq_evento_p)||' - NR_PRESCRICAO_P: '||nr_prescricao_p||' - NR_SEQUENCIA:'||to_char(nr_seq_prescr_p) || ' - IE_ENVIA_MSG_W: ' || ie_envia_msg_w;

	elsif (nr_seq_evento_p = cancelaPedido_w) then
	
		/*select	decode(count(*),0,'N','S')
		into	ie_envia_msg_w
		from	matrix_procedimento_ws_v a
		where	a.numero_atendimento = nr_prescricao_p
		and		a.sequencia_exame = nr_seq_prescr_p
		and		nvl(a.ie_suspenso,'N') <> 'S';*/
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_envia_msg_w
		from	lab_exame_equip a,
				equipamento_lab b
		where	a.nr_seq_exame = nr_seq_exame_p
		and 	a.cd_equipamento = b.cd_equipamento
		and 	b.ds_sigla = 'MATRIX';
		
		if (ie_envia_msg_w = 'S') then
			ds_param_integr_w	:=	'NR_PRESCRICAO=' || to_char(nr_prescricao_p) || ds_sep_bv_w ||
									'NR_SEQUENCIA=' || to_char(coalesce(nr_seq_prescr_p,0)) || ds_sep_bv_w;
		end if;
		
		ds_log_w				:=	'Matrix Diagnosis - NR_SEQ_EVENTO_P: '||to_char(nr_seq_evento_p)||
									' - NR_PRESCRICAO_P: '|| to_char(nr_prescricao_p)||
									' - NR_SEQUENCIA:'||to_char(nr_seq_prescr_p) ||
									' - IE_ENVIA_MSG_W: '|| ie_envia_msg_w;
	
	else
	
		ds_log_w			:= 	'Matrix Diagnosis - Evento não informado';

	end if;
	
	CALL gravar_log_lab(66, ds_log_w, nm_usuario_p);
	
	if (ds_param_integr_w IS NOT NULL AND ds_param_integr_w::text <> '') then		
		CALL gravar_agend_integracao(nr_seq_evento_p, ds_param_integr_w);	
	end if;
	
	if (ie_commit_p = 'S') then
		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
	end if;
							
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE integrar_matrix_ws ( nr_seq_evento_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, nm_usuario_p text, ie_commit_p text default 'N') FROM PUBLIC;
