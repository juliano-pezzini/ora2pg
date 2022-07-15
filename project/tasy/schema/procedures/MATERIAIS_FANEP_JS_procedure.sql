-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE materiais_fanep_js ( cd_pasta_selec_p bigint, cd_estabelecimento_p bigint, nr_seq_agente_p bigint, nr_cirurgia_p bigint, cd_material_p bigint, cd_profissional_p text, nm_usuario_p text, ie_via_aplicacao_p text, cd_unidade_medida_p text, ie_tipo_dosagem_p text, nr_seq_pepo_p bigint, ie_modo_adm_p text, nr_seq_tec_p bigint, ds_lista_tec_p text, ds_lista_desc_p INOUT text,--varchar2,				
 cd_equipamento_p bigint, nr_seq_equipamento_p bigint, nr_seq_topografia_p bigint, ie_lado_p text, dt_inicio_p timestamp, dt_fim_p timestamp ) AS $body$
DECLARE


nr_sequencia_w  	bigint;
				

BEGIN

	if (cd_pasta_selec_p IS NOT NULL AND cd_pasta_selec_p::text <> '') then
		begin
		
		if (cd_pasta_selec_p in (10, 13, 14, 15, 19))then
			begin
		
			nr_sequencia_w := gerar_agentes_medicamentos(	cd_estabelecimento_p, nr_seq_agente_p, nr_cirurgia_p, cd_material_p, cd_profissional_p, nm_usuario_p, nr_sequencia_w, ie_via_aplicacao_p, cd_unidade_medida_p, ie_tipo_dosagem_p, nr_seq_pepo_p, ie_modo_adm_p);	
		
			end;
		end if;
		
		if (cd_pasta_selec_p = 11) then
			begin
				
			ds_lista_desc_p := gerar_tecnica_anestesica( 	nr_seq_tec_p, nm_usuario_p, nr_cirurgia_p, cd_profissional_p, nr_seq_pepo_p, ds_lista_tec_p, ds_lista_desc_p);
		
			end;
		end if;
		
		if (cd_pasta_selec_p = 12) then
			begin
				
			nr_sequencia_w := gerar_equipamentos_cirurgia(	cd_equipamento_p, nr_cirurgia_p, cd_profissional_p, nm_usuario_p, nr_sequencia_w, nr_seq_pepo_p, nr_seq_topografia_p, ie_lado_p, dt_inicio_p, dt_fim_p);

			CALL gerar_taxa_equipamento(	cd_estabelecimento_p,
							nr_sequencia_w,
							nm_usuario_p);
				
			CALL gerar_material_equipamento(	cd_estabelecimento_p,
							nr_seq_equipamento_p,
							nm_usuario_p);
				
			end;	
		end if;
		
		end;
	end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE materiais_fanep_js ( cd_pasta_selec_p bigint, cd_estabelecimento_p bigint, nr_seq_agente_p bigint, nr_cirurgia_p bigint, cd_material_p bigint, cd_profissional_p text, nm_usuario_p text, ie_via_aplicacao_p text, cd_unidade_medida_p text, ie_tipo_dosagem_p text, nr_seq_pepo_p bigint, ie_modo_adm_p text, nr_seq_tec_p bigint, ds_lista_tec_p text, ds_lista_desc_p INOUT text, cd_equipamento_p bigint, nr_seq_equipamento_p bigint, nr_seq_topografia_p bigint, ie_lado_p text, dt_inicio_p timestamp, dt_fim_p timestamp ) FROM PUBLIC;

