-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_definir_tabela_padrao ( nr_seq_regra_simulador_web_p pls_regra_simulador_web.nr_sequencia%type, nr_seq_plano_p pls_plano.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

update	pls_regra_simulador_web
set	ie_tabela_padrao = 'S'
where	nr_sequencia     = nr_seq_regra_simulador_web_p;

update	pls_regra_simulador_web
set	ie_tabela_padrao = 'N'
where	nr_seq_plano	 = nr_seq_plano_p
and	nr_sequencia	 <> nr_seq_regra_simulador_web_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_definir_tabela_padrao ( nr_seq_regra_simulador_web_p pls_regra_simulador_web.nr_sequencia%type, nr_seq_plano_p pls_plano.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

