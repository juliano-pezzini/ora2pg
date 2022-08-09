-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_protocolo_prescr (cd_protocolo_p bigint, cd_sub_tipo_protocolo_p bigint, itens_liberar_p text) AS $body$
DECLARE

 
ie_opcao_prescr_ww	 varchar(2000);
nr_seq_reg_item_w	 bigint;
ie_opcao_prescr_w	 varchar(255);
item_w				 varchar(255);


BEGIN 
	DELETE FROM protocolo_medic_material WHERE cd_protocolo = cd_protocolo_p AND nr_sequencia = cd_sub_tipo_protocolo_p;
	DELETE FROM protocolo_medic_solucao WHERE	cd_protocolo = cd_protocolo_p AND nr_sequencia	= cd_sub_tipo_protocolo_p;
	DELETE FROM protocolo_medic_jejum WHERE	cd_protocolo = cd_protocolo_p AND	nr_sequencia	= cd_sub_tipo_protocolo_p;
	DELETE FROM protocolo_medic_dieta WHERE	cd_protocolo 	= cd_protocolo_p AND	nr_sequencia	= cd_sub_tipo_protocolo_p;
	DELETE FROM protocolo_medic_npt WHERE	cd_protocolo	= cd_protocolo_p AND	nr_sequencia	= cd_sub_tipo_protocolo_p;
	DELETE FROM protocolo_medic_leite WHERE	cd_protocolo 	= cd_protocolo_p AND	nr_sequencia	= cd_sub_tipo_protocolo_p;
	DELETE FROM protocolo_medic_proc WHERE cd_protocolo = cd_protocolo_p AND nr_sequencia = cd_sub_tipo_protocolo_p;
	DELETE FROM protocolo_medic_gas WHERE cd_protocolo = cd_protocolo_p AND nr_seq_protocolo = cd_sub_tipo_protocolo_p;
	DELETE FROM protocolo_medic_rec WHERE cd_protocolo = cd_protocolo_p AND nr_sequencia = cd_sub_tipo_protocolo_p;
	DELETE FROM prot_solic_bco_sangue WHERE cd_protocolo = cd_protocolo_p AND nr_sequencia = cd_sub_tipo_protocolo_p;
	DELETE FROM protocolo_hd_prescricao WHERE cd_protocolo  = cd_protocolo_p AND nr_seq_protocolo = cd_sub_tipo_protocolo_p;
	DELETE FROM protocolo_medic_solucao WHERE cd_protocolo = cd_protocolo_p AND nr_sequencia = cd_sub_tipo_protocolo_p;
 
	ie_opcao_prescr_ww := itens_liberar_p;
 
	while(ie_opcao_prescr_ww IS NOT NULL AND ie_opcao_prescr_ww::text <> '') loop 
 
		if (position(';' in ie_opcao_prescr_ww)=0) and (ie_opcao_prescr_ww IS NOT NULL AND ie_opcao_prescr_ww::text <> '') then 
			ie_opcao_prescr_ww	:=ie_opcao_prescr_ww||';';
		end if;
 
		--Itens sendo enviados no formato:R,12;M,12345;D,1233;D,1234;M,2312; 
		item_w			  := substr(ie_opcao_prescr_ww, 1, position(';' in ie_opcao_prescr_ww)-1);
		ie_opcao_prescr_w := substr(item_w,1,position(',' in item_w)-1);
		nr_seq_reg_item_w := (substr(item_w, position(',' in item_w)+1, length(item_w)))::numeric;
 
		ie_opcao_prescr_ww := substr(ie_opcao_prescr_ww, position(';' in ie_opcao_prescr_ww)+1, length(ie_opcao_prescr_ww));
 
 
		if (ie_opcao_prescr_w IS NOT NULL AND ie_opcao_prescr_w::text <> '') then 
 
			case ie_opcao_prescr_w 
		 when 'MA' then--Material 
					begin 
						CALL gerar_protocolo_material(cd_protocolo_p,cd_sub_tipo_protocolo_p,nr_seq_reg_item_w);
					end;
				when 'M' then--Medicamento 
					begin 
						CALL gerar_protocolo_medicamento(cd_protocolo_p,cd_sub_tipo_protocolo_p,nr_seq_reg_item_w);
					end;
				when 'N' then--Nutricao 
					begin 
						CALL gerar_protocolo_dieta(cd_protocolo_p,cd_sub_tipo_protocolo_p,nr_seq_reg_item_w);
					end;
				when 'P' then--Procedimentos 
					begin 
						CALL gerar_protocolo_procedimento(cd_protocolo_p,cd_sub_tipo_protocolo_p,nr_seq_reg_item_w);
					end;
				when'G'then--Gasoterapia 
					begin 
						CALL gerar_protocolo_gasoterapia(cd_protocolo_p,cd_sub_tipo_protocolo_p,nr_seq_reg_item_w);
					end;
				when 'R' then--Recomendação 
					begin 
						CALL gerar_protocolo_recomendacao(cd_protocolo_p,cd_sub_tipo_protocolo_p,nr_seq_reg_item_w);
					end;
				when 'H' then--Hemoterapia 
					begin 
						CALL gerar_protocolo_hemoterapia(cd_protocolo_p,cd_sub_tipo_protocolo_p,nr_seq_reg_item_w);
					end;
				when 'DI' then--Dialysis 
					begin 
						CALL gerar_protocolo_dialise(cd_protocolo_p,cd_sub_tipo_protocolo_p,nr_seq_reg_item_w);
					end;
			end case;
		end if;
	end loop;
COMMIT;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_protocolo_prescr (cd_protocolo_p bigint, cd_sub_tipo_protocolo_p bigint, itens_liberar_p text) FROM PUBLIC;
