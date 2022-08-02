-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_taxa_prog_reaj ( nr_seq_prog_reajuste_p bigint, tx_copartic_p text, tx_copartic_max_p text, tx_inscricao_p text, nm_usuario_p text) AS $body$
BEGIN

begin
update	pls_prog_reaj_coletivo
set	tx_reajuste_copartic	= coalesce(tx_copartic_p,0),
	tx_reajuste_copartic_max= coalesce(tx_copartic_max_p,0),
	tx_reajuste_inscricao	= coalesce(tx_inscricao_p,0)
where	nr_sequencia		= nr_seq_prog_reajuste_p
and	ie_status		<> 'L';
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 182013, null );
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_taxa_prog_reaj ( nr_seq_prog_reajuste_p bigint, tx_copartic_p text, tx_copartic_max_p text, tx_inscricao_p text, nm_usuario_p text) FROM PUBLIC;

