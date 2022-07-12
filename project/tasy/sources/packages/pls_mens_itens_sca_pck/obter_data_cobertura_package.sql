-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mens_itens_sca_pck.obter_data_cobertura ( nr_parcela_sca_p pls_mensalidade_seg_item.nr_parcela_sca%type, dt_adesao_sca_p pls_sca_vinculo.dt_inicio_vigencia%type, dt_rescisao_sca_p pls_sca_vinculo.dt_fim_vigencia%type, dt_reativacao_p pls_segurado.dt_reativacao%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, nr_seq_pagador_sca_p pls_sca_vinculo.nr_seq_pagador%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, ie_tipo_estipulante_p pls_mensalidade_segurado.ie_tipo_estipulante%type, ie_mensalidade_proporcional_p pls_segurado.ie_mensalidade_proporcional%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_pce_proporcional_p pls_mensalidade_segurado.ie_pce_proporcional%type, dt_inclusao_pce_p pls_segurado.dt_inclusao_pce%type, dt_rescisao_ant_p pls_segurado.dt_rescisao_ant%type, ie_rescisao_proporcional_p INOUT text, dt_inicio_cobertura_p INOUT pls_mensalidade_seg_item.dt_inicio_cobertura%type, dt_fim_cobertura_p INOUT pls_mensalidade_seg_item.dt_fim_cobertura%type) AS $body$
DECLARE


dt_inicio_cobertura_w		pls_mensalidade_seg_item.dt_inicio_cobertura%type;
dt_fim_cobertura_w		pls_mensalidade_seg_item.dt_fim_cobertura%type;
ie_mensalidade_proporcional_w	pls_segurado.ie_mensalidade_proporcional%type;
ie_calc_primeira_mens_w		pls_contrato_pagador.ie_calc_primeira_mens%type;
ie_rescisao_proporcional_w	varchar(1);
nr_dia_contratacao_w		smallint;


BEGIN
ie_rescisao_proporcional_w	:= 'N';

select	max(ie_calc_primeira_mens)
into STRICT	ie_calc_primeira_mens_w
from	pls_contrato_pagador
where	nr_sequencia	= nr_seq_pagador_p;

if (coalesce(ie_mensalidade_proporcional_p::text, '') = '') then
	if (ie_calc_primeira_mens_w = 'I') then
		ie_mensalidade_proporcional_w	:= 'N';
	else
		ie_mensalidade_proporcional_w	:= 'S';
	end if;
else
	ie_mensalidade_proporcional_w	:= ie_mensalidade_proporcional_p;
end if;

if	((nr_parcela_sca_p = 1) or (trunc(dt_reativacao_p,'month') = dt_referencia_p and pls_mensalidade_util_pck.get_ie_att_cobertura_reativ = 'P')) and (ie_pce_proporcional_p = 'N' or dt_referencia_p <> trunc(dt_inclusao_pce_p,'month')) then
	if (nr_parcela_sca_p = 1) then
		dt_inicio_cobertura_w	:= dt_adesao_sca_p;
	else
		dt_inicio_cobertura_w	:= dt_reativacao_p;
	end if;

	if (ie_mensalidade_proporcional_w = 'S') then
		dt_fim_cobertura_w	:= last_day(dt_inicio_cobertura_w);
	else
		if (pls_mensalidade_util_pck.get_ie_att_cobertura_reativ = 'P') and (trunc(dt_reativacao_p,'month') = dt_referencia_p) then
			nr_dia_contratacao_w	:= (to_char(dt_adesao_sca_p,'dd'))::numeric -1;
			dt_fim_cobertura_w	:= add_months(trunc(dt_inicio_cobertura_w,'month')+nr_dia_contratacao_w,1)-1;
		else
			dt_fim_cobertura_w	:= add_months(dt_inicio_cobertura_w,1)-1;
		end if;
	end if;
elsif (trunc(dt_inclusao_pce_p,'month') = dt_referencia_p) and (ie_pce_proporcional_p = 'S') and (coalesce(nr_seq_pagador_sca_p::text, '') = '') then
	
	dt_inicio_cobertura_w	:= dt_inclusao_pce_p;
	dt_fim_cobertura_w	:= last_day(dt_inclusao_pce_p);
else
	if (ie_mensalidade_proporcional_w = 'S') then
		dt_inicio_cobertura_w	:= trunc(dt_referencia_p,'month');
		dt_fim_cobertura_w	:= last_day(dt_referencia_p);
	else
		begin
		dt_inicio_cobertura_w	:= to_date(to_char(dt_adesao_sca_p,'dd') || '/'|| to_char(dt_referencia_p,'mm/yyyy'));
		exception
		when others then
			dt_inicio_cobertura_w	:= last_day(dt_referencia_p);
		end;
		
		dt_fim_cobertura_w	:= add_months(dt_inicio_cobertura_w,1)-1;
	end if;

	if (ie_pce_proporcional_p = 'E') and (dt_inclusao_pce_p < dt_fim_cobertura_w)then
		dt_fim_cobertura_w	:= fim_dia(coalesce(dt_rescisao_ant_p, dt_inclusao_pce_p-1));
	end if;
end if;

if (dt_rescisao_sca_p IS NOT NULL AND dt_rescisao_sca_p::text <> '') then
	if (dt_rescisao_sca_p between dt_inicio_cobertura_w and dt_fim_cobertura_w) then
		if (pls_obter_se_rescisao_proporc(nr_seq_contrato_p, nr_seq_intercambio_p, ie_tipo_estipulante_p, dt_referencia_p, cd_estabelecimento_p) = 'S') then
			dt_fim_cobertura_w		:= dt_rescisao_sca_p;
			ie_rescisao_proporcional_w	:= 'S';
		end if;
	end if;
end if;

ie_rescisao_proporcional_p	:= ie_rescisao_proporcional_w;
dt_inicio_cobertura_p		:= dt_inicio_cobertura_w;
dt_fim_cobertura_p		:= dt_fim_cobertura_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_itens_sca_pck.obter_data_cobertura ( nr_parcela_sca_p pls_mensalidade_seg_item.nr_parcela_sca%type, dt_adesao_sca_p pls_sca_vinculo.dt_inicio_vigencia%type, dt_rescisao_sca_p pls_sca_vinculo.dt_fim_vigencia%type, dt_reativacao_p pls_segurado.dt_reativacao%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, nr_seq_pagador_sca_p pls_sca_vinculo.nr_seq_pagador%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, ie_tipo_estipulante_p pls_mensalidade_segurado.ie_tipo_estipulante%type, ie_mensalidade_proporcional_p pls_segurado.ie_mensalidade_proporcional%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_pce_proporcional_p pls_mensalidade_segurado.ie_pce_proporcional%type, dt_inclusao_pce_p pls_segurado.dt_inclusao_pce%type, dt_rescisao_ant_p pls_segurado.dt_rescisao_ant%type, ie_rescisao_proporcional_p INOUT text, dt_inicio_cobertura_p INOUT pls_mensalidade_seg_item.dt_inicio_cobertura%type, dt_fim_cobertura_p INOUT pls_mensalidade_seg_item.dt_fim_cobertura%type) FROM PUBLIC;
