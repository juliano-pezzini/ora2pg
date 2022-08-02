-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_comunica_atend_menor_req ( nr_requisicao_p bigint, nr_seq_item_req_p bigint, cd_material_p bigint, qt_atendida_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


nm_usuario_destino_w				varchar(15);
ds_titulo_w					varchar(80);
ds_comunicacao_w				varchar(2000);
nr_seq_classif_w					bigint;
ds_material_w					varchar(255);
qt_requisitada_w					double precision;


BEGIN

if (coalesce(nr_seq_item_req_p ,0) = 0) then
	begin

	select	sum(qt_material_requisitada)
	into STRICT	qt_requisitada_w
	from	item_requisicao_material
	where	nr_requisicao = nr_requisicao_p
	and	cd_material = cd_material_p;

	end;
else
	begin

	select	qt_material_requisitada
	into STRICT	qt_requisitada_w
	from	item_requisicao_material
	where	nr_requisicao = nr_requisicao_p
	and	nr_sequencia = nr_seq_item_req_p;

	end;
end if;

select	ds_material
into STRICT	ds_material_w
from	material
where	cd_material = cd_material_p;

ds_titulo_w		:= WHEB_MENSAGEM_PCK.get_texto(306904,'NR_REQUISICAO_P='||nr_requisicao_p);

ds_comunicacao_w	:= substr(WHEB_MENSAGEM_PCK.get_texto(306906,'NR_REQUISICAO_P='||nr_requisicao_p||
						';DS_MATERIAL_W='||ds_material_w||
						';QT_REQUISITADA_W='||qt_requisitada_w||
						';QT_ATENDIDA_P='||qt_atendida_p||
						';DS_OBSERVACAO_P='||ds_observacao_p),1,2000);

select	obter_usuario_pessoa(cd_pessoa_requisitante)
into STRICT	nm_usuario_destino_w
from	requisicao_material
where	nr_requisicao = nr_requisicao_p;

if (nm_usuario_destino_w IS NOT NULL AND nm_usuario_destino_w::text <> '') then
	begin

	select	max(obter_classif_comunic('F'))
	into STRICT	nr_seq_classif_w
	;

	CALL Gerar_Comunic_Padrao(
		clock_timestamp(),
		ds_titulo_w,
		ds_comunicacao_w,
		nm_usuario_p,
		'N',
		nm_usuario_destino_w,
		'N',
		nr_seq_classif_w,
		'','','',clock_timestamp(),'','');

	commit;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_comunica_atend_menor_req ( nr_requisicao_p bigint, nr_seq_item_req_p bigint, cd_material_p bigint, qt_atendida_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;

