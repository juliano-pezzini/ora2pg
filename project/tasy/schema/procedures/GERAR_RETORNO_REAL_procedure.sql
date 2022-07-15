-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_retorno_real ( nr_seq_banco_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ds_dt_liquidacao_w		varchar(255);
ds_vl_liquidacao_w		varchar(255);
ds_ocorrencia_w			varchar(255) := '';

cd_retorno_liq_w		varchar(50);

nr_titulo_w			bigint;
cd_tipo_baixa_w			bigint;
nr_seq_trans_escrit_w		bigint;
nr_seq_conta_banco_w		bigint;
nr_sequencia_w			bigint;
dt_liquidacao_w			timestamp;
vl_liquidacao_w			double precision;
qt_reg_w			bigint;
cd_estabelecimento_w		bigint;
vl_escritural_w			double precision;

c01 CURSOR FOR 
SELECT	somente_numero(substr(ds_string,24,15))		nr_titulo, 
	substr(ds_string,39,6)				ds_dt_liquidacao, 
	somente_numero(substr(ds_string,46,15))		ds_vl_liquidacao 
from	w_retorno_banco 
where	substr(ds_string,1,1)		 = '3' 
and	nr_seq_banco_escrit		= nr_seq_banco_escrit_p;


BEGIN 
 
begin 
select	b.cd_retorno_liq, 
	a.cd_estabelecimento, 
	a.nr_seq_conta_banco 
into STRICT	cd_retorno_liq_w, 
	cd_estabelecimento_w, 
	nr_seq_conta_banco_w 
from	banco_retorno_cp b, 
	banco_escritural a 
where	a.cd_banco		= b.cd_banco 
and	a.nr_sequencia		= nr_seq_banco_escrit_p;
exception 
	when no_data_found then 
	/*r.aise_application_error(-20011,'Não foi encontrado o código de retorno da liquidação!' || chr(13) || 
					'Verifique o cadastro de "Retorno CP" no cadastro de bancos');*/
 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(267378);				
end;
 
select	nr_seq_trans_escrit 
into STRICT	nr_seq_trans_escrit_w 
from	parametro_tesouraria 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
select	coalesce(cd_tipo_baixa_padrao, 1) 
into STRICT	cd_tipo_baixa_w 
from	parametros_contas_pagar 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
	open c01;
	loop 
	fetch c01 into 
		nr_titulo_w, 
		ds_dt_liquidacao_w, 
		ds_vl_liquidacao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
		dt_liquidacao_w		:= to_date(ds_dt_liquidacao_w);
		vl_liquidacao_w		:= (ds_vl_liquidacao_w)::numeric;
		vl_liquidacao_w		:= dividir_sem_round((ds_vl_liquidacao_w)::numeric,100);
		 
		select	count(*) 
		into STRICT	qt_reg_w 
		from	titulo_pagar_escrit 
		where	nr_seq_escrit	= nr_seq_banco_escrit_p 
		and	nr_titulo			= nr_titulo_w;
		 
		if (qt_reg_w = 0) then 
			CALL gerar_titulo_escritural(nr_titulo_w,nr_seq_banco_escrit_p,nm_usuario_p);
 
			qt_reg_w	:= 1;
		end if;		
 
 
		if (qt_reg_w	> 0)	then 
			 
			select	vl_escritural 
			into STRICT	vl_escritural_w 
			from	titulo_pagar_escrit 
			where	nr_seq_escrit	= nr_seq_banco_escrit_p 
			and	nr_titulo	= nr_titulo_w;
		 
			/*Colocado este tratamento para não efetuar baixa com valor maior que o título - Feltrin OS88049*/
 
			if (vl_liquidacao_w	> vl_escritural_w) then 
				vl_liquidacao_w	:= vl_escritural_w;
			end if;
 
			CALL baixa_titulo_pagar(cd_estabelecimento_w, 
					cd_tipo_baixa_w, 
					nr_titulo_w, 
					vl_liquidacao_w, 
					nm_usuario_p, 
					nr_seq_trans_escrit_w, 
					null, 
					nr_seq_banco_escrit_p, 
					dt_liquidacao_w, 
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
		else 
 
			update	titulo_pagar_escrit 
			set	ds_erro			= ds_ocorrencia_w 
			where	nr_seq_escrit		= nr_seq_banco_escrit_p 
			and	nr_titulo		= nr_titulo_w;
		end if;
	 
	end loop;
	close c01;
 
delete	from w_retorno_banco 
where	nr_seq_banco_escrit	= nr_seq_banco_escrit_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_retorno_real ( nr_seq_banco_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;

