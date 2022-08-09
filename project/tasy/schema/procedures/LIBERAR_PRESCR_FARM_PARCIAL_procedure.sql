-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_prescr_farm_parcial ( nr_prescricao_p bigint, nr_seq_item_p bigint, nm_usuario_p text, ie_lib_parc_p text, ds_var_gera_solic_nao_padrao_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, qt_solic_compra_p INOUT bigint) AS $body$
DECLARE

vl_parametro_w		varchar(5);
qt_solic_compra_w		bigint := 0;
					

BEGIN 
 
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '')then 
	begin 
	 
	CALL liberar_prescricao_farmacia(nr_prescricao_p, nr_seq_item_p, nm_usuario_p, ie_lib_parc_p);
	 
	if (ds_var_gera_solic_nao_padrao_p = 'S')then 
		begin 
		 
		CALL gerar_solic_compra_prescricao(nr_prescricao_p, cd_estabelecimento_p, nm_usuario_p);
		 
		vl_parametro_w := obter_param_usuario(7010, 89, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);
		 
		if (vl_parametro_w = 'S')then 
			begin 
			 
			select 	coalesce(max(nr_solic_compra),0) 
			into STRICT	qt_solic_compra_w 
			from 	solic_compra 
			where 	nr_prescricao = nr_prescricao_p;
			 
			end;
		end if;
	 
		end;
	 
	end if;
	 
	end;
end if;
 
qt_solic_compra_p	:= qt_solic_compra_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_prescr_farm_parcial ( nr_prescricao_p bigint, nr_seq_item_p bigint, nm_usuario_p text, ie_lib_parc_p text, ds_var_gera_solic_nao_padrao_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, qt_solic_compra_p INOUT bigint) FROM PUBLIC;
