-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dt_parcelas_vencidas ( nr_titulo_p bigint) RETURNS varchar AS $body$
DECLARE


dt_vencimento_w		timestamp;
ds_data_w		varchar(10);
ds_parcelas_venc_w	varchar(500);

C01 CURSOR FOR
	SELECT	distinct a.dt_vencimento
	from	titulo_receber	a,
		pls_mensalidade	b
	where	a.nr_seq_mensalidade = b.nr_sequencia
	and	a.nr_titulo <> nr_titulo_p
	and	coalesce(a.dt_liquidacao::text, '') = ''
	and (a.dt_pagamento_previsto + 6) < clock_timestamp()
	and	b.nr_seq_pagador = (	SELECT	x.nr_seq_pagador
					from	titulo_receber	y,
						pls_mensalidade	x
					where	x.nr_sequencia = y.nr_seq_mensalidade
					and	y.nr_titulo = nr_titulo_p)
	order by a.dt_vencimento;


BEGIN

ds_parcelas_venc_w	:=	null;

open C01;
loop
fetch C01 into
	dt_vencimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_data_w := to_char(dt_vencimento_w, 'mm/yyyy');

	ds_parcelas_venc_w := ds_parcelas_venc_w || ds_data_w || ', ';
	end;
end loop;
close C01;

if (ds_parcelas_venc_w IS NOT NULL AND ds_parcelas_venc_w::text <> '') then
	ds_parcelas_venc_w 	:= 	'ATENÇÃO: EM ' || substr(to_date(clock_timestamp(),'dd/mm/yyyy'),1,11) || ' NÃO CONSTA(M) EM NOSSOS ARQUIVOS O(S) PAGAMENTOS DA(S) MENSALIDADES COM VENCIMENTO EM ' || substr(ds_parcelas_venc_w, 1, (length(ds_parcelas_venc_w) - 2)) || '. CASO AS MENSALIDADES ACIMA TENHAM SIDO QUITADAS, POR FAVOR DESCONSIDERAR ESTA MENSAGEM.' || chr(13) ||
					'LEMBRAMOS QUE SE HOUVER ATRASO NO PAGAMENTO DA MENSALIDADE, SUPERIOR A 60 DIAS CONSECUTIVOS OU NÃO, NOS ÚLTIMOS 12 MESES, O CONTRATO PODERÁ SER RESCINDIDO CONFORME ARTIGO 13, INCISO II DA LEI 9656/98';
end if;

return	ds_parcelas_venc_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dt_parcelas_vencidas ( nr_titulo_p bigint) FROM PUBLIC;

