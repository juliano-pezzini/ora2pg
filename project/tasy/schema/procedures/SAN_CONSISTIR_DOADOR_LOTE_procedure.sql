-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_consistir_doador_lote ( nr_seq_fim_prod_dia_p bigint, nr_seq_lote_fim_dia_p bigint, ie_opcao_p text, nm_usuario_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE


/*
I - Inserir
R - Remover
*/
BEGIN

if (nr_seq_fim_prod_dia_p IS NOT NULL AND nr_seq_fim_prod_dia_p::text <> '') then

	if (ie_opcao_p = 'I') and (nr_seq_lote_fim_dia_p IS NOT NULL AND nr_seq_lote_fim_dia_p::text <> '') then
		update	san_fim_prod_dia
		set	nr_seq_lote 	= nr_seq_lote_fim_dia_p,
			nm_usuario 	= nm_usuario_p,
			dt_atualizacao 	= clock_timestamp()
		where	nr_sequencia = nr_seq_fim_prod_dia_p
		and	coalesce(nr_seq_lote::text, '') = '';
	elsif (ie_opcao_p = 'R') then
		update	san_fim_prod_dia
		set	nr_seq_lote 	 = NULL,
			nm_usuario 	= nm_usuario_p,
			dt_atualizacao 	= clock_timestamp()
		where	nr_sequencia = nr_seq_fim_prod_dia_p
		and	(nr_seq_lote IS NOT NULL AND nr_seq_lote::text <> '');
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_consistir_doador_lote ( nr_seq_fim_prod_dia_p bigint, nr_seq_lote_fim_dia_p bigint, ie_opcao_p text, nm_usuario_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

