-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ret_cobr_bancoob240 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) AS $body$
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
cd_ocorrencia_w		varchar(2);
nr_seq_ocorrencia_ret_w banco_ocorr_escrit_ret.nr_sequencia%type;
vl_saldo_inclusao_w	titulo_receber.vl_saldo_titulo%type;
ds_dt_credito_banco_w	varchar(8);
dt_credito_banco_w	timestamp;


c01 CURSOR FOR
	SELECT	nr_sequencia,
		(substr(ds_string,59,15))::numeric ,
		(substr(ds_string,82,13) || ',' || substr(ds_string,95,2))::numeric ,
		substr(ds_string,16,2) cd_ocorrencia
	from	w_retorno_banco
	where	nr_seq_cobr_escrit	= nr_seq_cobr_escrit_p
	and	substr(ds_string,8,1)	= '3'
	and	substr(ds_string,14,1)	= 'T';


BEGIN

select	max(trim(both substr(ds_string,146,8)))
into STRICT	ds_dt_credito_banco_w
from	w_retorno_banco
where	nr_seq_cobr_escrit		= nr_seq_cobr_escrit_p
and	substr(ds_string,8,1)		= '3'
and	substr(ds_string,14,1)		= 'U'
and	substr(ds_string,146,8) 	<> '00000000';

begin
	dt_credito_banco_w	:= to_date(ds_dt_credito_banco_w, 'dd/mm/yyyy');
exception
when others then
	dt_credito_banco_w	:= null;
end;

update	cobranca_escritural
set	dt_credito_bancario		= dt_credito_banco_w
where	nr_sequencia			= nr_seq_cobr_escrit_p;

open C01;
loop
fetch C01 into	
	nr_seq_reg_T_w,
	nr_titulo_w,
	vl_titulo_w,
	cd_ocorrencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
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
		
		select	(substr(ds_string,18,13) || ',' || substr(ds_string,31,2))::numeric ,
			(substr(ds_string,33,13) || ',' || substr(ds_string,46,2))::numeric ,
			(substr(ds_string,48,13) || ',' || substr(ds_string,61,2))::numeric ,
			(substr(ds_string,93,13) || ',' || substr(ds_string,106,2))::numeric ,
			(substr(ds_string,108,13) || ',' || substr(ds_string,121,2))::numeric ,
			to_date(CASE WHEN substr(ds_string,138,8)='00000000' THEN null  ELSE substr(ds_string,138,8) END ,'dd/mm/yyyy')
		into STRICT	vl_acrescimo_w,
			vl_desconto_w,
			vl_abatimento_w,
			vl_liquido_w,
			vl_outras_despesas_w,
			dt_liquidacao_w
		from	w_retorno_banco
		where	nr_sequencia	= nr_seq_reg_U_w;

	
		/*if	(vl_acrescimo_w <= 0) then
			vl_acrescimo_w	:= vl_liquido_w - vl_titulo_w;
		end if; */


		/*if	(cont_w = 0) then
			Wheb_mensagem_pck.exibir_mensagem_abort(280952, 'NR_TITULO_P=' || nr_titulo_w);
		end if;*/
		
		if (cont_w > 0) then
		
			select 	max(a.nr_sequencia)
			into STRICT	nr_seq_ocorrencia_ret_w
			from	banco_ocorr_escrit_ret a
			where	a.cd_banco 	= 756
			and	a.cd_ocorrencia = cd_ocorrencia_w;
		
			select	coalesce(max(vl_saldo_titulo),0)
			into STRICT	vl_saldo_inclusao_w
			from	titulo_receber
			where	nr_titulo	= nr_titulo_w;
			
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
				vl_saldo_inclusao)
			values (nextval('titulo_receber_cobr_seq'),
				nr_titulo_w,
				756,
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
				vl_saldo_inclusao_w);

			/*Segundo o layout, caso o Código de Movimento para o retorno seja 02, trata-se de Entrada Confirmada. Nesses casos, atualizar o titulo_receber*/
	
			if (cd_ocorrencia_w = '02') then
				update	titulo_receber a
				set	a.ie_entrada_confirmada = 'C'
				where	a.nr_titulo = nr_titulo_w;
			end if;	
		else
		
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
				'Não foi importado o título ' || nr_titulo_w || ', pois não foi encontrado no Tasy');

		end if;
	end if;
	
	end;
end loop;
close C01;

commit;

if (ds_lista_titulos_w IS NOT NULL AND ds_lista_titulos_w::text <> '') then

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(280951, 'DS_LISTA_TITULOS_P=' || ds_lista_titulos_w);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ret_cobr_bancoob240 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;

