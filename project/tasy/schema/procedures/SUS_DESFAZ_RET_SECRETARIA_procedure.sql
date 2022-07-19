-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_desfaz_ret_secretaria (nr_seq_interno_p bigint, ie_tipo_laudo_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
if (ie_tipo_laudo_p = 2) then 
	begin 
	begin 
	update	sus_laudo_paciente 
	set	nr_apac			 = NULL, 
		dt_retorno_secr		 = NULL, 
		dt_inicio_val_apac		 = NULL, 
		dt_fim_val_apac		 = NULL, 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp() 
	where	nr_seq_interno		= nr_seq_interno_p;
	exception 
		when others then 
		--r.aise_application_error(-20011,'Não foi possível desfazer o retorno da secretaria.'); 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(263440);
		end;	
	end;
elsif (ie_tipo_laudo_p = 3) then 
	begin 
	begin 
	update	sus_laudo_paciente 
	set	nr_bpa			 = NULL, 
		dt_retorno_secr		 = NULL, 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp() 
	where	nr_seq_interno		= nr_seq_interno_p;
	exception 
		when others then 
		--r.aise_application_error(-20011,'Não foi possível desfazer o retorno da secretaria.'); 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(263440);
		end;	
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_desfaz_ret_secretaria (nr_seq_interno_p bigint, ie_tipo_laudo_p bigint, nm_usuario_p text) FROM PUBLIC;

