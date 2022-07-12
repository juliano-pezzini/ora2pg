-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_notif_cobr ( nr_seq_cobranca_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255)	:= null;
nr_seq_lote_w			bigint;
dt_recebimento_notif_w		timestamp;
nr_seq_notif_pagador_w		bigint;
nr_titulo_w			bigint;


BEGIN

if (nr_seq_cobranca_p IS NOT NULL AND nr_seq_cobranca_p::text <> '') then
	select	max(a.nr_titulo)
	into STRICT	nr_titulo_w
	from	cobranca a
	where	a.nr_sequencia	= nr_seq_cobranca_p;

	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then

		select	max(a.nr_sequencia)
		into STRICT	nr_seq_lote_w
		from	pls_notificacao_lote a
		where	(a.dt_envio IS NOT NULL AND a.dt_envio::text <> '')
		and	exists (SELECT	1
				from	pls_notificacao_item x,
					pls_notificacao_pagador y
				where	x.nr_seq_notific_pagador	= y.nr_sequencia
				and	y.nr_seq_lote			= a.nr_sequencia
				and	x.nr_titulo			= nr_titulo_w);

		/* Obter o último lote de notificação enviado */

		if (ie_opcao_p = 'L') then
			ds_retorno_w	:= nr_seq_lote_w;
		/* Obter o pagador no lote de notificação */

		elsif (ie_opcao_p = 'P') then
			if (nr_seq_lote_w IS NOT NULL AND nr_seq_lote_w::text <> '') then
				select	max(b.nr_sequencia)
				into STRICT	nr_seq_notif_pagador_w
				from	pls_notificacao_item a,
					pls_notificacao_pagador b
				where	a.nr_seq_notific_pagador = b.nr_sequencia
				and	b.nr_seq_lote		 = nr_seq_lote_w
				and	a.nr_titulo		 = nr_titulo_w;

				ds_retorno_w	:= nr_seq_notif_pagador_w;
			end if;
		/* Obter se a notificação do título (no último lote) foi recebida ou não */

		elsif (ie_opcao_p = 'RN') then
			if (nr_seq_lote_w IS NOT NULL AND nr_seq_lote_w::text <> '') then
				select	max(b.dt_recebimento_notif)
				into STRICT	dt_recebimento_notif_w
				from	pls_notificacao_item a,
					pls_notificacao_pagador b
				where	a.nr_seq_notific_pagador = b.nr_sequencia
				and	b.nr_seq_lote		 = nr_seq_lote_w
				and	a.nr_titulo		 = nr_titulo_w;

				if (dt_recebimento_notif_w IS NOT NULL AND dt_recebimento_notif_w::text <> '') then
					ds_retorno_w	:= 'S';
				else
					ds_retorno_w	:= 'N';
				end if;
			end if;
		end if;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_notif_cobr ( nr_seq_cobranca_p bigint, ie_opcao_p text) FROM PUBLIC;

