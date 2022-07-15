-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hvc_gerar_retorno_brasil_400 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_titulo_w			varchar(255);
dt_liquidacao_w			varchar(6);
vl_titulo_w			double precision;
vl_acrescimo_w			double precision;
vl_desconto_w			double precision;
vl_abatimento_w			double precision;
vl_liquido_w			double precision;
vl_outras_despesas_w		double precision;
vl_cobranca_w			double precision;
vl_alterar_w			double precision;
nr_seq_reg_T_w			bigint;
nr_seq_reg_U_w			bigint;
nr_titulo_w			bigint;
cd_ocorrencia_w			bigint;
nr_seq_ocorrencia_ret_w		bigint;
cd_banco_w			smallint;
cd_banco_cobr_w			smallint;
dt_pagto_real_w			varchar(6);

C01 CURSOR FOR
	SELECT	trim(both substr(ds_string,117,10)),
		(substr(ds_string,153,13))::numeric /100,
		(substr(ds_string,267,13))::numeric /100,
		(substr(ds_string,241,13))::numeric /100,
		(substr(ds_string,228,13))::numeric /100,
		(substr(ds_string,254,13))::numeric /100,
		(substr(ds_string,182,7))::numeric /100,
		substr(ds_string,111,6),
		substr(ds_string,111,6),
		substr(ds_string,109,2)
	from	w_retorno_banco
	where	nr_seq_cobr_escrit	= nr_seq_cobr_escrit_p
	and	substr(ds_string,1,1)	= '7';


BEGIN
select	max((substr(ds_string,77,3))::numeric )
into STRICT	cd_banco_w
from	w_retorno_banco
where	nr_seq_cobr_escrit	= nr_seq_cobr_escrit_p
and	substr(ds_string,1,1)	= '0';

select	max((a.cd_banco)::numeric )
into STRICT	cd_banco_cobr_w
FROM cobranca_escritural a
LEFT OUTER JOIN banco_carteira b ON (a.nr_seq_carteira_cobr = b.nr_sequencia)
WHERE a.nr_sequencia		= nr_seq_cobr_escrit_p;

if (cd_banco_w <> cd_banco_cobr_w) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(184490);
end if;

open C01;
loop
fetch C01 into
	ds_titulo_w,
	vl_cobranca_w,
	vl_acrescimo_w,
	vl_desconto_w,
	vl_abatimento_w,
	vl_liquido_w,
	vl_outras_despesas_w,
	dt_liquidacao_w,
	dt_pagto_real_w,
	cd_ocorrencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	vl_alterar_w	:= 0;

	select	max(nr_titulo)
	into STRICT	nr_titulo_w
	from	titulo_receber
	where	nr_titulo	= somente_numero(ds_titulo_w);

	/* Se encontrou o título importa, senão grava no log */

	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
		select	vl_titulo
		into STRICT	vl_titulo_w
		from	titulo_receber
		where	nr_titulo	= nr_titulo_w;


		select 	coalesce(to_char(max(a.nr_sequencia)),0)
		into STRICT	nr_seq_ocorrencia_ret_w
		from	banco_ocorr_escrit_ret a
		where	a.cd_banco 			= 001
		and	a.cd_ocorrencia 		= cd_ocorrencia_w
		and	coalesce(a.ie_forma_cobranca,1)	= 1;

		/* Tratar acrescimos/descontos */

		if (vl_titulo_w <> vl_liquido_w) then
			vl_alterar_w	:= vl_liquido_w - vl_titulo_w;

			if (vl_alterar_w > 0) then
				vl_acrescimo_w	:= vl_alterar_w;
			else
				vl_desconto_w	:= abs(vl_alterar_w);
			end if;
		end if;

		insert into titulo_receber_cobr(nr_sequencia,
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
			dt_pagamento_real)
		values (nextval('titulo_receber_cobr_seq'),
			nr_titulo_w,
			001,
			vl_titulo_w,
			vl_desconto_w,
			vl_acrescimo_w,
			vl_outras_despesas_w,
			vl_liquido_w,
			coalesce(to_Date(dt_liquidacao_w,'ddmmyy'),clock_timestamp()),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_cobr_escrit_p,
			nr_seq_ocorrencia_ret_w,
			coalesce(to_Date(dt_pagto_real_w,'ddmmyy'),clock_timestamp()));
	else
		/*insert into logxxx_tasy
			(nm_usuario,
			dt_atualizacao,
			cd_log,
			ds_log)
		values	(nm_usuario_p,
			sysdate,
			55760,
			'Não foi importado o título ' || ds_titulo_w || ', pois não foi encontrado no Tasy');*/
		insert into cobranca_escrit_log(nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nr_seq_cobranca,
			ds_log)
		values (nextval('cobranca_escrit_log_seq'),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nr_seq_cobr_escrit_p,
			'Não foi importado o título ' || ds_titulo_w || ', pois não foi encontrado no Tasy');
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
-- REVOKE ALL ON PROCEDURE hvc_gerar_retorno_brasil_400 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;

