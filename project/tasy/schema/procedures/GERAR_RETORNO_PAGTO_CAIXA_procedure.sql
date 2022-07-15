-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_retorno_pagto_caixa (nr_seq_banco_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_nr_titulo_w		varchar(255);
ds_dt_pagamento_w	varchar(255);
ds_vl_pagamento_w	varchar(255);
ds_nr_documento_w	varchar(255);
ds_ocorrencia_w		varchar(255);

cd_reg_favorecido_w	varchar(50);
cd_conf_envio_w		varchar(50);
cd_retorno_liq_w	varchar(50);

nr_titulo_w		bigint;
cd_tipo_baixa_w		bigint;
nr_seq_trans_escrit_w	bigint;
nr_seq_conta_banco_w	bigint;
nr_sequencia_w		bigint;
dt_pagamento_w		timestamp;
vl_pagamento_w		double precision;
nr_documento_w		varchar(255);
ds_forma_pagto_w	varchar(50);

cd_estabelecimento_w	bigint;
nr_sequencia_inicial_w	bigint;
nr_sequencia_final_w	bigint;
nr_seq_interf_w		bigint;
vl_saldo_titulo_w	double precision;
vl_imposto_w		double precision;
qt_titulo_w		bigint;
vl_despesa_w		double precision;
vl_acrescimo_w		double precision;
ie_vl_associado_w	varchar(2);
qt_baixa_w		bigint;

ds_vl_real_w		varchar(15);
vl_real_w		double precision;

c01 CURSOR FOR
SELECT	nr_sequencia,
	substr(ds_conteudo,12,2) ds_forma_pagto
from	w_interf_retorno_itau
where	substr(ds_conteudo, 8, 1)	= '1'
and	nr_seq_banco_escrit		= nr_seq_banco_escrit_p
order	by nr_sequencia;

c02 CURSOR FOR
SELECT	nr_sequencia,
	substr(ds_conteudo,74,19) ds_nr_titulo,
	substr(ds_conteudo,155,8) ds_dt_pagamento,
	substr(ds_conteudo,163,15) ds_vl_pagamento,
	substr(ds_conteudo,135,20) ds_nr_documento,
	substr(ds_conteudo,231,2) ds_ocorrencia,
	substr(ds_conteudo,120,15) ds_vl_real
from	w_interf_retorno_itau
where	substr(ds_conteudo, 14, 1)	= 'A'
and	substr(ds_conteudo, 8, 1)	= '3'
and	nr_seq_banco_escrit		= nr_seq_banco_escrit_p
and	ds_forma_pagto_w		in ('01','03','41','07','06','43','05')
and	nr_sequencia			> nr_sequencia_inicial_w
and	nr_sequencia			< nr_sequencia_final_w 		-- pagamento em doc/ted/cc/cp
union

select	nr_sequencia,
	substr(ds_conteudo,183,20) ds_nr_titulo,
	substr(ds_conteudo,145,8) ds_dt_pagamento,
	substr(ds_conteudo,153,15) ds_vl_pagamento,
	'' ds_nr_documento,
	substr(ds_conteudo,231,2) ds_ocorrencia,
	null ds_vl_real
from	w_interf_retorno_itau
where	substr(ds_conteudo, 14, 1)	= 'J'
and substr(ds_conteudo,18,2)  <> '52'
and	substr(ds_conteudo, 8, 1)	= '3'
and	nr_seq_banco_escrit		= nr_seq_banco_escrit_p
and	ds_forma_pagto_w		in ('30','31')
and	nr_sequencia			> nr_sequencia_inicial_w
and	nr_sequencia			< nr_sequencia_final_w 		-- pagamento com bloqueto
union

select	nr_sequencia,
	substr(ds_conteudo,123,20) ds_nr_titulo,
	substr(ds_conteudo,100,8) ds_dt_pagamento,
	substr(ds_conteudo,108,15) ds_vl_pagamento,
	'' ds_nr_documento,
	substr(ds_conteudo,231,2) ds_ocorrencia,
	null ds_vl_real
from	w_interf_retorno_itau
where	substr(ds_conteudo, 14, 1)	= 'O'
and	substr(ds_conteudo, 8, 1)	= '3'
and	nr_seq_banco_escrit		= nr_seq_banco_escrit_p
and	ds_forma_pagto_w		= '11'
and	nr_sequencia			> nr_sequencia_inicial_w
and	nr_sequencia			< nr_sequencia_final_w 		-- pagamento com bloqueto
order	by nr_sequencia;



BEGIN

begin
select	b.cd_reg_favorecido,
	b.cd_conf_envio,
	b.cd_retorno_liq,
	a.cd_estabelecimento,
	a.nr_seq_conta_banco,
	a.nr_seq_trans_financ
into STRICT	cd_reg_favorecido_w,
	cd_conf_envio_w,
	cd_retorno_liq_w,
	cd_estabelecimento_w,
	nr_seq_conta_banco_w,
	nr_seq_trans_escrit_w
from	banco_retorno_cp b,
	banco_escritural a
where	a.cd_banco		= b.cd_banco
and	a.nr_sequencia		= nr_seq_banco_escrit_p;
exception
when others then
	/* Cadastro do retorno de pagamento escritural nao encontrado! Verifica os cadastros financeiros. */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(198870);
end;

if (coalesce(nr_seq_trans_escrit_w::text, '') = '') then

	select	nr_seq_trans_escrit
	into STRICT	nr_seq_trans_escrit_w
	from	parametro_tesouraria
	where	cd_estabelecimento	= cd_estabelecimento_w;

end if;

select	coalesce(cd_tipo_baixa_padrao, 1)
into STRICT	cd_tipo_baixa_w
from	parametros_contas_pagar
where	cd_estabelecimento	= cd_estabelecimento_w;

ie_vl_associado_w := obter_param_usuario(857, 33, Obter_Perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_vl_associado_w);

open c01;
loop
fetch c01 into
	nr_sequencia_inicial_w,
	ds_forma_pagto_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	begin
	select	min(nr_sequencia)
	into STRICT	nr_sequencia_final_w
	from	w_interf_retorno_itau
	where	substr(ds_conteudo, 8, 1)	<> '3'
	and	nr_seq_banco_escrit		= nr_seq_banco_escrit_p
	and	nr_sequencia			> nr_sequencia_inicial_w;

	open c02;
	loop
	fetch c02 into
		nr_seq_interf_w,
		ds_nr_titulo_w,
		ds_dt_pagamento_w,
		ds_vl_pagamento_w,
		ds_nr_documento_w,
		ds_ocorrencia_w,
		ds_vl_real_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		nr_titulo_w		:= (ds_nr_titulo_w)::numeric;

		if (ds_dt_pagamento_w	= '00000000') or (ds_dt_pagamento_w	= '99999999') then
			dt_pagamento_w	:= clock_timestamp();
		else
			dt_pagamento_w	:= to_date(ds_dt_pagamento_w, 'ddmmyyyy');
		end if;

		vl_pagamento_w		:= (ds_vl_pagamento_w)::numeric;
		vl_pagamento_w		:= dividir_sem_round((vl_pagamento_w)::numeric, 100);
		nr_documento_w		:= ds_nr_documento_w;
		vl_real_w		:= somente_numero(ds_vl_real_w) / 100;

		select	count(*)
		into STRICT	qt_titulo_w
		from	titulo_pagar_escrit a
		where	a.nr_titulo	= nr_titulo_w
		and	a.nr_seq_escrit	= nr_seq_banco_escrit_p;

		if (qt_titulo_w	= 0) then

			CALL gerar_titulo_escritural(nr_titulo_w,nr_seq_banco_escrit_p,nm_usuario_p);

		end if;

   		if (cd_reg_favorecido_w = ds_ocorrencia_w) then
			update	titulo_pagar_escrit
			set	ds_erro			= ds_ocorrencia_w
			where	nr_seq_escrit		= nr_seq_banco_escrit_p
			and	nr_titulo		= nr_titulo_w;
		elsif (cd_conf_envio_w = ds_ocorrencia_w) then
			update	titulo_pagar_escrit
			set	ds_erro			= ds_ocorrencia_w
			where	nr_seq_escrit		= nr_seq_banco_escrit_p
			and	nr_titulo		= nr_titulo_w;
		elsif (cd_retorno_liq_w = ds_ocorrencia_w) then

			RAISE NOTICE 'nr_titulo_w = %', nr_titulo_w;

			select	sum(a.vl_imposto)
			into STRICT	vl_imposto_w
			from	tributo b,
				w_titulo_pagar_imposto a
			where	coalesce(b.ie_saldo_tit_pagar,'S')	= 'S'
			and	a.cd_tributo	= b.cd_tributo
			and	a.nr_seq_escrit	= nr_seq_banco_escrit_p
			and	a.nr_titulo	= nr_titulo_w;

			select	max(a.vl_saldo_titulo),
				max(a.vl_outras_despesas),
				max(a.vl_outros_acrescimos)
			into STRICT	vl_saldo_titulo_w,
				vl_despesa_w,
				vl_acrescimo_w
			from	titulo_pagar a
			where	a.nr_titulo	= nr_titulo_w;

			if	((coalesce(vl_pagamento_w,0) + coalesce(vl_imposto_w,0)) > coalesce(vl_saldo_titulo_w,0)) then

				vl_pagamento_w	:= coalesce(vl_pagamento_w,0) - coalesce(vl_imposto_w,0);

			end if;

			if (ie_vl_associado_w	= 'S') then

				vl_pagamento_w	:= coalesce(vl_pagamento_w,0) - coalesce(vl_despesa_w,0) - coalesce(vl_acrescimo_w,0);

			end if;

			if (coalesce(vl_pagamento_w,0)	= 0) then

				vl_pagamento_w	:= vl_real_w;

			end if;

			qt_baixa_w	:= coalesce(qt_baixa_w,0) + 1;

			CALL baixa_titulo_pagar(cd_estabelecimento_w,
					cd_tipo_baixa_w,
					nr_titulo_w,
					vl_pagamento_w,
					nm_usuario_p,
					nr_seq_trans_escrit_w,
					null,
					nr_seq_banco_escrit_p,
					dt_pagamento_w,
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

			update	titulo_pagar_escrit
			set	ds_erro			= ds_ocorrencia_w
			where	nr_seq_escrit		= nr_seq_banco_escrit_p
			and	nr_titulo		= nr_titulo_w;
		else
			update	titulo_pagar_escrit
			set	ds_erro			= ds_ocorrencia_w
			where	nr_seq_escrit		= nr_seq_banco_escrit_p
			and	nr_titulo		= nr_titulo_w;
		end if;

	end loop;
	close c02;

	exception
	when others then
		rollback;
		delete	from w_interf_retorno_itau
		where	nr_seq_banco_escrit	= nr_seq_banco_escrit_p;
		commit;
		/* sqlerrm
		nr_titulo_w = nr_titulo_w
		ds_nr_titulo_w = ds_nr_titulo_w
		ds_dt_pagamento_w = ds_dt_pagamento_w
		ds_vl_pagamento_w = ds_vl_pagamento_w
		ds_nr_documento_w = ds_nr_documento_w
		ds_ocorrencia_w = ds_ocorrencia_w */
		CALL wheb_mensagem_pck.exibir_mensagem_abort(198871,	'SQL_ERRM=' || sqlerrm ||
								';NR_TITULO_W=' || nr_titulo_w ||
								';DS_NR_TITULO_W=' || ds_nr_titulo_w ||
								';DS_DT_PAGAMENTO_W=' || ds_dt_pagamento_w ||
								';DS_VL_PAGAMENTO_W=' || ds_vl_pagamento_w ||
								';DS_NR_DOCUMENTO_W=' || ds_nr_documento_w ||
								';DS_OCORRENCIA_W=' || ds_ocorrencia_w);
	end;
end loop;
close c01;

if (coalesce(qt_baixa_w,0)	> 0) then

	update	banco_escritural
	set	dt_baixa	= clock_timestamp()
	where	nr_sequencia	= nr_seq_banco_escrit_p;

end if;

delete	from w_interf_retorno_itau
where	nr_seq_banco_escrit	= nr_seq_banco_escrit_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_retorno_pagto_caixa (nr_seq_banco_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;

