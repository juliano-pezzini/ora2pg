-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE buscar_prescr_pac (nr_sequencia_p bigint, ie_opcao_p text) AS $body$
DECLARE

			 
nr_sequencia_w			nut_prod_lac_item.nr_sequencia%type;
nr_atendimento_w		prescr_medica.nr_atendimento%type;
nr_seq_dispositivo_w	prescr_leite_deriv.nr_seq_disp_succao%type;
nr_prescricao_w			prescr_medica.nr_prescricao%type;
		
C01 CURSOR FOR 
	SELECT 	d.nr_sequencia, 
		a.nr_atendimento, 
		(SELECT max(l.nr_seq_disp_succao) 
		FROM	prescr_leite_deriv l 
		WHERE l.nr_sequencia = b.nr_seq_leite_deriv) nr_seq_dispositivo, 
		a.nr_prescricao 
	FROM	prescr_medica   a, 
		prescr_material  b, 
		nut_prod_lac_item d, 
		prescr_mat_hor  e 
	WHERE  b.nr_prescricao   = d.nr_prescricao 
	AND	b.nr_sequencia   = d.nr_seq_material 
	AND	d.nr_seq_mat_hor  = e.nr_sequencia 
	AND	d.nr_seq_prod_princ = nr_sequencia_p 
	AND 	a.nr_prescricao   = b.nr_prescricao;		
	 

BEGIN 
 
	open C01;
	loop 
	fetch C01 into	 
		nr_sequencia_w, 
		nr_atendimento_w, 
		nr_seq_dispositivo_w, 
		nr_prescricao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '' AND nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
			if (ie_opcao_p = 'C') then 
				CALL nut_consistir_mat_conta_pac(nr_sequencia_w, nr_atendimento_w,nr_seq_dispositivo_w, nr_prescricao_w);
			else 
				CALL Insere_mat_resumo_pac(nr_sequencia_w, nr_atendimento_w,nr_seq_dispositivo_w, nr_prescricao_w);				
			end if;
		end if;
		end;
	end loop;
	close C01;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE buscar_prescr_pac (nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
