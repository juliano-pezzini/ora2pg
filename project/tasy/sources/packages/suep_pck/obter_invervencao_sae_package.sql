-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION suep_pck.obter_invervencao_sae ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_suep_p bigint, nm_usuario_p text ) RETURNS SETOF T_CPOE_ROW_DATA AS $body$
DECLARE

			 
t_interv_sae_row_w		t_cpoe_row;

 
C01 CURSOR FOR 
	SELECT	substr(obter_desc_intervencoes(b.nr_seq_proc),1,255) ds_intervencoes, 
		coalesce(x.ds_intervalo,'') cd_intervalo, 
		b.hr_prim_horario 
	FROM pe_prescricao a, pe_prescr_proc b
LEFT OUTER JOIN intervalo_prescricao x ON (b.cd_intervalo = x.cd_intervalo)
WHERE a.nr_sequencia  = b.nr_seq_prescr and a.nr_atendimento  = nr_atendimento_p  and clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') and coalesce(a.dt_inativacao::text, '') = '' and coalesce(b.DT_SUSPENSAO::text, '') = '' order by a.dt_prescricao desc;

 
BEGIN 
 
 
for r_c01 in c01 loop 
	begin 
	t_interv_sae_row_w.ds_item 		:= r_c01.ds_intervencoes;
	t_interv_sae_row_w.ds_intervalo		:= r_c01.cd_intervalo;
	t_interv_sae_row_w.hr_prim_horario	:= r_c01.hr_prim_horario;
	t_interv_sae_row_w.ie_tipo		:= 'SAEINTERV';
	 
	RETURN NEXT t_interv_sae_row_w;
	end;
end loop;
 
 
return;
 
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION suep_pck.obter_invervencao_sae ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_suep_p bigint, nm_usuario_p text ) FROM PUBLIC;
