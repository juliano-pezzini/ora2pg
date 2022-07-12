-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpt_obter_se_incons_item (nr_seq_cpoe_p bigint, nm_tabela_p text) RETURNS varchar AS $body$
DECLARE

								
ie_inconsistencia_w		varchar(1)	:= 'N';


BEGIN



if (nm_tabela_p = 'CPOE_MATERIAL') then
	
SELECT   CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_inconsistencia_w
FROM	 prescr_material_incon_farm a
WHERE    a.nr_prescricao  = (SELECT  max(a.nr_prescricao)
								 FROM  prescr_medica a, prescr_material b
								 WHERE  b.nr_prescricao = a.nr_prescricao
								 AND 		  b.nr_seq_mat_cpoe = nr_seq_cpoe_p
								 AND 		  a.dt_suspensao IS  NULL
								 AND 		  (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')								 
								 AND          a.cd_funcao_origem NOT IN (924,950)
								 AND		  b.ie_agrupador in (1,5))
AND  nr_seq_material IN (SELECT x.nr_sequencia
FROM	prescr_material x
WHERE x.nr_prescricao = a.nr_prescricao 
AND	x.ie_agrupador in (1,5) 
AND	x.nr_seq_mat_cpoe = nr_seq_cpoe_p)
AND a.ie_situacao = 'A'; 				
					
	
elsif (nm_tabela_p = 'SOLUCAO') then
	
SELECT  CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_inconsistencia_w
FROM	 prescr_material_incon_farm a
WHERE  a.nr_prescricao  = (SELECT  max(a.nr_prescricao)
								 FROM  prescr_medica a, prescr_material b
								 WHERE  b.nr_prescricao = a.nr_prescricao
								 AND 		  b.nr_seq_mat_cpoe = nr_seq_cpoe_p
								 AND 		  a.dt_suspensao IS  NULL
								 AND 		  (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')								 
								 AND          a.cd_funcao_origem NOT IN (924,950)
								 AND		  b.ie_agrupador = 4)
AND  nr_seq_solucao IN (SELECT x.nr_sequencia_solucao
FROM	prescr_material x
WHERE x.nr_prescricao = a.nr_prescricao 
AND	x.ie_agrupador = 4 
AND	x.nr_seq_mat_cpoe = nr_seq_cpoe_p)
AND a.ie_situacao = 'A'; 			
	
end if;

return	ie_inconsistencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpt_obter_se_incons_item (nr_seq_cpoe_p bigint, nm_tabela_p text) FROM PUBLIC;

