-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE se_material_atend_paciente_js ( cd_material_p bigint, cd_local_estoque_p bigint, cd_estabelecimento_p bigint, qt_baixa_estoque_p bigint, qt_baixa_consumo_p bigint, cd_cgc_fornecedor_p text, nm_usuario_p text, cd_unidade_baixa_p text) AS $body$
DECLARE


permite_estoque_negativo_w	varchar(1);
disp_estoque_w			varchar(1);
ds_local_w			varchar(255);
qt_material_w			double precision;


BEGIN
select	max(EME_OBTER_DOSE_CONV(cd_unidade_baixa_p,cd_material_p,qt_baixa_consumo_p,cd_estabelecimento_p))
into STRICT	qt_material_w
;

permite_estoque_negativo_w := obter_param_usuario(929, 21, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, permite_estoque_negativo_w);
disp_estoque_w := obter_disp_estoque(cd_material_p, cd_local_estoque_p, cd_estabelecimento_p, qt_baixa_estoque_p, qt_material_w, cd_cgc_fornecedor_p, disp_estoque_w);

if (permite_estoque_negativo_w = 'N') and (disp_estoque_w = 'N') then
	begin
		select	ds_local_estoque
		into STRICT 	ds_local_w
		from	local_estoque
		where	cd_local_estoque = cd_local_estoque_p;


	CALL Wheb_mensagem_pck.exibir_mensagem_abort(67850,'CD_MATERIAL='|| cd_material_p || ';CD_LOCAL_ESTOQUE='|| cd_local_estoque_p || ';DS_LOCAL='|| ds_local_w);
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE se_material_atend_paciente_js ( cd_material_p bigint, cd_local_estoque_p bigint, cd_estabelecimento_p bigint, qt_baixa_estoque_p bigint, qt_baixa_consumo_p bigint, cd_cgc_fornecedor_p text, nm_usuario_p text, cd_unidade_baixa_p text) FROM PUBLIC;
