-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_receber_notificacao_benef ( nr_seq_notific_pagador_p bigint, nr_seq_segurado_p bigint, dt_recebimento_p timestamp, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


ds_erro_w			varchar(255) := '';
dt_envio_lote_w			timestamp;
dt_limite_recebimento_w		timestamp;


BEGIN
select	max(dt_envio),
	max(dt_limite_recebimento)
into STRICT	dt_envio_lote_w,
	dt_limite_recebimento_w
from	pls_notificacao_pagador	a,
	pls_notificacao_lote	b
where	b.nr_sequencia	= a.nr_seq_lote
and	a.nr_sequencia	= nr_seq_notific_pagador_p;

if (dt_limite_recebimento_w IS NOT NULL AND dt_limite_recebimento_w::text <> '') and (clock_timestamp() > dt_limite_recebimento_w) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(181996);
end if;

if (coalesce(dt_envio_lote_w::text, '') = '') then
	ds_erro_w	:= ds_erro_w	|| nr_seq_notific_pagador_p;
else
	insert into pls_notif_pag_seg(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_notific_pag,
		nr_seq_segurado,
		dt_recebimento_notif)
	values (nextval('pls_notif_pag_seg_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_notific_pagador_p,
		nr_seq_segurado_p,
		dt_recebimento_p);
end if;

ds_erro_p	:= ds_erro_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_receber_notificacao_benef ( nr_seq_notific_pagador_p bigint, nr_seq_segurado_p bigint, dt_recebimento_p timestamp, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
