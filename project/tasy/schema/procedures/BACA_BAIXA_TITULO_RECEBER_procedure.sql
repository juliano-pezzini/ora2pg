-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_baixa_titulo_receber ( cd_cgc_p text, dt_emissao_p timestamp, nr_seq_trans_financ_p bigint, cd_tipo_recebimento_p bigint, nm_usuario_p text, qt_reg_p bigint) AS $body$
DECLARE

 
nr_titulo_w    		bigint;
cd_estabelecimento_w		integer;
vl_saldo_w			double precision;
qt_reg_w			bigint;

C010 CURSOR FOR 
	SELECT cd_estabelecimento, 
		nr_titulo, 
		vl_saldo_titulo 
	from	titulo_receber 
	where	cd_cgc			= cd_cgc_p 
	and	dt_emissao		<= dt_emissao_p 
	and	vl_saldo_titulo	> 0;

BEGIN
qt_reg_w		:= 0;
OPEN C010;
LOOP 
	FETCH C010 into 
		cd_estabelecimento_w, 
		nr_titulo_w, 
		vl_saldo_w;
	EXIT WHEN NOT FOUND; /* apply on c010 */
		begin 
		qt_reg_w	:= qt_reg_w + 1;
		if (qt_reg_w <= qt_reg_p) then 
			CALL Baixa_Titulo_Receber( 
				cd_estabelecimento_w, 
				cd_tipo_recebimento_p, 
				nr_titulo_w, 
				nr_seq_trans_financ_p, 
				vl_saldo_w, 
				null, 
				nm_usuario_p, 
				null, 
				null, 
				null, 
				0, 
				0);	
			CALL Atualizar_Saldo_Tit_Rec(nr_titulo_w, nm_usuario_p);	
		end if;
		end;
END LOOP;
CLOSE C010;
COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_baixa_titulo_receber ( cd_cgc_p text, dt_emissao_p timestamp, nr_seq_trans_financ_p bigint, cd_tipo_recebimento_p bigint, nm_usuario_p text, qt_reg_p bigint) FROM PUBLIC;
