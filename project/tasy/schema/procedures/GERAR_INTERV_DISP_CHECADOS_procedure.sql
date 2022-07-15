-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_interv_disp_checados ( nr_atendimento_p bigint, nr_seq_pe_prescricao_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
			 
nr_sequencia_w			bigint;	
nr_seq_intervencao_w	bigint;
ds_hora_w				varchar(255);

					 
					 
C01 CURSOR FOR 
SELECT  a.nr_sequencia 
from 	dispositivo b, 
		atend_pac_dispositivo a 
where 	a.nr_seq_dispositivo = b.nr_sequencia 
and  	nr_atendimento = nr_atendimento_p 
and  	coalesce(dt_retirada::text, '') = '' 
and  	obter_se_exibe_graf_disp(a.nr_sequencia) = 'S' 
order by b.nr_seq_apres desc, dt_instalacao desc;

 
C02 CURSOR FOR 
SELECT DISTINCT a.nr_seq_proc, 
    SUBSTR(obter_dados_disp_inter_sae( nr_seq_pe_prescricao_p,b.nr_seq_dispositivo,b.nr_sequencia,'H',b.nr_atendimento,a.nr_seq_proc),1,255) ds_hora 
FROM  pe_proc_dispositivo a, 
    atend_pac_dispositivo b 
WHERE b.nr_sequencia = nr_sequencia_w 
and	  SUBSTR(obter_dados_disp_inter_sae(nr_seq_pe_prescricao_p,b.nr_seq_dispositivo,b.nr_sequencia,'G',b.nr_atendimento,a.nr_seq_proc),1,1) = 'S' 
AND  a.nr_seq_dispositivo = b.nr_seq_dispositivo 
AND  coalesce(b.ie_acao_sae,'X') = 'M' 
AND  coalesce(a.ie_acao_manter,'N') = 'S' 

UNION ALL
 
SELECT DISTINCT a.nr_seq_proc, 
    SUBSTR(obter_dados_disp_inter_sae(nr_seq_pe_prescricao_p,b.nr_seq_dispositivo,b.nr_sequencia,'H',b.nr_atendimento,a.nr_seq_proc),1,255) ds_hora 
FROM  pe_proc_dispositivo a, 
    atend_pac_dispositivo b 
WHERE b.nr_sequencia = nr_sequencia_w 
and	  SUBSTR(obter_dados_disp_inter_sae(nr_seq_pe_prescricao_p,b.nr_seq_dispositivo,b.nr_sequencia,'G',b.nr_atendimento,a.nr_seq_proc),1,1) = 'S' 
AND  a.nr_seq_dispositivo = b.nr_seq_dispositivo 
AND  coalesce(b.ie_acao_sae,'X') = 'E' 
AND  coalesce(a.ie_acao_estender,'N') = 'S' 

UNION ALL
 
SELECT DISTINCT a.nr_seq_proc, 
    SUBSTR(obter_dados_disp_inter_sae(nr_seq_pe_prescricao_p,b.nr_seq_dispositivo,b.nr_sequencia,'H',b.nr_atendimento,a.nr_seq_proc),1,255) ds_hora 
FROM  pe_proc_dispositivo a, 
    atend_pac_dispositivo b 
WHERE b.nr_sequencia = nr_sequencia_w 
and	  SUBSTR(obter_dados_disp_inter_sae(nr_seq_pe_prescricao_p,b.nr_seq_dispositivo,b.nr_sequencia,'G',b.nr_atendimento,a.nr_seq_proc),1,1) = 'S' 
AND  a.nr_seq_dispositivo = b.nr_seq_dispositivo 
AND  coalesce(b.ie_acao_sae,'X') = 'R' 
AND  coalesce(a.ie_acao_retirar,'N') = 'S';

 
					 

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	open C02;
	loop 
	fetch C02 into	 
		nr_seq_intervencao_w, 
		ds_hora_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		 
		CALL Gerar_Intervencao_Dispositivo( nr_seq_pe_prescricao_p, nr_seq_intervencao_w, nr_sequencia_w, ds_hora_w, nm_usuario_p );	
		 
		end;
	end loop;
	close C02;	
	 
	end;
end loop;
close C01;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_interv_disp_checados ( nr_atendimento_p bigint, nr_seq_pe_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;

