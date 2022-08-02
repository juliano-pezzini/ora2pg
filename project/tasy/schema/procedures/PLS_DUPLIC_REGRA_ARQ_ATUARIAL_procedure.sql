-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_duplic_regra_arq_atuarial ( nr_seq_regra_p pls_atuarial_arq_regra.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_regra_nova_p INOUT pls_atuarial_arq_regra.nr_sequencia%type) AS $body$
BEGIN

nr_seq_regra_nova_p := pls_dados_atuariais_pck.duplicar_regra_arq(	nr_seq_regra_p, nm_usuario_p, nr_seq_regra_nova_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_duplic_regra_arq_atuarial ( nr_seq_regra_p pls_atuarial_arq_regra.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_regra_nova_p INOUT pls_atuarial_arq_regra.nr_sequencia%type) FROM PUBLIC;

