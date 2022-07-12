-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION suep_pck.obter_dieta ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_suep_p bigint, nm_usuario_p text ) RETURNS SETOF T_CPOE_ROW_DATA AS $body$
DECLARE

			 
t_solucao_row_w		t_cpoe_row;

 
C01 CURSOR FOR 
	SELECT 	distinct 
		SUBSTR(OBTER_DESC_DIETA(d.CD_DIETA),1,255) DS_DIETA 
	from	prescr_medica a, 
		Prescr_Dieta d 
	where 	d.nr_prescricao = a.nr_prescricao 
	and	clock_timestamp() between a.dt_inicio_prescr and	a.dt_validade_prescr 
	and	a.nr_atendimento = nr_atendimento_p 
	and	coalesce(a.dt_suspensao::text, '') = '' 
	and	coalesce(d.dt_suspensao::text, '') = '' 
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
	and	(d.CD_DIETA IS NOT NULL AND d.CD_DIETA::text <> '') 
	order by DS_DIETA;

 
BEGIN 
 
 
for r_c01 in c01 loop 
	begin 
	t_solucao_row_w.ds_item 		:= r_c01.DS_DIETA;
	t_solucao_row_w.ie_tipo			:= 'NUT';
	 
	RETURN NEXT t_solucao_row_w;
	end;
end loop;
 
 
return;
 
 
END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION suep_pck.obter_dieta ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_suep_p bigint, nm_usuario_p text ) FROM PUBLIC;
