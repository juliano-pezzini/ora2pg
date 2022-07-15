-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_ovs_serv_response_exp ( nr_seq_service_p bigint, dt_atualizacao_p timestamp, nm_usuario_p text, dt_atualizacao_nrec_p timestamp, nm_usuario_nrec_p text, cd_service_exp_p bigint, ds_service_exp_p text) AS $body$
DECLARE


nr_sequencia_w ovs_service_response_exp.nr_sequencia%type;


BEGIN
	select 	nextval('ovs_service_response_exp_seq')
	into STRICT 	nr_sequencia_w
	;
	
	insert into ovs_service_response_exp(
			nr_sequencia,
			nr_seq_service,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_service_exp,
			ds_service_exp)
	values (
			nr_sequencia_w,
			nr_seq_service_p,
			dt_atualizacao_p,
			nm_usuario_p,
			dt_atualizacao_nrec_p,
			nm_usuario_nrec_p,
			cd_service_exp_p,
			ds_service_exp_p);

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_ovs_serv_response_exp ( nr_seq_service_p bigint, dt_atualizacao_p timestamp, nm_usuario_p text, dt_atualizacao_nrec_p timestamp, nm_usuario_nrec_p text, cd_service_exp_p bigint, ds_service_exp_p text) FROM PUBLIC;

