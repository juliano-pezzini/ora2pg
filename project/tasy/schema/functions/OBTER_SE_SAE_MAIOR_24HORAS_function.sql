-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_sae_maior_24horas (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 ds_sae_w 		 varchar(255);

 
BEGIN 
	 SELECT  'EXPIRADA' ds_sae 
	 INTO STRICT ds_sae_w 
	  
	 WHERE EXISTS (SELECT presc.NR_SEQUENCIA 
			  	 FROM PE_PRESCRICAO presc 
		 		 WHERE presc.NR_ATENDIMENTO = nr_atendimento_p) 
	 AND 	 	 (SELECT presc.NR_SEQUENCIA 
	 		  	 FROM PE_PRESCRICAO presc 
		 	  	 WHERE presc.NR_ATENDIMENTO = nr_atendimento_p 
			  	 AND presc.NR_SEQUENCIA =  (SELECT MAX(x.NR_SEQUENCIA) 
				  	  					 	  FROM PE_PRESCRICAO x 
			 								  WHERE x.NR_ATENDIMENTO = nr_atendimento_p 
											  AND (x.DT_LIBERACAO IS NOT NULL AND x.DT_LIBERACAO::text <> '') 
											  AND coalesce(x.DT_INATIVACAO::text, '') = '' 
			 								  AND EXISTS (SELECT item.NR_SEQUENCIA 
											  	  				  FROM PE_PRESCR_ITEM_RESULT item 
																  WHERE item.NR_SEQ_PRESCR = x.NR_SEQUENCIA)) 
		    AND (clock_timestamp() - presc.DT_LIBERACAO > 1)) IS NOT NULL;
  RETURN ds_sae_w;
 END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_sae_maior_24horas (nr_atendimento_p bigint) FROM PUBLIC;

