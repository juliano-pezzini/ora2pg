-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_retorno_sicredi_400 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_reg_T_w			bigint;
nr_seq_reg_U_w			bigint;
nr_titulo_w				bigint;
vl_titulo_w				double precision;
vl_acrescimo_w			double precision;
vl_desconto_w			double precision;
vl_liquido_w			double precision;
vl_outras_despesas_w	double precision;
ds_titulo_w				varchar(255);
vl_cobranca_w			double precision;
vl_alterar_w			double precision;
cd_ocorrencia_w			bigint;
nr_seq_ocorrencia_ret_w	bigint;
ds_nosso_numero_w		varchar(15);
nr_nosso_numero_w		bigint;
nr_ds_titulo_w			bigint;
nr_ano_w				varchar(4);
nr_mes_w				varchar(2);
nr_dia_w				varchar(2);
ds_mensagem_w			varchar(255);

ds_dt_liquidacao_w		varchar(6);
dt_liquidacao_w			timestamp;
ds_dt_credito_bancario_w	varchar(8);
dt_credito_bancario_w		timestamp;
nr_seq_tipo_cobranca_w		cobranca_escritural.nr_seq_tipo%type;
nr_seq_ocorr_motivo_w		banco_ocorr_motivo_ret.nr_sequencia%type;
ds_motivo_rejeicao_w		varchar(10);

c01 CURSOR FOR
	SELECT	trim(both substr(ds_string,117,10)),
		somente_numero(substr(ds_string,153,13))/100,
		somente_numero(substr(ds_string,267,13))/100,
 		somente_numero(substr(ds_string,241,13))/100,
		somente_numero(substr(ds_string,254,13))/100,
		somente_numero(substr(ds_string,176,13))/100,
		substr(ds_string,329,4),
		substr(ds_string,333,2),
		substr(ds_string,335,2),
		substr(ds_string,109,2),
		lpad(trim(both substr(ds_string,48,15)),15,'0') ds_nosso_numero,
		substr(ds_string,111,6) ds_dt_liquidacao,
		trim(both substr(ds_string,319,10)) ds_motivo_rejeicao
	from	w_retorno_banco
	where	nr_seq_cobr_escrit	= nr_seq_cobr_escrit_p
	and	substr(ds_string,1,1)	= '1';

BEGIN

select	substr(max(a.ds_string),95,8)
into STRICT	ds_dt_credito_bancario_w
from	w_retorno_banco a
where	substr(a.ds_string,1,1)	= '0'
and	a.nr_seq_cobr_escrit	= nr_seq_cobr_escrit_p;

select	max(a.nr_seq_tipo)
into STRICT	nr_seq_tipo_cobranca_w
from	cobranca_escritural a
where	a.nr_sequencia = nr_seq_cobr_escrit_p;

if (ds_dt_credito_bancario_w IS NOT NULL AND ds_dt_credito_bancario_w::text <> '') and (ds_dt_credito_bancario_w	<> '00000000') then

	begin

		dt_credito_bancario_w	:= to_date(ds_dt_credito_bancario_w,'yyyymmdd');

	exception
	when others then

		dt_credito_bancario_w	:= null;

	end;

end if;

update	cobranca_escritural
set	dt_credito_bancario	= dt_credito_bancario_w
where	nr_sequencia		= nr_seq_cobr_escrit_p;

open C01;
loop
fetch C01 into	
	ds_titulo_w,
	vl_cobranca_w,
	vl_acrescimo_w,
	vl_desconto_w,
	vl_liquido_w,
	vl_outras_despesas_w,
	nr_ano_w,
	nr_mes_w,
	nr_dia_w,
	cd_ocorrencia_w,
	ds_nosso_numero_w,
	ds_dt_liquidacao_w,
	ds_motivo_rejeicao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (coalesce(ds_dt_liquidacao_w::text, '') = '') or (ds_dt_liquidacao_w	= '000000') then

		dt_liquidacao_w	:= coalesce(to_Date(nr_dia_w || nr_mes_w || nr_ano_w,'ddmmyy'),clock_timestamp());

	else

		dt_liquidacao_w	:= to_date(ds_dt_liquidacao_w,'ddmmyy');

	end if;

	vl_alterar_w	:= 0;

	nr_ds_titulo_w	:= somente_numero(ds_titulo_w);
	
	select	max(nr_titulo)
	into STRICT	nr_titulo_w
	from	titulo_receber
	where	nr_titulo	= nr_ds_titulo_w;

	if (coalesce(nr_titulo_w::text, '') = '') then
		select	max(a.nr_titulo)
		into STRICT	nr_titulo_w
		from	titulo_receber a
		where	lpad(a.nr_titulo,15,'0')	= ds_nosso_numero_w;

		if (coalesce(nr_titulo_w::text, '') = '') then
			nr_nosso_numero_w	:= somente_numero(ds_nosso_numero_w);

			select	max(a.nr_titulo)
			into STRICT	nr_titulo_w
			from	titulo_receber a
			where	somente_numero(a.nr_titulo)	= nr_nosso_numero_w;
		end if;
	end if;

	/* Se encontrou o título importa, senão grava no log */

	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') and (cd_ocorrencia_w <> '28') then
		select	vl_titulo
		into STRICT	vl_titulo_w
		from	titulo_receber
		where	nr_titulo	= nr_titulo_w;

		select 	coalesce(to_char(max(a.nr_sequencia)),0)
		into STRICT	nr_seq_ocorrencia_ret_w
		from	banco_ocorr_escrit_ret a
		where	a.cd_banco	= 748
		and 	coalesce(a.nr_seq_tipo,0) 	= coalesce(nr_seq_tipo_cobranca_w,0)
		and	a.cd_ocorrencia	= cd_ocorrencia_w;
		
		/*Busca motivo ocorrência*/

		select	max(a.nr_sequencia)
		into STRICT	nr_seq_ocorr_motivo_w
		from	banco_ocorr_motivo_ret a
		where	position(a.cd_motivo in ds_motivo_rejeicao_w)	> 0
		and		a.nr_seq_escrit_ret	= nr_seq_ocorrencia_ret_w;	

		/* Tratar acrescimos/descontos */

		if (vl_titulo_w <> vl_liquido_w) then
			vl_alterar_w	:= vl_liquido_w - vl_titulo_w;

			if (vl_alterar_w > 0) then
				vl_acrescimo_w	:= vl_alterar_w;
			else
				vl_desconto_w	:= abs(vl_alterar_w);
			end if;
		end if;
		
		insert	into titulo_receber_cobr(nr_sequencia,
			nr_titulo,
			cd_banco,
			vl_cobranca,
			vl_desconto,
			vl_acrescimo,
			vl_despesa_bancaria,
			vl_liquidacao,
			dt_liquidacao,
			dt_atualizacao,
			nm_usuario,
			nr_seq_cobranca,
			nr_seq_ocorrencia_ret,
			nr_seq_ocorr_motivo)
		values (nextval('titulo_receber_cobr_seq'),
			nr_titulo_w,
			748,
			vl_titulo_w,
			vl_desconto_w,
			vl_acrescimo_w,
			vl_outras_despesas_w,
			vl_liquido_w,
			dt_liquidacao_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_cobr_escrit_p,
			nr_seq_ocorrencia_ret_w,
			nr_seq_ocorr_motivo_w);
	else
		ds_mensagem_w :=  substr(wheb_mensagem_pck.get_texto(304316, 'ds_titulo_w=' || ds_titulo_w),1,255);
		CALL fin_gerar_log_controle_banco(3	,
						ds_mensagem_w,
						nm_usuario_p
						,'N');

	end if;
	
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_retorno_sicredi_400 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;

