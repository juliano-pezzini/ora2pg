-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_devolver_notificacao ( nr_seq_notificacao_p bigint, nr_seq_motivo_p bigint, dt_entrega_p timestamp, nm_entregador_p text, ie_tipo_notificacao_p text, ie_atualiza_notif_pag_p text, nm_usuario_p text) AS $body$
DECLARE


ie_status_w			pls_notificacao_pagador.ie_status%type;


BEGIN
insert into pls_notificacao_devolucao(nr_sequencia,
	nr_seq_notificacao,
	dt_devolucao,
	dt_entrega,
	nr_seq_tipo_devolucao,
	nm_entregador,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ie_tipo_notificacao)
values (nextval('pls_notificacao_devolucao_seq'),
	nr_seq_notificacao_p,
	clock_timestamp(),
	dt_entrega_p,
	nr_seq_motivo_p,
	nm_entregador_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	ie_tipo_notificacao_p);

select	ie_status
into STRICT 	ie_status_w
from 	pls_notificacao_pagador
where	nr_sequencia	= nr_seq_notificacao_p;

if (ie_atualiza_notif_pag_p = 'S') and (ie_status_w <> 'D') then
	update	pls_notificacao_pagador
	set	ie_status_ant 	= ie_status,
		ie_status	= 'D',
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_notificacao_p;
end if;

--Utilizado no HTML5
CALL pls_excluir_barras_pag_notific(nr_seq_notificacao_p,nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_devolver_notificacao ( nr_seq_notificacao_p bigint, nr_seq_motivo_p bigint, dt_entrega_p timestamp, nm_entregador_p text, ie_tipo_notificacao_p text, ie_atualiza_notif_pag_p text, nm_usuario_p text) FROM PUBLIC;

