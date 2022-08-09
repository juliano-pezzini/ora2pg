-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_reg_aux ( nr_seq_reg_aux_p bigint, qt_registros_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(qt_registros_p,0) > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(799330);
end if;

delete	FROM ctb_livro_auxiliar
where	nr_sequencia	= nr_seq_reg_aux_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_reg_aux ( nr_seq_reg_aux_p bigint, qt_registros_p bigint, nm_usuario_p text) FROM PUBLIC;
