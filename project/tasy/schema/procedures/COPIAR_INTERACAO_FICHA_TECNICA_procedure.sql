-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_interacao_ficha_tecnica ( nr_seq_ficha_origem_p bigint, nr_seq_ficha_destino_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
BEGIN

if (coalesce(nr_seq_ficha_origem_p,0) > 0) and (coalesce(nr_seq_ficha_destino_p,0) > 0) then
	insert	into	material_interacao_medic(
			nr_sequencia,
			cd_material,
			dt_atualizacao,
			nm_usuario,
			cd_material_interacao,
			ie_severidade,
			ds_tipo,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_ficha,
			nr_seq_ficha_interacao,
			ds_orientacao,
			cd_grupo_material,
			cd_subgrupo_material,
			cd_classe_material,
			ie_exibir_gravidade,
			ie_mensagem_cadastrada,
			ds_ref_bibliografica,
			ie_consistir)
			SELECT	nextval('material_interacao_medic_seq'),
				cd_material,
				clock_timestamp(),
				nm_usuario_p,
				cd_material_interacao,
				ie_severidade,
				ds_tipo,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_ficha_destino_p,
				nr_seq_ficha_interacao,
				ds_orientacao,
				cd_grupo_material,
				cd_subgrupo_material,
				cd_classe_material,
				ie_exibir_gravidade,
				ie_mensagem_cadastrada,
				ds_ref_bibliografica,
				ie_consistir
			from	material_interacao_medic
			where	nr_seq_ficha = nr_seq_ficha_origem_p;
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_interacao_ficha_tecnica ( nr_seq_ficha_origem_p bigint, nr_seq_ficha_destino_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
