-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_saldo_proj_rec (nr_titulo_p bigint, vl_baixa_p bigint) AS $body$
DECLARE



nr_seq_proj_rec_w   bigint;
vl_saldo_w          double precision;


BEGIN

if (Obter_Valor_Param_Usuario(851,251, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento) = 'N') then
	begin

	select 	nr_seq_proj_rec
	into STRICT   	nr_seq_proj_rec_w
	from   	titulo_pagar
	where 	nr_titulo = nr_titulo_p;

	if (coalesce(nr_seq_proj_rec_w,0) <> 0) then

		select	sup_obter_saldo_proj_rec(nr_seq_proj_rec_w, clock_timestamp())
		into STRICT	vl_saldo_w
		;


			if (coalesce(vl_baixa_p,0) > coalesce(vl_saldo_w,0)) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(345559);
		end if;
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_saldo_proj_rec (nr_titulo_p bigint, vl_baixa_p bigint) FROM PUBLIC;
