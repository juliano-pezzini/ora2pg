-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_imc_claim_exp_response ( nr_seq_transaction_p imc_claim_exp.nr_seq_response%type, cd_claim_exp_p imc_claim_exp.cd_claim_exp%type, ds_claim_exp_p imc_claim_exp.ds_claim_exp%type, cd_claim_exp_sub_p imc_claim_exp.cd_claim_exp_sub%type, nm_usuario_p imc_claim.nm_usuario%type) AS $body$
DECLARE

										
nr_Seq_response_w	imc_response.nr_sequencia%type;
nr_seq_w			imc_claim_exp.nr_Sequencia%type;


BEGIN


select	max(nr_Sequencia)
into STRICT	nr_Seq_response_w
from	imc_response
where	cd_transaction = nr_seq_transaction_p;

select	nextval('imc_claim_exp_seq')
into STRICT	nr_seq_w
;

insert into imc_claim_exp(
							nm_usuario,
							dt_atualizacao,
							nr_seq_response,
							nr_sequencia,
							cd_claim_exp,
							cd_claim_exp_sub,
							nm_usuario_nrec,
							ds_claim_exp,
							dt_atualizacao_nrec)
			values (
							nm_usuario_p,
							clock_timestamp(),
							nr_seq_response_w,
							nr_seq_w,
							cd_claim_exp_p,
							cd_claim_exp_sub_p,
							nm_usuario_p,
							ds_claim_exp_p,
							clock_timestamp());

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_imc_claim_exp_response ( nr_seq_transaction_p imc_claim_exp.nr_seq_response%type, cd_claim_exp_p imc_claim_exp.cd_claim_exp%type, ds_claim_exp_p imc_claim_exp.ds_claim_exp%type, cd_claim_exp_sub_p imc_claim_exp.cd_claim_exp_sub%type, nm_usuario_p imc_claim.nm_usuario%type) FROM PUBLIC;
