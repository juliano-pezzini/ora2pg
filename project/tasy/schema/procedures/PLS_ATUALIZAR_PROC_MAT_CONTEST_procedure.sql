-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_proc_mat_contest (nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, nr_seq_material_p pls_material.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


cd_procedimento_w		procedimento.cd_procedimento%type;
ie_origem_proced_w		procedimento.ie_origem_proced%type;
nr_seq_conta_proc_w		pls_conta_proc.nr_sequencia%type;
nr_seq_conta_mat_w		pls_conta_mat.nr_sequencia%type;
cd_material_w			pls_material.cd_material%type;


BEGIN
if	(nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '' AND cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	update	pls_conta_proc
	set	cd_procedimento 	= cd_procedimento_p,
		ie_origem_proced	= ie_origem_proced_p,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia 		= nr_seq_conta_proc_p;
elsif 	(nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '' AND nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then
	update	pls_conta_mat
	set	nr_seq_material		= nr_seq_material_p,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia 		= nr_seq_conta_mat_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_proc_mat_contest (nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, nr_seq_material_p pls_material.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
