-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ret_cobr_santand_240_v17 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_reg_T_w		bigint;
nr_seq_reg_U_w		bigint;
nr_titulo_w		bigint;
cont_w			bigint;
vl_titulo_w		double precision;
vl_acrescimo_w		double precision;
vl_desconto_w		double precision;
vl_abatimento_w		double precision;
vl_liquido_w		double precision;
vl_outras_despesas_w	double precision;
dt_liquidacao_w		timestamp;
ds_lista_titulos_w	varchar(4000);

c01 CURSOR FOR
	SELECT	nr_sequencia,
		(substr(ds_string,42,11))::numeric  nr_titulo,
		(substr(ds_string,78,13) || ',' || substr(ds_string,91,2))::numeric  vl_titulo
	from	w_retorno_banco
	where	nr_seq_cobr_escrit	= nr_seq_cobr_escrit_p
	and	substr(ds_string,8,1)	= '3'
	and	substr(ds_string,14,1)	= 'T';


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_reg_T_w,
	nr_titulo_w,
	vl_titulo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	select	count(*)
	into STRICT	cont_w
	from	titulo_receber
	where	nr_titulo	= nr_titulo_w;

	if (cont_w = 0) and (length(ds_lista_titulos_w) <= 3990) then
		if (coalesce(ds_lista_titulos_w::text, '') = '') then
			ds_lista_titulos_w	:= nr_titulo_w;
		else
			ds_lista_titulos_w	:= ds_lista_titulos_w || ', ' || nr_titulo_w;
		end if;
	else
		nr_seq_reg_U_w := nr_seq_reg_T_w + 1;
		select	(substr(ds_string,123,13) || ',' || substr(ds_string,136,2))::numeric ,
			(substr(ds_string,33,13) || ',' || substr(ds_string,46,2))::numeric ,
			(substr(ds_string,48,13) || ',' || substr(ds_string,61,2))::numeric ,
			(substr(ds_string,93,13) || ',' || substr(ds_string,106,2))::numeric ,
			(substr(ds_string,108,13) || ',' || substr(ds_string,121,2))::numeric ,
			to_date(substr(ds_string,146,8),'dd/mm/yyyy')
		into STRICT	vl_acrescimo_w,
			vl_desconto_w,
			vl_abatimento_w,
			vl_liquido_w,
			vl_outras_despesas_w,
			dt_liquidacao_w
		from	w_retorno_banco
		where	nr_sequencia	= nr_seq_reg_U_w;

		if (vl_acrescimo_w <= 0) then
			vl_acrescimo_w	:= vl_liquido_w - vl_titulo_w;
		end if;

		if (cont_w = 0) then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(186816,'NR_TITULO='||nr_titulo_w);
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
							nr_seq_cobranca)
					values (	nextval('titulo_receber_cobr_seq'),
							nr_titulo_w,
							033,
							vl_titulo_w,
							vl_desconto_w,
							vl_acrescimo_w,
							vl_outras_despesas_w,
							vl_liquido_w,
							dt_liquidacao_w,
							clock_timestamp(),
							nm_usuario_p,
							nr_seq_cobr_escrit_p);
	end if;
	end;
end loop;
close c01;

commit;

if (ds_lista_titulos_w IS NOT NULL AND ds_lista_titulos_w::text <> '') then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(186814,'DS_LISTA_TITULOS='||ds_lista_titulos_w);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ret_cobr_santand_240_v17 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;
