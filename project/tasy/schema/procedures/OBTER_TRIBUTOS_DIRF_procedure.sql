-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_tributos_dirf ( nr_sequencia_p bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter as regras
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_darf_w			dirf_regra_tributo.cd_darf%type;
cd_estabelecimento_w		dirf_lote_mensal.cd_estabelecimento%type;
cd_tributo_w			dirf_regra_tributo.cd_tributo%type;
ie_consistir_retencao_w 		dirf_regra_tributo.ie_consistir_retencao%type;
ie_nota_fiscal_w			dirf_regra_tributo.ie_nota_fiscal%type;
ie_tipo_data_w			dirf_regra_tributo.ie_tipo_data%type;
ie_tipo_pessoa_w			dirf_lote_mensal.ie_tipo_pessoa%type;
ie_trib_titulo_w			dirf_regra_tributo.ie_trib_titulo%type;
cd_empresa_w			dirf_lote_mensal.cd_empresa%type;
dt_mes_referencia_w		timestamp;
ie_incidencia_regra_w		dirf_regra_tributo.ie_incidencia%type;
ie_existe_pgto_imu_ise_w	dirf_regra_geral.ie_existe_pgto_imu_ise%type;

c_regra_trib CURSOR FOR
	SELECT	cd_tributo,
		cd_darf,
		ie_tipo_data,
		ie_consistir_retencao,
		coalesce(ie_trib_titulo, 'N') ie_trib_titulo,
		ie_nota_fiscal,
		ie_incidencia
	from	dirf_regra_tributo
	where	((ie_incidencia = ie_tipo_pessoa_w) or (ie_incidencia = 'A') or (ie_tipo_pessoa_w = 'A'))
	and	((cd_estabelecimento = cd_estabelecimento_w) or (coalesce(cd_estabelecimento::text, '') = ''));

BEGIN
-- Regra lote dirf
-- Tipo de pessoa que deve constar na DIRF e o mês de referência
select	ie_tipo_pessoa,
	dt_mes_referencia,
	cd_estabelecimento,
	cd_empresa
into STRICT	ie_tipo_pessoa_w,
	dt_mes_referencia_w,
	cd_estabelecimento_w,
	cd_empresa_w
from	dirf_lote_mensal
where	nr_sequencia	= nr_sequencia_p;

for registro in c_regra_trib
loop
	cd_tributo_w			:= registro.cd_tributo;
	cd_darf_w			:= registro.cd_darf;
	ie_tipo_data_w			:= registro.ie_tipo_data;
	ie_consistir_retencao_w		:= registro.ie_consistir_retencao;
	ie_trib_titulo_w			:= registro.ie_trib_titulo;
	ie_nota_fiscal_w			:= registro.ie_nota_fiscal;
	ie_incidencia_regra_w		:= registro.ie_incidencia;

	-- Regra para pessoa jurídica
	if	((ie_tipo_pessoa_w = 'J') or (ie_tipo_pessoa_w = 'A')) and
		((ie_incidencia_regra_w = 'J') or (ie_incidencia_regra_w = 'A')) then
		begin

		CALL obter_pj_dirf_titulo(	nr_sequencia_p,
					cd_estabelecimento_w,
					cd_tributo_w,
					cd_darf_w,
					ie_tipo_data_w,
					ie_consistir_retencao_w,
					dt_mes_referencia_w,
					ie_nota_fiscal_w,
					cd_empresa_w);


		/*obter_dirf_prod_med_retroativa(	nr_sequencia_p,
						cd_estabelecimento_w,
						cd_tributo_w,
						cd_darf_w,
						ie_tipo_data_w,
						ie_consistir_retencao_w,
						dt_mes_referencia_w,
						ie_trib_titulo_w,
						cd_empresa_w,
						'PJ');*/
		end;
	end if;

	if	((ie_tipo_pessoa_w = 'F') or (ie_tipo_pessoa_w = 'A')) and
		((ie_incidencia_regra_w = 'F') or (ie_incidencia_regra_w = 'A')) then
		begin
		CALL obter_pf_dirf_titulo(	nr_sequencia_p,
					cd_estabelecimento_w,
					cd_tributo_w,
					cd_darf_w,
					ie_tipo_data_w,
					ie_consistir_retencao_w,
					dt_mes_referencia_w,
					ie_nota_fiscal_w,
					cd_empresa_w);

		/*obter_dirf_prod_med_retroativa(	nr_sequencia_p,
					 	cd_estabelecimento_w,
						cd_tributo_w,
						cd_darf_w,
						ie_tipo_data_w,
						ie_consistir_retencao_w,
						dt_mes_referencia_w,
						ie_trib_titulo_w,
						cd_empresa_w,
						'PF');*/
		end;
	end if;
end loop;

if	((ie_tipo_pessoa_w = 'F') or (ie_tipo_pessoa_w = 'A')) then
	begin

	CALL obter_pf_dirf_isento(	nr_sequencia_p,
				cd_empresa_w,
				cd_estabelecimento_w,
				dt_mes_referencia_w);

	end;
end if;

select	obter_dados_dirf_estab(cd_estabelecimento_w, 'EII')
into STRICT	ie_existe_pgto_imu_ise_w
;

if	((ie_tipo_pessoa_w = 'J') or (ie_tipo_pessoa_w = 'A')) and (ie_existe_pgto_imu_ise_w = 'S') then
	begin

	obter_pj_dirf_imu_ise(	nr_sequencia_p,
				cd_empresa_w,
				cd_estabelecimento_w,
				dt_mes_referencia_w);

	end;
end if;

update	dirf_lote_mensal
set	dt_geracao	= clock_timestamp()
where	nr_sequencia	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_tributos_dirf ( nr_sequencia_p bigint) FROM PUBLIC;

