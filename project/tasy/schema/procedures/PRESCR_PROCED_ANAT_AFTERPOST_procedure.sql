-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE prescr_proced_anat_afterpost ( nr_prescricao_p bigint, nr_sequencia_p bigint) AS $body$
DECLARE

						 
dt_resultado_w			timestamp;
nr_seq_exame_w     prescr_procedimento.nr_seq_exame%type;


BEGIN 
 
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then 
	 
	select coalesce(max(nr_seq_exame),0) 
	into STRICT nr_seq_exame_w 
	from prescr_procedimento 
	where nr_sequencia  = nr_sequencia_p 
	and	 nr_prescricao = nr_prescricao_p;
	 
	if (nr_seq_exame_w <> 0) and (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then 
		 
		dt_resultado_w	:= Prescr_obter_dt_result_regra(nr_sequencia_p,nr_prescricao_p);
		 
		if (dt_resultado_w IS NOT NULL AND dt_resultado_w::text <> '') then 
		 
			update prescr_procedimento 
			set	dt_resultado = dt_resultado_w 
			where nr_sequencia = nr_sequencia_p 
			and	nr_prescricao = nr_prescricao_p;
			 
			commit;
			 
		end if;	
	end if;	
end if;	
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE prescr_proced_anat_afterpost ( nr_prescricao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

