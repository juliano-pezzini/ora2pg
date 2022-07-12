-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--fis_gravar_nfs_credito
CREATE OR REPLACE PROCEDURE fis_refatoracao_nf_pck.fis_gravar_nfs_credito ( nr_seq_nf_origem_p nota_fiscal.nr_sequencia%type, nm_usuario_p text) AS $body$
BEGIN

forall i in current_setting('fis_refatoracao_nf_pck.fis_refatoracao_nf_cred_w')::reg_refatoracao_nf_cred.first .. current_setting('fis_refatoracao_nf_pck.fis_refatoracao_nf_cred_w')::reg_refatoracao_nf_cred.last
	insert into fis_refatoracao_nf_cred values current_setting('fis_refatoracao_nf_pck.fis_refatoracao_nf_cred_w')::reg_refatoracao_nf_cred(i);

/*Limpa o array*/

current_setting('fis_refatoracao_nf_pck.fis_refatoracao_nf_cred_w')::reg_refatoracao_nf_cred.delete;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_refatoracao_nf_pck.fis_gravar_nfs_credito ( nr_seq_nf_origem_p nota_fiscal.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;