-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE pls_regra_via_acesso_pck.pls_desmembra_proc ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) AS $body$
DECLARE
	
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Rotina responsavel por percorrer a tabela temporaria e desmembrar os procedimentos presentes na mesma.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
		
C01 CURSOR FOR
	SELECT	nr_seq_conta_proc
	from	pls_aux_guia_ref;

BEGIN

for r_C01_w in C01 loop		
	--Rotina responsavel por desmembrar os procedimentos da conta, ou seja, caso um procedimento possua qt. apresentada = 5, esta rotina ira criar 5 registros com quantidade apresentada 1.
	CALL pls_util_cta_pck.pls_abrir_procedimento(r_C01_w.nr_seq_conta_proc, nm_usuario_p, cd_estabelecimento_p);
	
	commit;
end loop;							

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_regra_via_acesso_pck.pls_desmembra_proc ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) FROM PUBLIC;
