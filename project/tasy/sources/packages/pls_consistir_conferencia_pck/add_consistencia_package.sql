-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_consistir_conferencia_pck.add_consistencia ( nr_seq_conferencia_p pls_sib_conferencia.nr_sequencia%type, cd_divergencia_p pls_sib_divergencia_conf.cd_divergencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

nr_seq_sib_divergencia_conf_w	pls_sib_divergencia_conf.nr_sequencia%type;

BEGIN
nr_seq_sib_divergencia_conf_w	:= pls_consistir_conferencia_pck.obter_seq_divergencia(cd_divergencia_p);

if (nr_seq_sib_divergencia_conf_w > 0) then
	current_setting('pls_consistir_conferencia_pck.tb_nr_seq_conferencia_w')::pls_util_cta_pck.t_number_table(current_setting('pls_consistir_conferencia_pck.indice_w')::bigint) := nr_seq_conferencia_p;
	current_setting('pls_consistir_conferencia_pck.tb_nr_seq_divergencia_w')::pls_util_cta_pck.t_number_table(current_setting('pls_consistir_conferencia_pck.indice_w')::bigint) := nr_seq_sib_divergencia_conf_w;
	CALL pls_consistir_conferencia_pck.inserir_divergencia('N', nm_usuario_p);
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_conferencia_pck.add_consistencia ( nr_seq_conferencia_p pls_sib_conferencia.nr_sequencia%type, cd_divergencia_p pls_sib_divergencia_conf.cd_divergencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
