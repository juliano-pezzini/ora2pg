-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_result_sae_template ( nr_atendimento_p bigint, ie_opcao_p text, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

				 
/* 
Diagnostico			D 
*/
 
 
ds_resultado_w			varchar(32000) := '';
ds_resultado_final_w	varchar(32000) := '';

C01 CURSOR FOR 
	SELECT 	substr(substr(PE_obter_desc_diag(a.NR_SEQ_DIAG,'DI'),1,120) ||chr(13)||chr(10)|| 
				obter_desc_expressao(725620) || ' ' ||coalesce(substr(sae_Obter_result_Esperado(a.NR_SEQ_DIAG),1,200), substr(obter_result_diag_concat(a.NR_SEQUENCIA),1,255))||chr(13)||chr(10)|| 
				obter_desc_expressao(629777) || ' ' ||substr(obter_desc_sae_evolucao_diag(a.nr_seq_evolucao_diag),1,255),1,32000) 
	from	PE_PRESCR_DIAG a 
	where	a.NR_SEQ_PRESCR = (	SELECT	max(x.nr_sequencia) 
								from	pe_prescricao x 
								where	x.nr_atendimento = nr_atendimento_p 
								and		(x.dt_liberacao IS NOT NULL AND x.dt_liberacao::text <> '') 
								and		coalesce(x.dt_inativacao::text, '') = '' 
								and		x.nr_seq_modelo = nr_sequencia_p) 
	order by	a.nr_sequencia;
				

BEGIN 
 
if (nr_atendimento_p > 0) and (nr_sequencia_p > 0) then 
	 
	if (ie_opcao_p = 'D') then 
	 
		open C01;
		loop 
		fetch C01 into	 
			ds_resultado_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			if (coalesce(ds_resultado_final_w::text, '') = '') then 
				ds_resultado_final_w := ds_resultado_w;
			else			 
				ds_resultado_final_w := ds_resultado_final_w ||chr(13)||chr(10)||chr(13)||chr(10)||ds_resultado_w;
			end if;
			end;
		end loop;
		close C01;
			 
	end if;
 
end if;
 
return ds_resultado_final_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_result_sae_template ( nr_atendimento_p bigint, ie_opcao_p text, nr_sequencia_p bigint) FROM PUBLIC;

