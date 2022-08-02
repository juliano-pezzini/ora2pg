-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desvincular_pag_lote_notif ( nr_seq_lote_p bigint, nr_seq_notific_pag_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_titulos_w			varchar(500)	:= null;
ds_titulo_aux_w			varchar(10)	:= null;
nr_seq_pagador_w		bigint;

C01 CURSOR FOR
	SELECT	to_char(nr_titulo)
	from	pls_notificacao_item
	where	nr_seq_notific_pagador	= nr_seq_notific_pag_p;


BEGIN
open C01;
loop
fetch C01 into
	ds_titulo_aux_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (length(ds_titulos_w || ', ' || ds_titulo_aux_w) < 500) then
		ds_titulos_w	:= ds_titulos_w	|| ds_titulo_aux_w || ', ';
	end if;
	end;
end loop;
close C01;

select	max(nr_seq_pagador)
into STRICT	nr_seq_pagador_w
from	pls_notificacao_pagador
where	nr_sequencia	= nr_seq_notific_pag_p;

delete	from pls_notificacao_item
where	nr_seq_notific_pagador	= nr_seq_notific_pag_p;

delete	from pls_notificacao_pagador
where	nr_seq_lote	= nr_seq_lote_p
and	nr_sequencia	= nr_seq_notific_pag_p;

insert into pls_notificacao_lote_log(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_lote,
	nr_seq_pagador_exc,
	ds_log)
values (nextval('pls_notificacao_lote_log_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_lote_p,
	nr_seq_pagador_w,
	'Excluido o pagador ' || nr_seq_pagador_w || ' - ' || pls_obter_dados_pagador(nr_seq_pagador_w,'N') || ' e os títulos: ' || substr(ds_titulos_w,1,length(ds_titulos_w)-2));

CALL pls_atualizar_valor_notific(nr_seq_lote_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desvincular_pag_lote_notif ( nr_seq_lote_p bigint, nr_seq_notific_pag_p bigint, nm_usuario_p text) FROM PUBLIC;

