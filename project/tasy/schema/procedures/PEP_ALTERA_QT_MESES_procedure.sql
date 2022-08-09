-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_altera_qt_meses ( nr_seq_interno_p bigint, qt_meses_prev_p bigint, qt_meses_autorizado_p bigint, ds_justificativa_p text, nm_usuario_p text ) AS $body$
DECLARE

 
ie_altera_origem_w	varchar(15)	:= 'N';				
				 

BEGIN 
ie_altera_origem_w	:= obter_valor_param_usuario(1124,136,Obter_perfil_Ativo,nm_usuario_p,0);
 
if (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '') then 
	begin 
	if (coalesce(ie_altera_origem_w,'N') = 'S') then 
		update	sus_laudo_paciente 
		set	ds_justificativa  = ds_justificativa_p, 
			qt_meses_prev 	  = qt_meses_prev_p, 
			qt_meses_autorizado = qt_meses_autorizado_p, 
			dt_atualizacao	  = clock_timestamp(), 
			nm_usuario	  = nm_usuario_p, 
			ie_origem_laudo_apac = 2 
		where 	nr_seq_interno 	  = nr_seq_interno_p;		
	else 
		update	sus_laudo_paciente 
		set	ds_justificativa  = ds_justificativa_p, 
			qt_meses_prev 	  = qt_meses_prev_p, 
			qt_meses_autorizado = qt_meses_autorizado_p, 
			dt_atualizacao	  = clock_timestamp(), 
			nm_usuario	  = nm_usuario_p	 
		where 	nr_seq_interno 	  = nr_seq_interno_p;	
	end if;
	end;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_altera_qt_meses ( nr_seq_interno_p bigint, qt_meses_prev_p bigint, qt_meses_autorizado_p bigint, ds_justificativa_p text, nm_usuario_p text ) FROM PUBLIC;
