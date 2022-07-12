-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION suep_pck.obter_diag_sae ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_suep_p bigint, nm_usuario_p text ) RETURNS SETOF T_CPOE_ROW_DATA AS $body$
DECLARE

			 
t_diag_sae_row_w		t_cpoe_row;

C01 CURSOR FOR 
	SELECT substr(pe_obter_desc_diag(b.nr_seq_diag,'DI'),1,255) ds_diagnostico 
	FROM	pe_prescricao a, 
		pe_prescr_diag b 
	WHERE 	a.nr_sequencia = b.nr_seq_prescr 
	and 	a.nr_atendimento = nr_atendimento_p 
	and 	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
	and 	coalesce(a.dt_inativacao::text, '') = '' 
	and 	clock_timestamp() between a.dt_inicio_prescr AND	a.dt_validade_prescr 
	ORDER BY a.dt_prescricao desc;

 
BEGIN 
 
for r_c01 in c01 loop 
	begin 
	t_diag_sae_row_w.ds_item 		:= r_c01.ds_diagnostico;
	t_diag_sae_row_w.ie_tipo		:= 'SAEDIAG';
	RETURN NEXT t_diag_sae_row_w;
	end;
end loop;
 
return;
 
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION suep_pck.obter_diag_sae ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_suep_p bigint, nm_usuario_p text ) FROM PUBLIC;