-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dc_save_ihc_fund_expla ( nr_invoice_id_p bigint, nr_claim_id_p text, nm_usuario_p text, ds_claim_fund_explanation_p text, cd_claim_fund_explanation_p text) AS $body$
DECLARE

  nr_interno_conta_w bigint;
  ie_exists_response_w  smallint;


BEGIN

select  coalesce(max(1),0)
into STRICT    ie_exists_response_w
from    era_response
where   invoice_id = nr_invoice_id_p
and     nr_claim_id = nr_claim_id_p;



if (ie_exists_response_w = 0) then

  insert  into dc_ihc_fund_expla(
      nr_sequencia,
      dt_atualizacao,
      nm_usuario,
      dt_atualizacao_nrec,
      nm_usuario_nrec,
      nr_invoice_id,
      nr_claim_id,
      ds_claim_fund_explanation,
      cd_claim_fund_explanation
    )
    values (
      nextval('dc_ihc_fund_expla_seq'),
      clock_timestamp(),
      nm_usuario_p,
      clock_timestamp(),
      nm_usuario_p,
      nr_invoice_id_p,
      nr_claim_id_p,
      ds_claim_fund_explanation_p,
      cd_claim_fund_explanation_p
    );
  commit;

end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dc_save_ihc_fund_expla ( nr_invoice_id_p bigint, nr_claim_id_p text, nm_usuario_p text, ds_claim_fund_explanation_p text, cd_claim_fund_explanation_p text) FROM PUBLIC;

