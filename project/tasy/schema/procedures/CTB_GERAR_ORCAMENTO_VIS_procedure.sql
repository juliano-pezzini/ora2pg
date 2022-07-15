-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_orcamento_vis ( cd_empresa_p bigint, cd_estab_p bigint, cd_centro_custo_p bigint, ie_tipo_visual_p bigint, ie_tipo_valor_p bigint, nr_seq_mes_inicial_p bigint, nr_seq_mes_final_p bigint, nr_seq_tipo_estrutura_p bigint, nr_seq_cenario_p bigint, ie_centro_titulo_p text, nm_usuario_p text, cd_conta_contabil_p text, nr_seq_grupo_centro_p bigint, ie_consolida_holding_p text default 'N') AS $body$
DECLARE

					

ie_consolida_holding_w varchar(2);


BEGIN

ie_consolida_holding_w := coalesce(ie_consolida_holding_p, 'N');

delete	from w_ctb_orcamento_vis
where	nm_usuario = nm_usuario_p;

if (ie_tipo_visual_p = 0) then
	CALL ctb_gerar_acomp_analitico(	cd_empresa_p,	cd_estab_p, cd_centro_custo_p, ie_tipo_visual_p, ie_tipo_valor_p,
				nr_seq_mes_inicial_p, nr_seq_mes_final_p, nm_usuario_p,cd_conta_contabil_p, nr_seq_grupo_centro_p, ie_consolida_holding_w);
elsif (ie_tipo_visual_p = 1) then
	CALL CTB_GERAR_ACOMP_PADRAO(	cd_empresa_p,	cd_estab_p, cd_centro_custo_p, ie_tipo_visual_p, ie_tipo_valor_p,
					nr_seq_mes_inicial_p, nr_seq_mes_final_p, nm_usuario_p,cd_conta_contabil_p,ie_centro_titulo_p, ie_consolida_holding_w);
elsif (ie_tipo_visual_p = 2) then
	CALL CTB_GERAR_ACOMP_DRE(	cd_empresa_p,	cd_estab_p, cd_centro_custo_p, ie_tipo_visual_p, ie_tipo_valor_p,
				nr_seq_mes_inicial_p, nr_seq_mes_final_p, nr_seq_tipo_estrutura_p, nr_seq_cenario_p, ie_centro_titulo_p, nm_usuario_p,
				cd_conta_contabil_p, nr_seq_grupo_centro_p, ie_consolida_holding_w);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_orcamento_vis ( cd_empresa_p bigint, cd_estab_p bigint, cd_centro_custo_p bigint, ie_tipo_visual_p bigint, ie_tipo_valor_p bigint, nr_seq_mes_inicial_p bigint, nr_seq_mes_final_p bigint, nr_seq_tipo_estrutura_p bigint, nr_seq_cenario_p bigint, ie_centro_titulo_p text, nm_usuario_p text, cd_conta_contabil_p text, nr_seq_grupo_centro_p bigint, ie_consolida_holding_p text default 'N') FROM PUBLIC;

