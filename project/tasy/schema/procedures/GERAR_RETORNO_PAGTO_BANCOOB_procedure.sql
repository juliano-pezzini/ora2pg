-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_retorno_pagto_bancoob (nr_seq_banco_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/* 
Estrutura: 
 
Header de arquivo 
Detalhe 
Trailler de arquivo 
 
*/
 
 
ds_nr_titulo_w		varchar(15);
ds_vl_pagamento_w	varchar(15);
ds_ocorrencia_w		varchar(10);
nr_titulo_w		bigint;
cd_tipo_baixa_w		bigint;
nr_seq_trans_escrit_w	bigint;
nr_seq_conta_banco_w	bigint;
nr_sequencia_w		bigint;
vl_pagamento_w		double precision;
cd_estabelecimento_w	bigint;
qt_titulo_w		bigint;
dt_baixa_w		timestamp;

/* registro transação */
 
c01 CURSOR FOR 
SELECT	substr(ds_conteudo,63,11) ds_nr_titulo, 
	substr(ds_conteudo,153,13) ds_vl_pagamento, 
	substr(ds_conteudo,81,2) ds_ocorrencia, 
	to_date(substr(ds_conteudo,111,8),'yyyy/mm/dd') dt_baixa 
from	w_interf_retorno_itau 
where	substr(ds_conteudo, 1, 1)	= '1' 
and	nr_seq_banco_escrit		= nr_seq_banco_escrit_p 
order	by nr_sequencia;


BEGIN 
 
select	max(a.cd_estabelecimento), 
	max(a.nr_seq_conta_banco) 
into STRICT	cd_estabelecimento_w, 
	nr_seq_conta_banco_w 
from	banco_escritural a 
where	a.nr_sequencia		= nr_seq_banco_escrit_p;
 
select	max(nr_seq_trans_escrit) 
into STRICT	nr_seq_trans_escrit_w 
from	parametro_tesouraria 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
select	coalesce(max(cd_tipo_baixa_padrao),1) 
into STRICT	cd_tipo_baixa_w 
from	parametros_contas_pagar 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
open c01;
loop 
fetch c01 into 
	ds_nr_titulo_w, 
	ds_vl_pagamento_w, 
	ds_ocorrencia_w, 
	dt_baixa_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
	begin 
 
	select	max(a.nr_titulo) 
	into STRICT	nr_titulo_w 
	from	titulo_pagar a 
	where	a.nr_titulo	= (ds_nr_titulo_w)::numeric;
 
	if (coalesce(nr_titulo_w::text, '') = '') then 
		--r.aise_application_error(-20011,'O título ' || ds_nr_titulo_w || ' não existe no sistema!'); 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(267387,'ds_nr_titulo_w='||ds_nr_titulo_w);
	end if;
 
	vl_pagamento_w		:= (ds_vl_pagamento_w)::numeric;
	vl_pagamento_w		:= dividir_sem_round((vl_pagamento_w)::numeric,100);
 
	select	count(*) 
	into STRICT	qt_titulo_w 
	from	titulo_pagar_escrit a 
	where	a.nr_titulo	= nr_titulo_w 
	and	a.nr_seq_escrit	= nr_seq_banco_escrit_p;
 
	if (qt_titulo_w = 0) then 
		CALL Gerar_Titulo_Escritural(nr_titulo_w,nr_seq_banco_escrit_p,nm_usuario_p);
	end if;
 
	update	titulo_pagar_escrit 
	set	cd_ocorrencia_ret	= ds_ocorrencia_w 
	where	nr_seq_escrit		= nr_seq_banco_escrit_p 
	and	nr_titulo		= nr_titulo_w;
 
	/* se tiver alguma das ocorrências de liquidação, baixa o título */
 
	if (position('BW' in ds_ocorrencia_w) > 0) then 
 
		RAISE NOTICE 'nr_titulo_w = %', nr_titulo_w;
 
		CALL baixa_titulo_pagar(cd_estabelecimento_w, 
				cd_tipo_baixa_w, 
				nr_titulo_w, 
				vl_pagamento_w, 
				nm_usuario_p, 
				nr_seq_trans_escrit_w, 
				null, 
				nr_seq_banco_escrit_p, 
				coalesce(dt_baixa_w,clock_timestamp()), 
				nr_seq_conta_banco_w);
 
		select	max(nr_sequencia) 
		into STRICT	nr_sequencia_w 
		from	titulo_pagar_baixa 
		where	nr_titulo	= nr_titulo_w;
 
		CALL gerar_movto_tit_baixa(nr_titulo_w, 
				nr_sequencia_w, 
				'P', 
				nm_usuario_p, 
				'N');
 
		CALL atualizar_saldo_tit_pagar(nr_titulo_w, nm_usuario_p);
		CALL Gerar_W_Tit_Pag_imposto(nr_titulo_w, nm_usuario_p);
 
	end if;
 
	exception 
	when others then 
		rollback;
		delete	from w_interf_retorno_itau 
		where	nr_seq_banco_escrit	= nr_seq_banco_escrit_p;
		commit;
		/*r.aise_application_error(-20011, sqlerrm || chr(13) || chr(10) || 
					'nr_titulo_w = ' || nr_titulo_w || chr(13) || chr(10) || 
					'ds_nr_titulo_w = ' || ds_nr_titulo_w || chr(13) || chr(10) || 
					'ds_vl_pagamento_w = ' || ds_vl_pagamento_w || chr(13) || chr(10) || 
					'ds_ocorrencia_w = ' || ds_ocorrencia_w);*/
 
					 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(267392,	'nr_titulo_w=' || nr_titulo_w || ';' || 
								'ds_nr_titulo_w=' || ds_nr_titulo_w || ';' || 
								'ds_vl_pagamento_w=' || ds_vl_pagamento_w || ';' || 
								'ds_ocorrencia_w=' || ds_ocorrencia_w);			
	end;
end loop;
close c01;
 
delete	from w_interf_retorno_itau 
where	nr_seq_banco_escrit	= nr_seq_banco_escrit_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_retorno_pagto_bancoob (nr_seq_banco_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;

