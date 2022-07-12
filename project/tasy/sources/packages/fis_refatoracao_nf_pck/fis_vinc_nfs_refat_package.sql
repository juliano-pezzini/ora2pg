-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE fis_refatoracao_nf_pck.fis_vinc_nfs_refat ( nr_seq_nf_new_p nota_fiscal.nr_sequencia%type, nr_seq_baixa_new_p titulo_receber_liq.nr_sequencia%type, nr_seq_refat_nf_p bigint, ie_tipo_nf_p text) AS $body$
DECLARE


/*
1 - Nota fiscal principal - fis_refatoracao_nf
2 - Nota fiscal adiantamento
3 - Nota fiscal credito
4 - Nota fiscal baixa de titulo
*/
				

BEGIN

if (ie_tipo_nf_p = '1') then
	
	update	fis_refatoracao_nf
	set	nr_seq_nf_princ_new = nr_seq_nf_new_p
	where	nr_sequencia = nr_seq_refat_nf_p;
	
elsif (ie_tipo_nf_p = '2') then
	
	update	fis_refatoracao_nf_adian
	set	nr_seq_nf_adiant_new = nr_seq_nf_new_p
	where	nr_sequencia = nr_seq_refat_nf_p;

elsif (ie_tipo_nf_p = '3') then

	update	fis_refatoracao_nf_cred
	set	nr_seq_nf_cred_new = nr_seq_nf_new_p
	where	nr_sequencia = nr_seq_refat_nf_p;
	
elsif (ie_tipo_nf_p = '4') then

	update	fis_refatoracao_nf_bai_tit
	set	nr_seq_nf_baixa_tit_new = nr_seq_nf_new_p,
		nr_seq_baixa_new = nr_seq_baixa_new_p
	where	nr_sequencia = nr_seq_refat_nf_p;
	
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_refatoracao_nf_pck.fis_vinc_nfs_refat ( nr_seq_nf_new_p nota_fiscal.nr_sequencia%type, nr_seq_baixa_new_p titulo_receber_liq.nr_sequencia%type, nr_seq_refat_nf_p bigint, ie_tipo_nf_p text) FROM PUBLIC;