-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_titulos_deposito_iden ( nr_seq_deposito_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
vl_saldo_titulo_w	double precision;
nr_titulo_w		bigint;
nr_seq_trans_financ_w	bigint;
cd_tipo_recebimento_w	bigint;
nr_seq_baixa_w		bigint;

C01 CURSOR FOR 
	SELECT	nr_titulo 
	from	deposito_ident_titulo 
	where	nr_seq_deposito	= nr_seq_deposito_p;
	

BEGIN 
open C01;
loop 
fetch C01 into	 
	nr_titulo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	select	vl_saldo_titulo 
	into STRICT	vl_saldo_titulo_w 
	from	titulo_receber 
	where	nr_titulo = nr_titulo_w;
	 
	if (vl_saldo_titulo_w <= 0) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(182702);
	end if;
	 
	begin 
	select	nr_seq_trans_financ, 
		cd_tipo_recebimento 
	into STRICT	nr_seq_trans_financ_w, 
		cd_tipo_recebimento_w 
	from	parametro_deposito_ident 
	where	cd_estabelecimento	= cd_estabelecimento_p;
	exception 
	when others then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(182703);
	end;
	 
	CALL baixa_titulo_receber_dep_ident(	cd_estabelecimento_p, 
					cd_tipo_recebimento_w, 
					nr_titulo_w, 
					nr_seq_trans_financ_w, 
					vl_saldo_titulo_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					nr_seq_deposito_p, 
					0, 
					null, 
					null, 
					null);
			 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_baixa_w 
	from	titulo_receber_liq 
	where	nr_titulo = nr_titulo_w;
 
	if (nr_seq_baixa_w IS NOT NULL AND nr_seq_baixa_w::text <> '') then	 
		-- Gera movimentação financeira para permitir conciliação bancária 
		CALL gerar_movto_tit_baixa(nr_titulo_w, nr_seq_baixa_w, 'R', nm_usuario_p, 'N');
	end if;
				 
	CALL atualizar_saldo_tit_rec(nr_titulo_w,nm_usuario_p); -- Atualizar saldo do título 
	end;
end loop;
close C01;
 
update	deposito_identificado -- Atualiza depósito para "Depositado" 
set	nm_usuario	= nm_usuario_p, 
	ie_status	= 'D', 
	dt_deposito	= clock_timestamp() 
where	nr_sequencia	= nr_seq_deposito_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_titulos_deposito_iden ( nr_seq_deposito_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

