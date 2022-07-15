-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gen_dvr_account_batch_request ( nr_batch_conta_p bigint, --account batch number patient billing
 cd_estabelecimento_p bigint, nm_usuario_p text, cd_error_string_p INOUT text) AS $body$
DECLARE


c03 CURSOR FOR
	SELECT  a.NR_INTERNO_CONTA
	from	CONTA_PACIENTE a
	where	a.NR_SEQ_PROTOCOLO 	= nr_batch_conta_p; -- also put the claim status check as well, only send those claims for which the recipt is not generated  
BEGIN

for r03 in c03 loop
	cd_error_string_p := GENERATE_DVR_REQUEST_DATA(r03.NR_INTERNO_CONTA, cd_estabelecimento_p, nm_usuario_p, cd_error_string_p);
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gen_dvr_account_batch_request ( nr_batch_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_error_string_p INOUT text) FROM PUBLIC;

