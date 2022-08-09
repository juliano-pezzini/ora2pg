-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_inspecao_contagem ( nr_seq_registro_p bigint, nr_seq_inspecao_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*Primeira Contagem*/

cd_condicao_pagamento_um_w	bigint;
ds_condicao_pagamento_um_w	varchar(255);
ie_temperatura_um_w                     	varchar(20);
pr_desconto_um_w                        	double precision;
qt_inspecao_um_w                      	double precision;
vl_desconto_um_w                        	double precision;
vl_unitario_material_um_w		double precision;

/*Segunda Contagem*/

cd_condicao_pagamento_dois_w            bigint;
ds_condicao_pagamento_dois_w            varchar(255);
ie_temperatura_dois_w                   	varchar(20);
pr_desconto_dois_w		double precision;
qt_inspecao_dois_w                      	double precision;
vl_desconto_dois_w                      	double precision;
vl_unitario_material_dois_w		double precision;

cd_material_w			bigint;
qt_registro_w			bigint;
nr_ordem_compra_w		bigint;
nr_item_oci_w			bigint;
qt_registro_div_w			bigint;

qt_inspecao_w			double precision;
cd_estabelecimento_w		bigint;
ie_consiste_temperatura_w	varchar(1);


BEGIN

cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;

select	coalesce(obter_valor_param_usuario(270, 91, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'S')
into STRICT	ie_consiste_temperatura_w
;

delete 	FROM insp_contagem_consiste
where	nm_usuario_contagem = nm_usuario_p
and	nr_seq_inspecao = nr_seq_inspecao_p;

select	max(nr_ordem_compra),
	max(nr_item_oci),
	max(cd_material)
into STRICT	nr_ordem_compra_w,
	nr_item_oci_w,
	cd_material_w
from	inspecao_recebimento
where	nr_Sequencia = nr_seq_inspecao_p;

select	coalesce(cd_condicao_pagamento,0),
	coalesce(ie_temperatura,wheb_mensagem_pck.get_texto(312421)),
	coalesce(pr_desconto,0),
	coalesce(qt_inspecao,0),
	coalesce(vl_desconto,0),
	coalesce(vl_unitario_material,0),
	cd_material
into STRICT	cd_condicao_pagamento_um_w,
	ie_temperatura_um_w,
	pr_desconto_um_w,
	qt_inspecao_um_w,
	vl_desconto_um_w,
	vl_unitario_material_um_w,
	cd_material_w
from   	inspecao_contagem
where   nr_seq_inspecao = nr_seq_inspecao_p
and     nr_seq_contagem = 1;

select  	coalesce(cd_condicao_pagamento,0),
	coalesce(ie_temperatura,wheb_mensagem_pck.get_texto(312421)),
	coalesce(pr_desconto,0),
	coalesce(qt_inspecao,0),
	coalesce(vl_desconto,0),
	coalesce(vl_unitario_material,0)
into STRICT	cd_condicao_pagamento_dois_w,
	ie_temperatura_dois_w,
	pr_desconto_dois_w,
	qt_inspecao_dois_w,
	vl_desconto_dois_w,
	vl_unitario_material_dois_w
from    	inspecao_contagem
where   	nr_seq_inspecao = nr_seq_inspecao_p
and     	nr_seq_contagem = 2;

if (cd_condicao_pagamento_um_w <> cd_condicao_pagamento_dois_w) then
	select	CASE WHEN cd_condicao_pagamento_um_w=0 THEN  wheb_mensagem_pck.get_texto(312421)  ELSE substr(obter_desc_cond_pagto(cd_condicao_pagamento_um_w),1,255) END ,
		CASE WHEN cd_condicao_pagamento_dois_w=0 THEN  wheb_mensagem_pck.get_texto(312421)  ELSE substr(obter_desc_cond_pagto(cd_condicao_pagamento_dois_w),1,255) END
	into STRICT	ds_condicao_pagamento_um_w,
		ds_condicao_pagamento_dois_w
	;

	CALL grava_inconsistencia_contagem( 	nr_seq_inspecao_p,
					cd_material_w,
					wheb_mensagem_pck.get_texto(312422), --ds_campo_p
					ds_condicao_pagamento_um_w,  --ds_contagem_um_p
					ds_condicao_pagamento_dois_w, --ds_contagem_dois_p
					'ICP',
					wheb_mensagem_pck.get_texto(312423), --ds_consistencia_p,
					nm_usuario_p);
end if;

if (ie_consiste_temperatura_w = 'S') and (ie_temperatura_um_w <> ie_temperatura_dois_w) then
	CALL grava_inconsistencia_contagem(	nr_seq_inspecao_p,
					cd_material_w,
					wheb_mensagem_pck.get_texto(312424), --ds_campo_p
					ie_temperatura_um_w, --ds_contagem_um_p
					ie_temperatura_dois_w, --ds_contagem_dois_p
					'ITE',
					wheb_mensagem_pck.get_texto(312425), --ds_consistencia_p,
					nm_usuario_p);
end if;

if (pr_desconto_um_w <> pr_desconto_dois_w) then
	CALL grava_inconsistencia_contagem( nr_seq_inspecao_p,
					cd_material_w,
					wheb_mensagem_pck.get_texto(312426), --ds_campo_p
					pr_desconto_um_w, --ds_contagem_um_p
					pr_desconto_dois_w, --ds_contagem_dois_p
					'IPD',
					wheb_mensagem_pck.get_texto(312427), --ds_consistencia_p,
					nm_usuario_p);
end if;

if (qt_inspecao_um_w <> qt_inspecao_dois_w) then
	CALL grava_inconsistencia_contagem( 	nr_seq_inspecao_p,
					cd_material_w,
					wheb_mensagem_pck.get_texto(312428), --ds_campo_p
					qt_inspecao_um_w, --ds_contagem_um_p
					qt_inspecao_dois_w, --ds_contagem_dois_p
					'IQT',
					wheb_mensagem_pck.get_texto(312429), --ds_consistencia_p,
					nm_usuario_p);
end if;

if (vl_desconto_um_w <> vl_desconto_dois_w) then
	CALL grava_inconsistencia_contagem( 	nr_seq_inspecao_p,
					cd_material_w,
					wheb_mensagem_pck.get_texto(312430), --ds_campo_p
					vl_desconto_um_w, --ds_contagem_um_p
					vl_desconto_dois_w, --ds_contagem_dois_p
					'IVD',
					wheb_mensagem_pck.get_texto(312431), --ds_consistencia_p,
					nm_usuario_p);
end if;

if (vl_unitario_material_um_w <> vl_unitario_material_dois_w) then
	CALL grava_inconsistencia_contagem(	nr_seq_inspecao_p,
					cd_material_w,
					wheb_mensagem_pck.get_texto(312432), --ds_campo_p
					vl_unitario_material_um_w, --ds_contagem_um_p
					vl_unitario_material_dois_w, --ds_contagem_dois_p
					'IVU',
					wheb_mensagem_pck.get_texto(312433), --ds_consistencia_p,
					nm_usuario_p);
end if;

CALL consiste_inspecao_cont_lote(	nr_seq_registro_p,
			nr_seq_inspecao_p,
			nm_usuario_p);

select	count(*)
into STRICT	qt_registro_w
from	inspecao_contagem
where	nr_seq_inspecao = nr_seq_inspecao_p
and	nr_seq_contagem = 3;

select	count(*)
into STRICT	qt_registro_div_w
from	insp_contagem_consiste
where	nr_seq_inspecao = nr_seq_inspecao_p;

if (qt_registro_w = 0) and (qt_registro_div_w > 0) then

	select	qt_inspecao
	into STRICT	qt_inspecao_w
	from	inspecao_recebimento
	where	nr_sequencia = nr_seq_inspecao_p;

	insert into inspecao_contagem(
		nr_sequencia,
		nr_seq_inspecao,
		nr_seq_registro,
		nr_seq_contagem,
		nr_ordem_compra,
		nr_item_oci,
		cd_material,
		dt_atualizacao,
		nm_usuario,
		qt_inspecao,
		ie_externo,
		ie_interno,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_temperatura,
		ie_laudo,
		ie_motivo_devolucao,
		vl_unitario_material,
		dt_entrega_real,
		pr_desconto,
		vl_desconto,
		cd_condicao_pagamento)
	values (nextval('inspecao_contagem_seq'),
		nr_seq_inspecao_p,
		nr_seq_registro_p,
		3, -- Primeira Contagem
		nr_ordem_compra_w,
		nr_item_oci_w,
		cd_material_w,
		clock_timestamp(), -- dt_atualizacao
		nm_usuario_p,
		qt_inspecao_w, -- qt_inspecao
		'N', -- ie_externo
		'N', -- ie_interno
		clock_timestamp(),
		nm_usuario_p,
		'', -- ie_temperatura
		'N', -- ie_laudo
		'', -- ie_motivo_devolucao
		null, -- vl_unitario_material
		trunc(clock_timestamp()), -- dt_entrega_real
		'', -- pr_desconto
		'', -- vl_desconto
		''); -- cd_condicao_pagamento
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_inspecao_contagem ( nr_seq_registro_p bigint, nr_seq_inspecao_p bigint, nm_usuario_p text) FROM PUBLIC;
