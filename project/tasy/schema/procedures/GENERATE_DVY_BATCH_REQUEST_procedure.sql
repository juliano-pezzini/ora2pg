-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE generate_dvy_batch_request ( cd_convenio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, dt_from_p timestamp, dt_to_p timestamp, cd_error_string_p INOUT text) AS $body$
DECLARE


completed_w varchar(30) :='Completed';

c03 CURSOR FOR
	SELECT  a.nr_interno_conta
	from	conta_paciente a,
		dva_claim b
	where 	a.nr_interno_conta = b.nr_interno_conta
	and	a.cd_convenio_parametro = cd_convenio_p
	and	coalesce(a.IE_CANCELAMENTO::text, '') = ''
	and	a.dt_periodo_inicial 	>= dt_from_p
	and	a.dt_periodo_final 	<= dt_to_p
	and	get_eclipse_claim_status(a.nr_interno_conta, 'REPORT') = completed_w
	and 	not exists (	SELECT	1
				from 	dvy_request y
				where 	(y.nr_seq_receb IS NOT NULL AND y.nr_seq_receb::text <> '')
				and   	y.CD_CLAIM = b.CD_CLAIM	
				and 	y.nr_seq_transaction = b.nr_seq_transaction);
	
BEGIN

for r03 in c03 loop
	cd_error_string_p := generate_dvy_request_data(r03.nr_interno_conta, cd_estabelecimento_p, nm_usuario_p, cd_error_string_p);
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE generate_dvy_batch_request ( cd_convenio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, dt_from_p timestamp, dt_to_p timestamp, cd_error_string_p INOUT text) FROM PUBLIC;
