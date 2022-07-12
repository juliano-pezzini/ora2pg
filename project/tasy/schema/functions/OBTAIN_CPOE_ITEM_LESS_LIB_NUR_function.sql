-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obtain_cpoe_item_less_lib_nur (nr_atendimento_p bigint, nr_seq_cpoe_p bigint default null, ie_suspensao_p text default null) RETURNS varchar AS $body$
DECLARE

ie_qtd_w    bigint := 0;

BEGIN
	select
		count(a.nr_sequencia)
	into STRICT 
		ie_qtd_w
	from  cpoe_dieta a,
		  cpoe_inf_adic b
	where a.nr_atendimento = nr_atendimento_p
	and a.nr_sequencia = b.nr_seq_diet_cpoe
	and (((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and coalesce(b.dt_ack_nurse::text, '') = ''
	and coalesce(b.nm_user_ack::text, '') = ''
	and coalesce(ie_suspensao_p, 'N') = 'N')
	or ((a.dt_suspensao IS NOT NULL AND a.dt_suspensao::text <> '') 
	and (a.dt_lib_suspensao IS NOT NULL AND a.dt_lib_suspensao::text <> '') 
	and coalesce(coalesce(b.dt_ack_nurse_susp, b.dt_ack_nurse)::text, '') = ''
	and coalesce(coalesce(b.nm_user_ack_susp, b.nm_user_ack)::text, '') = ''
	and coalesce(ie_suspensao_p, 'S') = 'S'))
	and a.nr_sequencia = nr_seq_cpoe_p;
	
	if ie_qtd_w > 0 then
	  return 'N';
	end if;
	
	select
		count(a.nr_sequencia)
	into STRICT 
		ie_qtd_w
	from  cpoe_material a,
		  cpoe_inf_adic b
	where a.nr_atendimento = nr_atendimento_p
	and a.nr_sequencia = b.nr_seq_mat_cpoe
	and (((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and coalesce(b.dt_ack_nurse::text, '') = ''
	and coalesce(b.nm_user_ack::text, '') = ''
	and coalesce(ie_suspensao_p, 'N') = 'N')
	or ((a.dt_suspensao IS NOT NULL AND a.dt_suspensao::text <> '') 
	and (a.dt_lib_suspensao IS NOT NULL AND a.dt_lib_suspensao::text <> '') 
	and coalesce(coalesce(b.dt_ack_nurse_susp, b.dt_ack_nurse)::text, '') = ''
	and coalesce(coalesce(b.nm_user_ack_susp, b.nm_user_ack)::text, '') = ''
	and coalesce(ie_suspensao_p, 'S') = 'S'))
	and a.nr_sequencia = nr_seq_cpoe_p;
	
	if ie_qtd_w > 0 then
	  return 'N';
	end if;
	
	select
		count(a.nr_sequencia)
	into STRICT 
		ie_qtd_w
	from cpoe_dialise a,
		cpoe_inf_adic b
	where a.nr_atendimento = nr_atendimento_p
	and a.nr_sequencia = b.nr_seq_dial_cpoe
	and (((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and coalesce(b.dt_ack_nurse::text, '') = ''
	and coalesce(b.nm_user_ack::text, '') = ''
	and coalesce(ie_suspensao_p, 'N') = 'N')
	or ((a.dt_suspensao IS NOT NULL AND a.dt_suspensao::text <> '') 
	and (a.dt_lib_suspensao IS NOT NULL AND a.dt_lib_suspensao::text <> '') 
	and coalesce(coalesce(b.dt_ack_nurse_susp, b.dt_ack_nurse)::text, '') = ''
	and coalesce(coalesce(b.nm_user_ack_susp, b.nm_user_ack)::text, '') = ''
	and coalesce(ie_suspensao_p, 'S') = 'S'))
	and a.nr_sequencia = nr_seq_cpoe_p;
	
	if ie_qtd_w > 0 then
	  return 'N';
	end if;
	
	select
		count(a.nr_sequencia)
	into STRICT 
		ie_qtd_w
	from cpoe_gasoterapia a,
		cpoe_inf_adic b
	where a.nr_atendimento = nr_atendimento_p
	and a.nr_sequencia = b.nr_seq_gaso_cpoe
	and (((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and coalesce(b.dt_ack_nurse::text, '') = ''
	and coalesce(b.nm_user_ack::text, '') = ''
	and coalesce(ie_suspensao_p, 'N') = 'N')
	or ((a.dt_suspensao IS NOT NULL AND a.dt_suspensao::text <> '') 
	and (a.dt_lib_suspensao IS NOT NULL AND a.dt_lib_suspensao::text <> '') 
	and coalesce(coalesce(b.dt_ack_nurse_susp, b.dt_ack_nurse)::text, '') = ''
	and coalesce(coalesce(b.nm_user_ack_susp, b.nm_user_ack)::text, '') = ''
	and coalesce(ie_suspensao_p, 'S') = 'S'))
	and a.nr_sequencia = nr_seq_cpoe_p;
	
	if ie_qtd_w > 0 then
	  return 'N';
	end if;
	
	select
		count(a.nr_sequencia)
	into STRICT 
		ie_qtd_w
	from cpoe_hemoterapia a,
		cpoe_inf_adic b
	where a.nr_atendimento = nr_atendimento_p
	and a.nr_sequencia = b.nr_seq_hemo_cpoe
	and (((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and coalesce(b.dt_ack_nurse::text, '') = ''
	and coalesce(b.nm_user_ack::text, '') = ''
	and coalesce(ie_suspensao_p, 'N') = 'N')
	or ((a.dt_suspensao IS NOT NULL AND a.dt_suspensao::text <> '') 
	and (a.dt_lib_suspensao IS NOT NULL AND a.dt_lib_suspensao::text <> '') 
	and coalesce(coalesce(b.dt_ack_nurse_susp, b.dt_ack_nurse)::text, '') = ''
	and coalesce(coalesce(b.nm_user_ack_susp, b.nm_user_ack)::text, '') = ''
	and coalesce(ie_suspensao_p, 'S') = 'S'))
	and a.nr_sequencia = nr_seq_cpoe_p;
	
	if ie_qtd_w > 0 then
	  return 'N';
	end if;
	
	select
		count(a.nr_sequencia)
	into STRICT 
		ie_qtd_w
	from cpoe_procedimento a,
		cpoe_inf_adic b
	where a.nr_atendimento = nr_atendimento_p
	and a.nr_sequencia = b.nr_seq_exam_cpoe
	and (((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and coalesce(b.dt_ack_nurse::text, '') = ''
	and coalesce(b.nm_user_ack::text, '') = ''
	and coalesce(ie_suspensao_p, 'N') = 'N')
	or ((a.dt_suspensao IS NOT NULL AND a.dt_suspensao::text <> '') 
	and (a.dt_lib_suspensao IS NOT NULL AND a.dt_lib_suspensao::text <> '') 
	and coalesce(coalesce(b.dt_ack_nurse_susp, b.dt_ack_nurse)::text, '') = ''
	and coalesce(coalesce(b.nm_user_ack_susp, b.nm_user_ack)::text, '') = ''
	and coalesce(ie_suspensao_p, 'S') = 'S'))
	and a.nr_sequencia = nr_seq_cpoe_p;
	
	if ie_qtd_w > 0 then
	  return 'N';
	end if;
	
	select
		count(a.nr_sequencia)
	into STRICT 
		ie_qtd_w
	from cpoe_recomendacao a,
		cpoe_inf_adic b
	where a.nr_atendimento = nr_atendimento_p
	and a.nr_sequencia = b.nr_seq_rec_cpoe
	and (((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and coalesce(b.dt_ack_nurse::text, '') = ''
	and coalesce(b.nm_user_ack::text, '') = ''
	and coalesce(ie_suspensao_p, 'N') = 'N')
	or ((a.dt_suspensao IS NOT NULL AND a.dt_suspensao::text <> '') 
	and (a.dt_lib_suspensao IS NOT NULL AND a.dt_lib_suspensao::text <> '') 
	and coalesce(coalesce(b.dt_ack_nurse_susp, b.dt_ack_nurse)::text, '') = ''
	and coalesce(coalesce(b.nm_user_ack_susp, b.nm_user_ack)::text, '') = ''
	and coalesce(ie_suspensao_p, 'S') = 'S'))
	and a.nr_sequencia = nr_seq_cpoe_p;
	
	if ie_qtd_w > 0 then
	  return 'N';
	end if;
	
	select
		count(a.nr_sequencia)
	into STRICT 
		ie_qtd_w
	from cpoe_anatomia_patologica a,
		cpoe_inf_adic b
	where a.nr_atendimento = nr_atendimento_p
	and a.nr_sequencia = b.nr_seq_anat_cpoe
	and (((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and coalesce(b.dt_ack_nurse::text, '') = ''
	and coalesce(b.nm_user_ack::text, '') = ''
	and coalesce(ie_suspensao_p, 'N') = 'N')
	or ((a.dt_suspensao IS NOT NULL AND a.dt_suspensao::text <> '') 
	and (a.dt_lib_suspensao IS NOT NULL AND a.dt_lib_suspensao::text <> '') 
	and coalesce(coalesce(b.dt_ack_nurse_susp, b.dt_ack_nurse)::text, '') = ''
	and coalesce(coalesce(b.nm_user_ack_susp, b.nm_user_ack)::text, '') = ''
	and coalesce(ie_suspensao_p, 'S') = 'S'))
	and a.nr_sequencia = nr_seq_cpoe_p;
	
	if ie_qtd_w > 0 then
	  return 'N';
	end if;
	
	return 'S';
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obtain_cpoe_item_less_lib_nur (nr_atendimento_p bigint, nr_seq_cpoe_p bigint default null, ie_suspensao_p text default null) FROM PUBLIC;
