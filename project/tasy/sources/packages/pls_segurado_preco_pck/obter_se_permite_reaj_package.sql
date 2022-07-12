-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_segurado_preco_pck.obter_se_permite_reaj ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, dt_preco_p timestamp, qt_idade_limite_reaj_p pls_segurado.qt_idade_limite_reaj%type, qt_anos_limite_reaj_p pls_segurado.qt_anos_limite_reaj%type, qt_idade_p integer, ie_regulamentacao_p pls_plano.ie_regulamentacao%type, dt_contratacao_p pls_segurado.dt_contratacao%type, dt_inclusao_operadora_p pls_segurado.dt_inclusao_operadora%type) RETURNS varchar AS $body$
DECLARE

qt_anos_operadora_w	integer;
dt_base_inclusao_w	timestamp;
nr_seq_mtvo_alteracao_w	pls_motivo_alteracao_plano.nr_sequencia%type;
dt_adaptacao_w		timestamp;

BEGIN
if (qt_idade_limite_reaj_p IS NOT NULL AND qt_idade_limite_reaj_p::text <> '') or (qt_anos_limite_reaj_p IS NOT NULL AND qt_anos_limite_reaj_p::text <> '') then
	if (qt_idade_p >= coalesce(qt_idade_limite_reaj_p,qt_idade_p)) then
		if (ie_regulamentacao_p = 'A') then
			if (current_setting('pls_segurado_preco_pck.pls_parametros_w')::pls_parametros%rowtype.ie_data_ref_reaj_adaptado = 'A') then
				dt_base_inclusao_w	:= dt_contratacao_p;
			elsif (current_setting('pls_segurado_preco_pck.pls_parametros_w')::pls_parametros%rowtype.ie_data_ref_reaj_adaptado = 'D') then
				select	max(nr_sequencia)
				into STRICT	nr_seq_mtvo_alteracao_w
				from	pls_motivo_alteracao_plano
				where	cd_ans	= '12';
				
				select	max(dt_alteracao)
				into STRICT	dt_adaptacao_w
				from	pls_segurado_alt_plano
				where	nr_seq_segurado		= nr_seq_segurado_p
				and	ie_situacao 		= 'A'
				and	nr_seq_motivo_alt	= nr_seq_mtvo_alteracao_w;
				
				dt_base_inclusao_w	:= coalesce(dt_adaptacao_w,dt_inclusao_operadora_p);
			else
				dt_base_inclusao_w	:= dt_inclusao_operadora_p;
			end if;
		else
			dt_base_inclusao_w	:= dt_inclusao_operadora_p;
		end if;
		
		qt_anos_operadora_w	:= trunc(months_between(dt_preco_p, dt_base_inclusao_w) / 12);
		
		if (qt_anos_operadora_w >= coalesce(qt_anos_limite_reaj_p,qt_anos_operadora_w)) then
			return 'N';
		else
			return 'S';
		end if;
	else
		return 'S';
	end if;
else
	return 'S';
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_segurado_preco_pck.obter_se_permite_reaj ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, dt_preco_p timestamp, qt_idade_limite_reaj_p pls_segurado.qt_idade_limite_reaj%type, qt_anos_limite_reaj_p pls_segurado.qt_anos_limite_reaj%type, qt_idade_p integer, ie_regulamentacao_p pls_plano.ie_regulamentacao%type, dt_contratacao_p pls_segurado.dt_contratacao%type, dt_inclusao_operadora_p pls_segurado.dt_inclusao_operadora%type) FROM PUBLIC;