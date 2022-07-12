-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_item_hor_pendente ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_tipo_item_p text) RETURNS char AS $body$
DECLARE


ie_horario_pend_w	char(1);
ie_status_w			varchar(15);
ie_acm_sn_w			varchar(1);
					

BEGIN

if (ie_tipo_item_p	in ('L','G','C','I','P','SADT')) then

	select	coalesce(max('S'),'N')
	into STRICT	ie_horario_pend_w
	from	prescr_proc_hor where		nr_prescricao		= nr_prescricao_p
	and		nr_seq_procedimento	= nr_sequencia_p
	and		coalesce(dt_fim_horario::text, '') = ''
	and		coalesce(dt_suspensao::text, '') = ''
	and		coalesce(ie_horario_especial,'N') = 'N' LIMIT 1;

	if (ie_horario_pend_w  = 'N') then
		select	coalesce(max(obter_se_acm_sn(ie_acm, ie_se_necessario)),'N')
		into STRICT	ie_acm_sn_w
		from	prescr_procedimento
		where	nr_prescricao	= nr_prescricao_p
		and		nr_sequencia	= nr_sequencia_p;
		
		if (ie_acm_sn_w = 'S') then
			select	coalesce(max('N'),'S')
			into STRICT	ie_horario_pend_w
			from	prescr_proc_hor where		nr_prescricao		= nr_prescricao_p
			and		nr_seq_procedimento	= nr_sequencia_p
			and		coalesce(ie_horario_especial,'N') = 'N' LIMIT 1;
		end if;
	end if;

elsif (ie_tipo_item_p	in ('LD','MAT','M','S', 'IAG')) then

	select	coalesce(max('S'),'N')
	into STRICT	ie_horario_pend_w
	from	prescr_mat_hor where		nr_prescricao		= nr_prescricao_p
	and		nr_seq_material		= nr_sequencia_p
	and		coalesce(dt_fim_horario::text, '') = ''
	and		coalesce(dt_suspensao::text, '') = ''
	and		coalesce(ie_horario_especial,'N') = 'N' LIMIT 1;
	
	if (ie_horario_pend_w  = 'N') then
		select	coalesce(max(obter_se_acm_sn(ie_acm, ie_se_necessario)),'N')
		into STRICT	ie_acm_sn_w
		from	prescr_material
		where	nr_prescricao	= nr_prescricao_p
		and		nr_sequencia	= nr_sequencia_p;
		
		if (ie_acm_sn_w = 'S') then
			select	coalesce(max('N'),'S')
			into STRICT	ie_horario_pend_w
			from	prescr_mat_hor where		nr_prescricao		= nr_prescricao_p
			and		nr_seq_material		= nr_sequencia_p
			and		coalesce(ie_horario_especial,'N') = 'N' LIMIT 1;
		end if;
	end if;

elsif (ie_tipo_item_p	in ('SOL','DI','NPN','NPP','NAN','HM','SNE','O')) then

	case ie_tipo_item_p
		when 'DI'  then
			select	max(ie_status)
			into STRICT	ie_status_w
			from	prescr_solucao
			where	nr_prescricao = nr_prescricao_p
			and		nr_seq_solucao = nr_sequencia_p;
		when 'HM'  then
			ie_status_w	:= obter_status_solucao_prescr(3,nr_prescricao_p,nr_sequencia_p);
		when 'NAN' then
			ie_status_w	:= obter_status_solucao_prescr(6,nr_prescricao_p,nr_sequencia_p);
		when 'NPN' then
			ie_status_w	:= obter_status_solucao_prescr(5,nr_prescricao_p,nr_sequencia_p);
		when 'NPP' then
			ie_status_w	:= obter_status_solucao_prescr(5,nr_prescricao_p,nr_sequencia_p);
		when 'SNE' then
			ie_status_w	:= plt_obter_status_solucao(2,nr_prescricao_p,nr_sequencia_p);
		when 'SOL' then
			ie_status_w	:= obter_status_solucao_prescr(1,nr_prescricao_p,nr_sequencia_p);
		when 'O'   then
			ie_status_w	:= Obter_Status_Gasoterapia(nr_sequencia_p, 'C');
		else
			ie_status_w	:= 'P';
	end	case;

	if (ie_status_w in ('S','T','V')) then
		ie_horario_pend_w	:= 'N';
	else
		ie_horario_pend_w	:= 'S';	
	end if;
	
elsif (ie_tipo_item_p	in ('D')) then

	select	coalesce(max('S'),'N')
	into STRICT	ie_horario_pend_w
	from	prescr_dieta_hor where		nr_prescricao		= nr_prescricao_p
	and		nr_seq_dieta		= nr_sequencia_p
	and		coalesce(dt_fim_horario::text, '') = ''
	and		coalesce(dt_suspensao::text, '') = '' LIMIT 1;

elsif (ie_tipo_item_p	in ('J')) then

	ie_horario_pend_w	:= 'N';

elsif (ie_tipo_item_p	in ('R')) then

	select	coalesce(max('S'),'N')
	into STRICT	ie_horario_pend_w
	from	prescr_rec_hor where		nr_prescricao		= nr_prescricao_p
	and		nr_seq_recomendacao	= nr_sequencia_p
	and		coalesce(dt_fim_horario::text, '') = ''
	and		coalesce(dt_suspensao::text, '') = ''
	and		coalesce(ie_horario_especial,'N') = 'N' LIMIT 1;
	
	if (ie_horario_pend_w  = 'N') then
		select	coalesce(max(obter_se_acm_sn(ds_horarios, ie_se_necessario)),'N')
		into STRICT	ie_acm_sn_w
		from	prescr_recomendacao
		where	nr_prescricao	= nr_prescricao_p
		and		nr_sequencia	= nr_sequencia_p;
		
		if (ie_acm_sn_w = 'S') then
			select	coalesce(max('N'),'S')
			into STRICT	ie_horario_pend_w
			from	prescr_rec_hor where		nr_prescricao		= nr_prescricao_p
			and		nr_seq_recomendacao	= nr_sequencia_p
			and		coalesce(ie_horario_especial,'N') = 'N' LIMIT 1;
		end if;
	end if;
	
end if;

return	ie_horario_pend_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_item_hor_pendente ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_tipo_item_p text) FROM PUBLIC;

