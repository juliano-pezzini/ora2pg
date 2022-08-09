-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE considerar_itens_selec_consist ( nr_prescricao_p bigint, nr_seq_mat_p bigint, cd_material_p bigint, cd_funcao_p bigint, nr_cirurgia_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, cd_setor_atendimento_p bigint, cd_local_estoque_p bigint, nm_usuario_p text ) AS $body$
DECLARE


nr_sequencia_mat_w	bigint;
qt_material_w		double precision;
qt_disp_estoque_consig_w	double precision;
qt_disp_estoque_w		double precision;
ie_consiste_disponivel_w	varchar(1);
ie_consignado_w				varchar(1);
cd_fornec_consignado_w		varchar(14);
qt_conv_estoque_consumo_w	double precision;
ie_baixa_estoque_w		varchar(1);
ie_baixa_estoque_pac_w		varchar(1);


BEGIN

ie_consiste_disponivel_w := obter_param_usuario(900, 516, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_consiste_disponivel_w);


if  ((coalesce(nr_prescricao_p,0) > 0) and (coalesce(cd_material_p,0) > 0) and (coalesce(nr_seq_mat_p,0) > 0)) then

	select	max(coalesce(obter_se_material_estoque(cd_estabelecimento_p, cd_estabelecimento_p, cd_material),'S')),
		max(coalesce(obter_material_baixa_estoq_pac(cd_estabelecimento_p, cd_estabelecimento_p, cd_material),'S')),
		max(coalesce(cd_fornec_consignado,'0'))
	into STRICT	ie_baixa_estoque_w,
		ie_baixa_estoque_pac_w,
		cd_fornec_consignado_w
	from	prescr_material
	where	ie_status_cirurgia	= 'GI'
	and 	cd_motivo_baixa 	= 0
	and	cd_material 		= cd_material_p
	and	nr_sequencia		= nr_seq_mat_p
	and	nr_prescricao 		= nr_prescricao_p;

end if;

if (coalesce(nr_cirurgia_p,0)	> 0) and (ie_consiste_disponivel_w = 'S') then

		select 	coalesce(max(ie_consignado),'0')
		into STRICT	ie_consignado_w
		from 	material
		where 	cd_material = cd_material_p;

		select 	coalesce(max(qt_conv_estoque_consumo),1)
		into STRICT	qt_conv_estoque_consumo_w
		from 	material
		where 	cd_material = cd_material_p;

		select 	coalesce(sum(qt_material),0)
		into STRICT	qt_material_w
		from	prescr_material
		where	cd_material 			= cd_material_p
		and 	cd_motivo_baixa 		= 0
		and	nr_prescricao 			= nr_prescricao_p
		and	ie_status_cirurgia		= 'GI'
		and	coalesce(cd_fornec_consignado,'0')	= cd_fornec_consignado_w;

		if (ie_consignado_w = '0') and (ie_baixa_estoque_w = 'S') and (ie_baixa_estoque_pac_w = 'S') then

			qt_disp_estoque_w	:= obter_saldo_disp_estoque(cd_estabelecimento_p,cd_material_p,cd_local_estoque_p,trunc(clock_timestamp(),'dd'));

			if	(qt_disp_estoque_w < (qt_material_w/qt_conv_estoque_consumo_w)) then

				CALL Wheb_mensagem_pck.exibir_mensagem_abort(233389,'DS_ITEM_P=' || substr(obter_desc_material(cd_material_p),1,60) ||
										';QT_DISP_ESTOQUE_P=' || qt_disp_estoque_w ||
										';QT_MATERIAL_P=' || qt_material_w );

			end if;
		end if;

		if (ie_consignado_w = '1') and (ie_baixa_estoque_w = 'S') and (ie_baixa_estoque_pac_w = 'S') then

			qt_disp_estoque_consig_w	:= Obter_Saldo_Estoque_Consig(cd_estabelecimento_p,cd_fornec_consignado_w,cd_material_p,cd_local_estoque_p);

			if (qt_disp_estoque_consig_w < qt_material_w) then

				CALL Wheb_mensagem_pck.exibir_mensagem_abort(233393,'DS_ITEM_P=' || substr(obter_desc_material(cd_material_p),1,60) ||
										';QT_DISP_ESTOQUE_CONSIG_P=' || qt_disp_estoque_consig_w ||
										';QT_MATERIAL_P=' || qt_material_w );

			end if;
		end if;


		if (ie_consignado_w = '2') and (ie_baixa_estoque_w = 'S') and (ie_baixa_estoque_pac_w = 'S') then

			qt_disp_estoque_w	:= obter_saldo_disp_estoque(cd_estabelecimento_p,cd_material_p,cd_local_estoque_p,trunc(clock_timestamp(),'dd'));

			if (qt_disp_estoque_w < qt_material_w) and (cd_fornec_consignado_w <> '0') then

				qt_disp_estoque_consig_w	:= Obter_Saldo_Estoque_Consig(cd_estabelecimento_p,cd_fornec_consignado_w,cd_material_p,cd_local_estoque_p);

				if (qt_disp_estoque_consig_w < qt_material_w) then

					CALL Wheb_mensagem_pck.exibir_mensagem_abort(233389,'DS_ITEM_P=' || substr(obter_desc_material(cd_material_p),1,60) ||
										';QT_DISP_ESTOQUE_P=' || qt_disp_estoque_w ||
										';QT_MATERIAL_P=' || qt_material_w );

				end if;
			end if;
		end if;
end if;

	update	prescr_material
	set 	ie_status_cirurgia	= 'CB'
	where	ie_status_cirurgia	= 'GI'
	and 	cd_motivo_baixa 	= 0
	and	nr_prescricao 		= nr_prescricao_p
	and	nr_sequencia		= nr_seq_mat_p;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE considerar_itens_selec_consist ( nr_prescricao_p bigint, nr_seq_mat_p bigint, cd_material_p bigint, cd_funcao_p bigint, nr_cirurgia_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, cd_setor_atendimento_p bigint, cd_local_estoque_p bigint, nm_usuario_p text ) FROM PUBLIC;
