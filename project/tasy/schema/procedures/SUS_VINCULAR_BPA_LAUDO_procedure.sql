-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_vincular_bpa_laudo ( nr_seq_interno_p bigint, nr_bpa_p bigint, dt_retorno_secr_p timestamp, nm_usuario_p text) AS $body$
BEGIN
 
begin 
update	sus_laudo_paciente 
set	nr_bpa			= CASE WHEN nr_bpa_p=0 THEN null  ELSE nr_bpa_p END , 
	dt_retorno_secr		= dt_retorno_secr_p, 
	nm_usuario		= nm_usuario_p, 
	dt_atualizacao		= clock_timestamp() 
where	nr_seq_interno		= nr_seq_interno_p;
exception 
when others then 
	--r.aise_application_error(-20011,'Não foi possível vincular o número BPA ao laudo.'); 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263635);
end;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_vincular_bpa_laudo ( nr_seq_interno_p bigint, nr_bpa_p bigint, dt_retorno_secr_p timestamp, nm_usuario_p text) FROM PUBLIC;

