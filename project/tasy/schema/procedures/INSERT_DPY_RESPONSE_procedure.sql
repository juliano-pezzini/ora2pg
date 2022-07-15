-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_dpy_response ( nr_seq_request_p bigint, nm_bank_account_p text, cd_bank_account_p text, cd_bsb_p bigint, vl_deposit_p bigint, dt_payment_p timestamp, nr_payment_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert 	into 	dpy_response(
		cd_bank_account,
		cd_bsb,
		dt_atualizacao,
		dt_atualizacao_nrec,
		dt_payment,
		nm_bank_account,
		nm_usuario,
		nm_usuario_nrec,
		nr_payment,
		nr_seq_request,
		nr_sequencia,
		vl_deposit)
values (	cd_bank_account_p,
		cd_bsb_p,
		clock_timestamp(),
		clock_timestamp(),
		dt_payment_p,
		nm_bank_account_p,
		nm_usuario_p,
		nm_usuario_p,
		nr_payment_p,
		nr_seq_request_p,
		nextval('dpy_response_seq'),
		vl_deposit_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_dpy_response ( nr_seq_request_p bigint, nm_bank_account_p text, cd_bank_account_p text, cd_bsb_p bigint, vl_deposit_p bigint, dt_payment_p timestamp, nr_payment_p bigint, nm_usuario_p text) FROM PUBLIC;

