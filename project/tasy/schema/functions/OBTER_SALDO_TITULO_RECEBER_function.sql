-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_titulo_receber ( nr_titulo_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


dt_referencia_w			timestamp;
dt_contabil_w			timestamp;
ie_situacao_w			varchar(1);
vl_titulo_w			double precision;
vl_saldo_data_w			double precision;
vl_recebido_w			double precision;
vl_alteracao_w			double precision;
vl_desdobrado_w			double precision;
vl_tributo_w			double precision;
dt_liquidacao_w			timestamp;
cd_funcao_ativa_w		bigint;
ie_forma_saldo_w		varchar(1);


BEGIN
ie_forma_saldo_w	:= 'C';
cd_funcao_ativa_w 	:= obter_funcao_ativa;

if (cd_funcao_ativa_w = 5512) then
	ie_forma_saldo_w := substr(coalesce(obter_valor_param_usuario(5512, 8, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo),'C'),1,1);
end if;

dt_referencia_w	:= trunc(dt_referencia_p,'dd') + 86399/86400;

begin
select	vl_titulo,
	dt_contabil,
	ie_situacao,
	dt_liquidacao,
	vl_saldo_titulo
into STRICT	vl_titulo_w,
	dt_contabil_w,
	ie_situacao_w,
	dt_liquidacao_w,
	vl_saldo_data_w
from	titulo_receber
where	nr_titulo = nr_titulo_p;
exception
when others then
	begin
	vl_titulo_w		:= 0;
	vl_saldo_data_w		:= 0;
	end;
end;

if (ie_forma_saldo_w <> 'A') then
	begin
	select	coalesce(sum(CASE WHEN ie_aumenta_diminui='A' THEN  vl_alteracao  ELSE vl_alteracao * -1 END ),0)
	into STRICT	vl_alteracao_w
	from	alteracao_valor
	where	nr_titulo	= nr_titulo_p
	and	dt_alteracao	<= dt_referencia_w;

	select	coalesce(sum(vl_tributo),0)
	into STRICT	vl_tributo_w
	from	titulo_receber_trib
	where	nr_titulo		= nr_titulo_p
	and  coalesce(ie_origem_tributo, 'C') in ('D','CD');

	if (ie_situacao_w in ('3','5')) and (dt_liquidacao_w <= dt_referencia_w) then
		vl_saldo_data_w	:= 0;
	else
		select	coalesce(sum(coalesce(vl_recebido,0) + coalesce(vl_glosa,0) + coalesce(vl_descontos,0) + coalesce(vl_perdas,0) + coalesce(vl_nota_credito,0)),0)
		into STRICT	vl_recebido_w
		from 	titulo_receber_liq
		where	nr_titulo		= nr_titulo_p
		and	coalesce(ie_lib_caixa, 'S') = 'S'
		and	dt_recebimento	<= dt_referencia_w;

		if (coalesce(dt_contabil_w,dt_referencia_w) > dt_referencia_w) then
			vl_saldo_data_w	:= 0;
		else	
			vl_saldo_data_w	:= vl_titulo_w - vl_recebido_w;
		end if;

		vl_saldo_data_w	:= vl_saldo_data_w + vl_alteracao_w - vl_tributo_w;

	end if;
	end;
end if;

return coalesce(vl_saldo_data_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_titulo_receber ( nr_titulo_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

