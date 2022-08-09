-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_limite_notif_tel ( nr_seq_lote_p bigint) AS $body$
DECLARE


dt_limite_notif_tel_w	pls_notificacao_lote.dt_limite_notif_tel%type;


BEGIN

select	max(dt_limite_notif_tel)
into STRICT	dt_limite_notif_tel_w
from	pls_notificacao_lote
where	nr_sequencia	= nr_seq_lote_p;

if (dt_limite_notif_tel_w IS NOT NULL AND dt_limite_notif_tel_w::text <> '') and (trunc(clock_timestamp(),'dd') > trunc(dt_limite_notif_tel_w,'dd')) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(188968);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_limite_notif_tel ( nr_seq_lote_p bigint) FROM PUBLIC;
