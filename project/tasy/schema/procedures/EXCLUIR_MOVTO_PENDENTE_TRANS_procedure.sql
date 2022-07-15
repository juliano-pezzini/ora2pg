-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_movto_pendente_trans ( nr_movimento_estoque_p bigint, nm_usuario_p text) AS $body$
BEGIN
update	w_protheus_movto_estoque
set	ie_status = 'X',
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp(),
	ds_observacao = ds_observacao || ' ' || wheb_mensagem_pck.get_texto(325649)
where   nr_movimento_estoque = nr_movimento_estoque_p
and	ie_status <> 'X';

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_movto_pendente_trans ( nr_movimento_estoque_p bigint, nm_usuario_p text) FROM PUBLIC;

