-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ret_cobr_bradesco_400 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_titulo_w      		varchar(12);
ds_dt_liquidacao_w   	varchar(6);
vl_cobranca_w      		double precision;
vl_alterar_w      		double precision;
vl_titulo_w      		double precision;
vl_acrescimo_w      		double precision;
vl_desconto_w      		double precision;
vl_abatimento_w      	double precision;
vl_liquido_w      		double precision;
nr_seq_reg_T_w      	bigint;
nr_seq_reg_U_w      	bigint;
nr_titulo_w      		bigint;
cd_ocorrencia_w      	bigint;
nr_seq_ocorrencia_ret_w	 bigint;
dt_liquidacao_w      		timestamp;
vl_saldo_inclusao_w	titulo_receber.vl_saldo_titulo%type;

C01 CURSOR FOR
SELECT  trim(both substr(ds_string,71,12)), /*Identificacao do titulo no banco*/
		(substr(ds_string,127,13))::numeric /100, /*Identificacao do titulo no banco*/
		(substr(ds_string,267,13))::numeric /100,/*Juros acrescimos*/
		(substr(ds_string,241,13))::numeric /100,/*desconto*/
		(substr(ds_string,228,13))::numeric /100,/*Abatimento*/
		(substr(ds_string,254,13))::numeric /100,/*valor pago liquido*/
		substr(ds_string,296,6),/*data credito*/
		(substr(ds_string,109,2))::numeric /*Identificacao da ocorrencia*/
from  	w_retorno_banco
where  	nr_seq_cobr_escrit  = nr_seq_cobr_escrit_p
and  	substr(ds_string,1,1)  = '1';


BEGIN
open C01;
loop
fetch C01 into
  ds_titulo_w,
  vl_cobranca_w,
  vl_acrescimo_w,
  vl_desconto_w,
  vl_abatimento_w,
  vl_liquido_w,
  ds_dt_liquidacao_w,
  cd_ocorrencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	vl_alterar_w  := 0;

	select  max(nr_titulo)
	into STRICT  	nr_titulo_w
	from  	titulo_receber
	where  	nr_titulo  = somente_numero(ds_titulo_w);

	if (coalesce(nr_titulo_w::text, '') = '') then /* Quando nao ha titulo, busca pelo nosso numero */
		select	max(nr_titulo)
		into STRICT  	nr_titulo_w
		from  	titulo_receber
		where  	(nr_nosso_numero IS NOT NULL AND nr_nosso_numero::text <> '') /*Inclui para performance. So procurar titulos que tenham nr_nosso_numero, ja que a comparacao e nesse campo.*/
		and		nr_nosso_numero  = to_char(ds_titulo_w);		
	
		if (coalesce(nr_titulo_w::text, '') = '') then
			select	max(nr_titulo)
			into STRICT  	nr_titulo_w
			from  	titulo_receber
			where  	(nr_nosso_numero IS NOT NULL AND nr_nosso_numero::text <> '') /*Inclui para performance. So procurar titulos que tenham nr_nosso_numero, ja que a comparacao e nesse campo.*/
			and		somente_numero(nr_nosso_numero)  = somente_numero(ds_titulo_w);	
			
			if (coalesce(nr_titulo_w::text, '') = '') then
				select	max(nr_titulo)
				into STRICT  	nr_titulo_w
				from  	titulo_receber
				where  	(nr_nosso_numero IS NOT NULL AND nr_nosso_numero::text <> '')  /*Inclui para performance. So procurar titulos que tenham nr_nosso_numero, ja que a comparacao e nesse campo.*/
 	
				and		substr(somente_numero(nr_nosso_numero),1,length(somente_numero(ds_titulo_w))-1)  = substr(somente_numero(ds_titulo_w),1,length(somente_numero(ds_titulo_w))-1); /*Comparar NN do arquivo sem digito com NN do titulo sem digito*/
			end if;
			
		end if;		
	end if;	

	/* Se encontrou o titulo importa, senao grava no log */

	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
		select	max(vl_titulo),
			max(vl_saldo_titulo)
		into STRICT	vl_titulo_w,
			vl_saldo_inclusao_w
		from	titulo_receber
		where	nr_titulo	= nr_titulo_w;	


		select 	max(a.nr_sequencia)
		into STRICT	nr_seq_ocorrencia_ret_w
		from	banco_ocorr_escrit_ret a
		where	a.cd_banco 					= 237
		and		a.cd_ocorrencia 			= cd_ocorrencia_w
		and		coalesce(a.ie_forma_cobranca,2)	= 2;

		/* Tratar acrescimos/descontos */

		if (vl_titulo_w <> vl_liquido_w) then
			vl_alterar_w	:= vl_liquido_w - vl_titulo_w;

			if (vl_alterar_w > 0) then
				vl_acrescimo_w	:= vl_alterar_w;	
			/*else
				vl_desconto_w	:= abs(vl_alterar_w);*/
			end if;
		end if;

		if (ds_dt_liquidacao_w	= '000000') or (ds_dt_liquidacao_w	= '999999') or
			((ds_dt_liquidacao_w	= '      ') and (cd_ocorrencia_w in (02,03,10)))	then --OS 1814986 - Ocorrencias 02 entrada confirmada e 03 rejeicao vem em branco.
			dt_liquidacao_w	:= clock_timestamp();
		else
			begin

			dt_liquidacao_w	:= to_date(ds_dt_liquidacao_w,'ddmmyy');

			exception
			when others then

			/* Data de vencimento invalida!
			Titulo: nr_titulo_w
			Data: ds_dt_liquidacao_w */
			CALL wheb_mensagem_pck.exibir_mensagem_abort(242915,
							'NR_TITULO_W='||nr_titulo_w||';'||
							'DS_DT_LIQUIDACAO_W='||ds_dt_liquidacao_w);

			end;
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
										vl_saldo_inclusao)			
							values (	nextval('titulo_receber_cobr_seq'),
										nr_titulo_w,
										237,
										vl_titulo_w,
										vl_desconto_w,
										vl_acrescimo_w,
										0,
										vl_liquido_w,
										dt_liquidacao_w,
										clock_timestamp(),
										nm_usuario_p,
										nr_seq_cobr_escrit_p,
										nr_seq_ocorrencia_ret_w,
										vl_saldo_inclusao_w);
	else
		/*fin_gerar_log_controle_banco(3,substr(wheb_mensagem_pck.get_texto(303847, 'DS_TITULO_W=' || ds_titulo_w),1,4000),nm_usuario_p,'S');*/

		insert into cobranca_escrit_log(	nr_sequencia,
										nm_usuario,
										dt_atualizacao,
										nm_usuario_nrec,
										dt_atualizacao_nrec,
										nr_seq_cobranca,
										ds_log,
										vl_saldo_titulo,
										nr_seq_ocorrencia_ret,
										nr_nosso_numero)
							values (	nextval('cobranca_escrit_log_seq'),
										nm_usuario_p,
										clock_timestamp(),
										nm_usuario_p,
										clock_timestamp(),
										nr_seq_cobr_escrit_p,
										'Nao foi importado o titulo ' || ds_titulo_w || ', pois nao foi encontrado no Tasy',
										vl_liquido_w,
										nr_seq_ocorrencia_ret_w,
										ds_titulo_w);	
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
-- REVOKE ALL ON PROCEDURE gerar_ret_cobr_bradesco_400 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;
