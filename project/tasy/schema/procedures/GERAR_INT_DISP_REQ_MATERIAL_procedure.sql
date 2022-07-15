-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_int_disp_req_material ( nr_requisicao_p int_disp_req_material.nr_requisicao%type, nr_ordem_compra_p int_disp_req_material.nr_ordem_compra%type, cd_acao_p int_disp_req_material.cd_acao%type, cd_material_p int_disp_req_material.cd_material%type, qt_material_atend_p int_disp_req_material.qt_material_atendida%type, nr_lote_fornec_p int_disp_req_material.nr_seq_lote_fornec%type, cd_barras_p int_disp_req_material.cd_barras%type, cd_local_estoque_p local_estoque.cd_local_estoque%type) AS $body$
DECLARE


cd_local_estoque_w		local_estoque.cd_local_estoque%type;
dt_validade_w			material_lote_fornec.dt_validade%type;


BEGIN

select	coalesce(max(cd_local_estoque),0)
into STRICT	cd_local_estoque_w
from	dis_regra_local_setor
where	cd_local_estoque = cd_local_estoque_p;

if (cd_local_estoque_w > 0) then
	
	if (nr_lote_fornec_p IS NOT NULL AND nr_lote_fornec_p::text <> '') then
		select	max(dt_validade)
		into STRICT	dt_validade_w
		from	material_lote_fornec
		where	nr_sequencia = nr_lote_fornec_p;
	end if;

	insert into int_disp_req_material(
				nr_sequencia,
				nr_ordem_compra,
				nr_requisicao,
				dt_leitura,
				cd_acao,
				cd_material,
				qt_material_atendida,
				nr_seq_lote_fornec,
				dt_validade,
				cd_estabelecimento,
				cd_barras,
				dt_atualizacao)
			values (	nextval('int_disp_req_material_seq'),
				nr_ordem_compra_p,
				nr_requisicao_p,
				null,
				cd_acao_p,
				cd_material_p,
				qt_material_atend_p,
				nr_lote_fornec_p,
				dt_validade_w,
				wheb_usuario_pck.get_cd_estabelecimento,
				cd_barras_p,
				clock_timestamp());
end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_int_disp_req_material ( nr_requisicao_p int_disp_req_material.nr_requisicao%type, nr_ordem_compra_p int_disp_req_material.nr_ordem_compra%type, cd_acao_p int_disp_req_material.cd_acao%type, cd_material_p int_disp_req_material.cd_material%type, qt_material_atend_p int_disp_req_material.qt_material_atendida%type, nr_lote_fornec_p int_disp_req_material.nr_seq_lote_fornec%type, cd_barras_p int_disp_req_material.cd_barras%type, cd_local_estoque_p local_estoque.cd_local_estoque%type) FROM PUBLIC;

