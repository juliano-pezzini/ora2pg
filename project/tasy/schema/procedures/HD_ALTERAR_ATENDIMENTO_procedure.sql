-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_alterar_atendimento ( nr_seq_dialise_p bigint, nr_atendimento_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

					 
qt_atendimento_w 	smallint;


BEGIN 
 
SELECT 	COUNT(*) 
INTO STRICT 	qt_atendimento_w 
FROM 	atendimento_paciente 
WHERE 	nr_atendimento  	= nr_atendimento_p 
AND	cd_pessoa_fisica 	= (SELECT	MAX(cd_pessoa_fisica) 
			  FROM 		hd_dialise 
			  WHERE	nr_sequencia = nr_seq_dialise_p);
 
if (coalesce(nr_atendimento_p::text, '') = '') then 
	ds_erro_p	:= wheb_mensagem_pck.get_texto(279698);
	 
elsif (nr_atendimento_p = 0) then 
	ds_erro_p	:= wheb_mensagem_pck.get_texto(279698);
	 
elsif (length(nr_atendimento_p) > 10) then 
	ds_erro_p	:= wheb_mensagem_pck.get_texto(364479);
 
elsif (qt_atendimento_w = 0) then 
	ds_erro_p	:= wheb_mensagem_pck.get_texto(364479);
	 
else 
	 
	update	hd_dialise 
	set	nr_atendimento	= nr_atendimento_p, 
		nm_usuario	= nm_usuario_p, 
		dt_atualizacao	= clock_timestamp() 
	where	nr_sequencia	= nr_seq_dialise_p;
	 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_alterar_atendimento ( nr_seq_dialise_p bigint, nr_atendimento_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
