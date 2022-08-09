-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_proc_vinculado_opm ( nr_sequencia_p bigint, nr_prescricao_p bigint, ie_opcao_p text, lista_proc_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

					  
cd_proc_adic_w			bigint;
ie_orig_proced_adic_w		bigint;
nr_atendimento_w		bigint;
					

BEGIN 
 
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then 
	select max(nr_atendimento) 
	into STRICT  nr_atendimento_w 
	from  prescr_medica 
	where nr_prescricao = nr_prescricao_p;
end if;
 
if (lista_proc_p IS NOT NULL AND lista_proc_p::text <> '') then 
	SELECT * FROM Obter_Proc_Tab_Interno(lista_proc_p, nr_prescricao_p, nr_atendimento_w, 0, cd_proc_adic_w, ie_orig_proced_adic_w, null, null) INTO STRICT cd_proc_adic_w, ie_orig_proced_adic_w;
end if;
 
if (ie_opcao_p = 'CAR') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then 
  
  update	prescr_opme 
  set		nr_seq_proc_interno = lista_proc_p, 
			cd_procedimento = cd_proc_adic_w, 
			ie_origem_proced = ie_orig_proced_adic_w	 
  where 	nr_prescricao  = nr_prescricao_p 
  and  	nr_sequencia   = nr_sequencia_p;
end if;	
 
if (ie_opcao_p = 'PMS') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then 
  
  update	PRESCR_PROTESE_MS 
  set  	nr_seq_proc_interno = lista_proc_p, 
			cd_procedimento = cd_proc_adic_w, 
			ie_origem_proced = ie_orig_proced_adic_w	 
  where 	nr_prescricao  = nr_prescricao_p 
  and  	nr_sequencia   = nr_sequencia_p;
end if;
 
if (ie_opcao_p = 'PMI') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then 
  
  update	PRESCR_PROTESE_MI 
  set  	nr_seq_proc_interno = lista_proc_p, 
			cd_procedimento = cd_proc_adic_w, 
			ie_origem_proced = ie_orig_proced_adic_w	 
  where 	nr_prescricao  = nr_prescricao_p 
  and  	nr_sequencia   = nr_sequencia_p;
end if;
 
if (ie_opcao_p = 'OMS') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then 
  
  update	PRESCR_ORTESE_MS 
  set  	nr_seq_proc_interno = lista_proc_p, 
			cd_procedimento = cd_proc_adic_w, 
			ie_origem_proced = ie_orig_proced_adic_w	 
  where 	nr_prescricao  = nr_prescricao_p 
  and  	nr_sequencia   = nr_sequencia_p;
end if;
 
if (ie_opcao_p = 'OMI') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then 
  
  update	PRESCR_ORTESE_MI 
  set  	nr_seq_proc_interno = lista_proc_p, 
			cd_procedimento = cd_proc_adic_w, 
			ie_origem_proced = ie_orig_proced_adic_w	 
  where 	nr_prescricao  = nr_prescricao_p 
  and  	nr_sequencia   = nr_sequencia_p;
end if;
 
if (ie_opcao_p = 'MAL') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then 
  
  update 	PRESCR_MEIO_LOCOMOCAO 
  set  	nr_seq_proc_interno = lista_proc_p, 
			cd_procedimento = cd_proc_adic_w, 
			ie_origem_proced = ie_orig_proced_adic_w	 
  where 	nr_prescricao  = nr_prescricao_p 
  and  	nr_sequencia   = nr_sequencia_p;
end if;
 
if (ie_opcao_p = 'OCO') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then 
  
  update	PRESCR_ORTESE_COLUNA 
  set  	nr_seq_proc_interno = lista_proc_p, 
			cd_procedimento = cd_proc_adic_w, 
			ie_origem_proced = ie_orig_proced_adic_w	 
  where nr_prescricao  = nr_prescricao_p 
  and  nr_sequencia   = nr_sequencia_p;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_proc_vinculado_opm ( nr_sequencia_p bigint, nr_prescricao_p bigint, ie_opcao_p text, lista_proc_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
