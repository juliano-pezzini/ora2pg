-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_retorno_bradesco_240 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_reg_t_w		bigint;
nr_seq_reg_u_w		bigint;
nr_titulo_w		bigint;
vl_titulo_w		double precision;
vl_acrescimo_w		double precision;
vl_desconto_w		double precision;
vl_abatimento_w		double precision;
vl_liquido_w		double precision;
vl_outras_despesas_w	double precision;
dt_liquidacao_w		timestamp;
ds_dt_liquidacao_w		varchar(8);
ds_titulo_w		varchar(15);
vl_cobranca_w		double precision;
vl_alterar_w		double precision;
cd_ocorrencia_w		bigint;
nr_seq_ocorrencia_ret_w	bigint;
ds_nosso_numero_w	varchar(12);
ie_digito_nosso_w		varchar(1);

nr_ds_titulo_w		bigint;
nr_nosso_numero_w	varchar(20);
nr_seq_ocorr_motivo_w	bigint;
cd_motivo_w		varchar(20);
vl_saldo_titulo_w		double precision;
ds_dt_credito_banco_w	varchar(8);
dt_credito_banco_w	timestamp;

c01 CURSOR FOR
SELECT	nr_sequencia,
	trim(both substr(ds_string,59,15)) ds_titulo,
	lpad(trim(both substr(ds_string,38,19)),19,'0') ds_nosso_numero,
	(substr(ds_string,82,15))::numeric /100 vl_cobranca,
	substr(ds_string,214,10) cd_motivo,
	lpad(trim(both substr(ds_string,57,1)),1,'0') ie_digito_nosso
from	w_retorno_banco
where	nr_seq_cobr_escrit	= nr_seq_cobr_escrit_p
and	substr(ds_string,8,1)	= '3'
and	substr(ds_string,14,1)	= 'T';


BEGIN

delete	from cobranca_escrit_log
where	nr_seq_cobranca	= nr_seq_cobr_escrit_p;

select	max(substr(ds_string,146,8))
into STRICT	ds_dt_credito_banco_w
from	w_retorno_banco
where	nr_seq_cobr_escrit	= nr_seq_cobr_escrit_p
and	substr(ds_string,8,1)	= '3'
and	substr(ds_string,14,1)	= 'U';

begin

	dt_credito_banco_w	:= to_date(ds_dt_credito_banco_w,'dd/mm/yyyy');

exception
when others then

	dt_credito_banco_w	:= null;

end;

update	cobranca_escritural
set	dt_credito_bancario	= dt_credito_banco_w
where	nr_sequencia		= nr_seq_cobr_escrit_p;

open c01;
loop
fetch c01 into
	nr_seq_reg_t_w,
	ds_titulo_w,
	ds_nosso_numero_w,
	vl_cobranca_w,
	cd_motivo_w,
	ie_digito_nosso_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	vl_alterar_w		:= 0;

	/* encontrar pelo título externo */

	select	max(nr_titulo)
	into STRICT	nr_titulo_w
	from	titulo_receber
	where	nr_titulo_externo		= ds_titulo_w
	and	coalesce(nr_titulo_externo,'0')	<> '0';

	if (coalesce(nr_titulo_w::text, '') = '') then

		select	max(a.nr_titulo)
		into STRICT	nr_titulo_w
		from	titulo_receber a
		where	lpad(a.nr_nosso_numero,12,'0')	= ds_nosso_numero_w
		and	coalesce(a.nr_nosso_numero,'0')	<> '0';

		/* se não econtrou, procura pelo título no tasy */

		if (coalesce(nr_titulo_w::text, '') = '') then

			nr_ds_titulo_w		:= somente_numero(ds_titulo_w);

			select	max(nr_titulo)
			into STRICT	nr_titulo_w
			from	titulo_receber
			where	nr_titulo	= nr_ds_titulo_w;

			if (coalesce(nr_titulo_w::text, '') = '') then

				nr_nosso_numero_w	:= (ds_nosso_numero_w)::numeric;

				select	max(a.nr_titulo)
				into STRICT	nr_titulo_w
				from	titulo_receber a
				where	a.nr_titulo	= nr_nosso_numero_w;

				if (coalesce(nr_titulo_w::text, '') = '') then

					select	max(a.nr_titulo)
					into STRICT	nr_titulo_w
					from	titulo_receber a
					where	ds_titulo_w like a.nr_titulo || '%';

					if (coalesce(nr_titulo_w::text, '') = '') then

						select	max(a.nr_titulo)
						into STRICT	nr_titulo_w
						from	titulo_receber a
						where	lpad(a.nr_nosso_numero,12,'0')	= ds_nosso_numero_w || ie_digito_nosso_w
						and	coalesce(a.nr_nosso_numero,'0')	<> '0';

						if (coalesce(nr_titulo_w::text, '') = '') then

							nr_nosso_numero_w	:= somente_numero(ds_nosso_numero_w || ie_digito_nosso_w);

							select	max(a.nr_titulo)
							into STRICT	nr_titulo_w
							from	titulo_receber a
							where	a.nr_titulo	= nr_nosso_numero_w;

							if (coalesce(nr_titulo_w::text, '') = '') then

								select	max(a.nr_titulo)
								into STRICT	nr_titulo_w
								from	titulo_receber a
								where	somente_numero(a.nr_nosso_numero)	= nr_nosso_numero_w;

							end if;

						end if;

					end if;

				end if;

			end if;

		end if;

	end if;

	/* se encontrou o título importa, senão grava no log */

	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then

		select	max(vl_titulo),
			max(vl_saldo_titulo)
		into STRICT	vl_titulo_w,
			vl_saldo_titulo_w
		from	titulo_receber
		where	nr_titulo	= nr_titulo_w;

		nr_seq_reg_u_w := nr_seq_reg_t_w + 1;

		select	coalesce((substr(ds_string,18,15))::numeric /100,0),
			coalesce((substr(ds_string,33,15))::numeric /100,0),
			coalesce((substr(ds_string,48,15))::numeric /100,0),
			coalesce((substr(ds_string,93,15))::numeric /100,0),
			coalesce((substr(ds_string,108,15))::numeric /100,0),
			CASE WHEN coalesce(dt_credito_banco_w::text, '') = '' THEN substr(ds_string,146,8)  ELSE substr(ds_string,138,8) END ,
			(substr(ds_string,16,2))::numeric
		into STRICT	vl_acrescimo_w,
			vl_desconto_w,
			vl_abatimento_w,
			vl_liquido_w,
			vl_outras_despesas_w,
			ds_dt_liquidacao_w,
			cd_ocorrencia_w
		from	w_retorno_banco
		where	nr_sequencia	= nr_seq_reg_u_w;

		begin

			dt_liquidacao_w	:= to_date(ds_dt_liquidacao_w,'dd/mm/yyyy');

		exception
		when others then

			dt_liquidacao_w	:= clock_timestamp();

		end;

		select 	max(a.nr_sequencia)
		into STRICT	nr_seq_ocorrencia_ret_w
		from	banco_ocorr_escrit_ret a
		where	a.cd_banco	= 237
		and	a.cd_ocorrencia = cd_ocorrencia_w;

		select	max(a.nr_sequencia)
		into STRICT	nr_seq_ocorr_motivo_w
		from	banco_ocorr_motivo_ret a
		where	position(a.cd_motivo in cd_motivo_w)	> 0
		and	a.nr_seq_escrit_ret		= nr_seq_ocorrencia_ret_w;

		/* tratar acrescimos/descontos */

		if (coalesce(vl_liquido_w,0)	<> 0) and (vl_titulo_w		<> vl_liquido_w) then

			vl_alterar_w	:= vl_liquido_w - vl_titulo_w;

			if (vl_alterar_w > 0) then
				vl_acrescimo_w	:= vl_alterar_w;
			else
				vl_desconto_w	:= abs(vl_alterar_w);
			end if;

		end if;

		insert	into titulo_receber_cobr(	nr_sequencia,
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
							nr_seq_ocorr_motivo,
							vl_saldo_inclusao)
					values (	nextval('titulo_receber_cobr_seq'),
							nr_titulo_w,
							237,
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
							nr_seq_ocorr_motivo_w,
							vl_saldo_titulo_w);
	else

		insert	into cobranca_escrit_log(ds_log,
			dt_atualizacao,
			dt_atualizacao_nrec,
			nm_usuario,
			nm_usuario_nrec,
			nr_nosso_numero,
			nr_seq_cobranca,
			nr_sequencia)
		values ('não foi importado o título ' || ds_titulo_w || ', pois não foi encontrado no tasy',
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			ds_nosso_numero_w,
			nr_seq_cobr_escrit_p,
			nextval('cobranca_escrit_log_seq'));

	end if;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_retorno_bradesco_240 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;
