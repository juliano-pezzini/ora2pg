-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_liberar_med_avaliacao_pac ( nr_sequencia_p bigint, ie_avaliador_aux_p text, nr_seq_med_tipo_avaliacao_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text ) AS $body$
DECLARE

 
ds_mensagem_w	varchar(255);
		

BEGIN 
 
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then 
	begin 
	 
	if (ie_avaliador_aux_p = 'S') then 
		begin 
		 
		update	med_avaliacao_paciente 
		set   dt_liberacao_aux = clock_timestamp(), 
			nm_usuario 	= nm_usuario_p, 
			nm_usuario_lib = nm_usuario_p 
		where	nr_sequencia 	= nr_sequencia_p;
		 
		end;
	else 
		begin 
		 
		CALL liberar_avaliacao(nr_sequencia_p,nm_usuario_p);
		 
		ds_mensagem_w := gerar_mensagem_avaliacao( nr_sequencia_p, nr_seq_med_tipo_avaliacao_p, ds_mensagem_w);
		 
		end;
	end if;
		 
	end;
end if;
 
commit;
 
ds_mensagem_p := ds_mensagem_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_liberar_med_avaliacao_pac ( nr_sequencia_p bigint, ie_avaliador_aux_p text, nr_seq_med_tipo_avaliacao_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text ) FROM PUBLIC;

