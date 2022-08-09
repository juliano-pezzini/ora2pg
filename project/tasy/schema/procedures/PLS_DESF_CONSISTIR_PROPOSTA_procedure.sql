-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desf_consistir_proposta ( nr_seq_proposta_p bigint, nm_usuario_p text) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_proposta_beneficiario
	where	nr_seq_proposta	= nr_seq_proposta_p;

nr_seq_beneficiario_w		pls_proposta_beneficiario.nr_sequencia%type;


BEGIN

update	pls_proposta_adesao
set	ie_status	= 'U',
	ie_inconsistencia = 'N',
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_seq_proposta_p
and	ie_status	= 'C';

--aaschlote 02/05/2011 OS - 314422 - Gerar historico para o beneficiário
open C01;
loop
fetch C01 into
	nr_seq_beneficiario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	CALL pls_gravar_histor_prop_benef(nr_seq_beneficiario_w,clock_timestamp(),'2','Desfeito a consistência da proposta de adesão',nm_usuario_p);
	end;
end loop;
close C01;

-- Excluir inconsistências de documento
delete	from	pls_proposta_inconsist_doc
where	nr_seq_proposta	= nr_seq_proposta_p;

-- Excluir inconsistências
delete	from	pls_proposta_check_list a
where	exists (SELECT	1
		from	pls_proposta_validacao x
		where	x.nr_sequencia	= a.nr_seq_validacao
		and	x.nr_seq_proposta = nr_seq_proposta_p);

delete	from	pls_proposta_validacao
where	nr_seq_proposta = nr_seq_proposta_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desf_consistir_proposta ( nr_seq_proposta_p bigint, nm_usuario_p text) FROM PUBLIC;
