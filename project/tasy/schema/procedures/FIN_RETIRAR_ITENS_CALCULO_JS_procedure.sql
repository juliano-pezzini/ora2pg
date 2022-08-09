-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fin_retirar_itens_calculo_js ( nr_seq_retorno_p bigint, tp_item_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(nr_seq_retorno_p,0) <> 0 and
	coalesce(tp_item_p, 0) <> 0) then

	update	convenio_retorno_movto
	set	ie_gera_resumo	= 'N',
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_seq_retorno	= nr_seq_retorno_p
	and	tp_item		= tp_item_p;

	commit;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fin_retirar_itens_calculo_js ( nr_seq_retorno_p bigint, tp_item_p bigint, nm_usuario_p text) FROM PUBLIC;
