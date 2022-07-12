-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE fis_refatoracao_nf_pck.fis_alt_sit_nf_refat ( nr_seq_nota_fiscal_p nota_fiscal.nr_sequencia%type, ie_tipo_situacao_p text) AS $body$
BEGIN

CALL fis_refatoracao_nf_pck.fis_alt_sit_nota_fiscal(	nr_seq_nota_fiscal_p, ie_tipo_situacao_p);

CALL fis_refatoracao_nf_pck.fis_alt_sit_nf_adiant(ie_tipo_situacao_p);

CALL fis_refatoracao_nf_pck.fis_alt_sit_nf_credito(ie_tipo_situacao_p);

CALL fis_refatoracao_nf_pck.fis_alt_sit_nf_baixa_tit(ie_tipo_situacao_p);


commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_refatoracao_nf_pck.fis_alt_sit_nf_refat ( nr_seq_nota_fiscal_p nota_fiscal.nr_sequencia%type, ie_tipo_situacao_p text) FROM PUBLIC;