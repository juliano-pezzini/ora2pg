-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_sib_dev_cco_xml ( nr_seq_lote_sib_p bigint, cd_usuario_plano_p text, nm_beneficiario_p text, nr_cco_p text, nm_usuario_p text) AS $body$
BEGIN

insert into sib_devolucao_cco(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
		nr_seq_lote,cd_usuario_plano,nm_beneficiario,nr_cco,ie_digito_cco,ie_xml)
values (	nextval('sib_devolucao_cco_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
		nr_seq_lote_sib_p,cd_usuario_plano_p,nm_beneficiario_p,substr(nr_cco_p,1,10),substr(nr_cco_p,11,2),'S');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inserir_sib_dev_cco_xml ( nr_seq_lote_sib_p bigint, cd_usuario_plano_p text, nm_beneficiario_p text, nr_cco_p text, nm_usuario_p text) FROM PUBLIC;

