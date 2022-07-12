-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dias_atraso_titulo ( nr_seq_mensalidade_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/* ie_opcao_p
	T : quantidade de dias de atraso com base na data de prorrogação do título se o parâmetro 15 do dossiê beneficiário for 'N', se for 'S'  quantidade de dias de atraso com base na data de vencimento do título
	M : quantidade de dias de atraso com base na data de vencimento da mensalidade
*/
dt_liquidacao_titulo_w		timestamp;
dt_pagamento_previsto_w		timestamp;
dt_vencimento_w			timestamp;
ie_cancelamento_w		pls_mensalidade.ie_cancelamento%type;
dt_venc_titulo_w		timestamp;
ie_considerar_venc_titulo_w	varchar(1);
dt_base_w			timestamp;
qt_dias_atraso_w		bigint;
dt_liquidacao_real_tit_w	titulo_receber.dt_liquidacao%type;


BEGIN

select	coalesce(to_date(substr(obter_cx_origem_tit_receb_liq(b.nr_titulo,'LC') ,1,20)), b.dt_liquidacao) dt_liquidacao,
	b.dt_pagamento_previsto,
	a.dt_vencimento,
	a.ie_cancelamento,
	b.dt_vencimento,
	b.dt_liquidacao
into STRICT	dt_liquidacao_titulo_w,
	dt_pagamento_previsto_w,
	dt_vencimento_w,
	ie_cancelamento_w,
	dt_venc_titulo_w,
	dt_liquidacao_real_tit_w
from	pls_mensalidade	a,
	titulo_receber	b
where	b.nr_seq_mensalidade = a.nr_sequencia
and	a.nr_sequencia = nr_seq_mensalidade_p  LIMIT 1;

if (dt_liquidacao_titulo_w IS NOT NULL AND dt_liquidacao_titulo_w::text <> '') and (dt_liquidacao_real_tit_w IS NOT NULL AND dt_liquidacao_real_tit_w::text <> '') then -- Somente deve utilizar a data de liquidação da cobrança escritural se o título estiver liquidado
	dt_base_w	:= trunc(dt_liquidacao_titulo_w,'dd');
else	
	dt_base_w	:= trunc(clock_timestamp(),'dd');
end if;

if (ie_opcao_p = 'T') then
	ie_considerar_venc_titulo_w	:= obter_parametro_funcao(1215,15,wheb_usuario_pck.get_nm_usuario);
	
	if (coalesce(ie_considerar_venc_titulo_w::text, '') = '') then
		begin
		select	vl_parametro
		into STRICT	ie_considerar_venc_titulo_w
		from	funcao_param_perfil
		where	cd_funcao		= 1215
		and	nr_sequencia		= 15
		and	((cd_estabelecimento	= wheb_usuario_pck.get_cd_estabelecimento) or (coalesce(cd_estabelecimento::text, '') = ''))
		and	cd_perfil		= wheb_usuario_pck.get_cd_perfil;
		exception when others then
			begin
			select	vl_parametro
			into STRICT	ie_considerar_venc_titulo_w
			from	funcao_param_estab
			where	cd_funcao		= 1215
			and	nr_seq_param		= 15
			and	cd_estabelecimento	= wheb_usuario_pck.get_cd_estabelecimento;
			exception when others then
				begin
				select	coalesce(vl_parametro,vl_parametro_padrao)
				into STRICT	ie_considerar_venc_titulo_w
				from	funcao_parametro
				where	cd_funcao	= 1215
				and	nr_sequencia	= 15;
				end;
			end;
		end;
	end if;
	
	if (dt_pagamento_previsto_w IS NOT NULL AND dt_pagamento_previsto_w::text <> '') and (dt_pagamento_previsto_w <= clock_timestamp()) and (ie_considerar_venc_titulo_w = 'N') then
		qt_dias_atraso_w	:= trunc(dt_base_w - trunc(dt_pagamento_previsto_w,'dd'));
	elsif (dt_venc_titulo_w IS NOT NULL AND dt_venc_titulo_w::text <> '') and (dt_venc_titulo_w <= clock_timestamp()) and (ie_considerar_venc_titulo_w = 'S') then
		qt_dias_atraso_w	:= trunc(dt_base_w - trunc(dt_venc_titulo_w,'dd'));
	else
		qt_dias_atraso_w	:= 0;
	end if;
elsif (ie_opcao_p = 'M') and (dt_vencimento_w IS NOT NULL AND dt_vencimento_w::text <> '') and (dt_vencimento_w <= clock_timestamp()) then
	qt_dias_atraso_w	:= trunc(dt_base_w - trunc(dt_vencimento_w,'dd'));
else
	qt_dias_atraso_w	:= 0;
end if;

if (qt_dias_atraso_w < 0) then
	qt_dias_atraso_w	:= 0;
end if;

return	qt_dias_atraso_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dias_atraso_titulo ( nr_seq_mensalidade_p bigint, ie_opcao_p text) FROM PUBLIC;

