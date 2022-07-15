-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_valores_tit_pagar_baixa ( nr_titulo_p bigint, vl_saldo_juros_p INOUT bigint, vl_saldo_multa_p INOUT bigint, vl_outros_acrescimos_p INOUT bigint, vl_outras_despesas_p INOUT bigint, cd_moeda_p INOUT bigint) AS $body$
DECLARE

vl_saldo_juros_w	double precision;
vl_saldo_multa_w	double precision;
vl_outros_acrescimos_w	double precision;
vl_outras_despesas_w 	double precision;
ie_outras_desp_no_saldo_w	varchar(1);
cd_moeda_w			titulo_pagar.cd_moeda%type;


BEGIN

ie_outras_desp_no_saldo_w := obter_param_usuario(851, 256, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_outras_desp_no_saldo_w);

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then
	begin
	select 	vl_saldo_juros,
		vl_saldo_multa,
		coalesce(vl_outros_acrescimos,0),
		coalesce(CASE WHEN coalesce(ie_outras_desp_no_saldo_w,'N')='S' THEN 0  ELSE vl_outras_despesas END ,0),
		cd_moeda
	into STRICT	vl_saldo_juros_w,
		vl_saldo_multa_w,
		vl_outros_acrescimos_w,
		vl_outras_despesas_w,
		cd_moeda_w
	from 	titulo_pagar
	where 	nr_titulo = nr_titulo_p;
	end;
end if;
vl_saldo_juros_p := vl_saldo_juros_w;
vl_saldo_multa_p := vl_saldo_multa_w;
vl_outros_acrescimos_p := vl_outros_acrescimos_w;
vl_outras_despesas_p := vl_outras_despesas_w;
cd_moeda_p := cd_moeda_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_valores_tit_pagar_baixa ( nr_titulo_p bigint, vl_saldo_juros_p INOUT bigint, vl_saldo_multa_p INOUT bigint, vl_outros_acrescimos_p INOUT bigint, vl_outras_despesas_p INOUT bigint, cd_moeda_p INOUT bigint) FROM PUBLIC;

