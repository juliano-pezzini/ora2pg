-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evento_acao_job (cd_estabelecimento_p bigint) AS $body$
DECLARE

 
nr_seq_evento_w	bigint;

c01 CURSOR FOR 
	SELECT	nr_seq_evento 
	from	regra_envio_sms 
	where	cd_estabelecimento	= cd_estabelecimento_p 
	and	ie_evento_disp		= 'JOB' 
	and	coalesce(ie_situacao,'A') = 'A';


BEGIN 
open c01;
loop 
fetch c01 into 
	nr_seq_evento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	CALL gerar_evento_paciente(nr_seq_evento_w, null, null, null, null, null, null, null, null, null, null, null);
end loop;
close c01;
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evento_acao_job (cd_estabelecimento_p bigint) FROM PUBLIC;

