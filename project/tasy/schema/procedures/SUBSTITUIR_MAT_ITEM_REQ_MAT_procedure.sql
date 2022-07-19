-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE substituir_mat_item_req_mat ( cd_material_p bigint, cd_unidade_medida_p text, cd_unidade_medida_estoque_p text, cd_motivo_baixa_p bigint, qt_material_atendida_p bigint, cd_cgc_fornecedor_p text, nr_sequencia_p bigint, nr_requisicao_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_requisicao_p IS NOT NULL AND nr_requisicao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	update	item_requisicao_material
	set	cd_material = cd_material_p,
		cd_unidade_medida = cd_unidade_medida_p,
		cd_unidade_medida_estoque = cd_unidade_medida_estoque_p,
		cd_motivo_baixa = cd_motivo_baixa_p,
		qt_material_atendida = qt_material_atendida_p,
		cd_cgc_fornecedor = cd_cgc_fornecedor_p,
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_sequencia_p
	and	nr_requisicao = nr_requisicao_p;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE substituir_mat_item_req_mat ( cd_material_p bigint, cd_unidade_medida_p text, cd_unidade_medida_estoque_p text, cd_motivo_baixa_p bigint, qt_material_atendida_p bigint, cd_cgc_fornecedor_p text, nr_sequencia_p bigint, nr_requisicao_p bigint, nm_usuario_p text) FROM PUBLIC;

