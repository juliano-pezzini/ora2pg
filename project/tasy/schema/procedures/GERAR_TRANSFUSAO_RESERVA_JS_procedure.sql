-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_transfusao_reserva_js ( nr_seq_reserva_p bigint, nr_lista_reserva_prod_p text, ie_opcao_p bigint, ie_gerar_transfusao_p text, cd_pf_realizou_p text, ie_data_atual_p text, ie_data_utilizacao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_transfusao_p INOUT bigint, ds_msg_reserva_gerada_p INOUT text, ds_msg_transf_gerada_p INOUT text) AS $body$
DECLARE

 
nr_seq_reserva_nova_w	bigint;


BEGIN 
 
nr_seq_reserva_nova_w := san_gerar_reserva_parcial( 
	nr_seq_reserva_p, nr_lista_reserva_prod_p, nm_usuario_p, ie_opcao_p, nr_seq_reserva_nova_w);
 
if (coalesce(nr_seq_reserva_nova_w, 0) > 0) then 
	begin 
	ds_msg_reserva_gerada_p	:= obter_texto_dic_objeto(83435, wheb_usuario_pck.get_nr_seq_idioma, 'NR_SEQ_RESERVA=' || nr_seq_reserva_nova_w);
 
	if (ie_gerar_transfusao_p = 'S') and (ie_opcao_p = 4)	then 
		begin 
		nr_seq_transfusao_p := gerar_transfusao_reserva( 
			nr_seq_reserva_p, cd_pf_realizou_p, nm_usuario_p, ie_data_atual_p, ie_data_utilizacao_p, cd_estabelecimento_p, nr_seq_transfusao_p);
 
		ds_msg_transf_gerada_p	:= obter_texto_tasy(83436, wheb_usuario_pck.get_nr_seq_idioma);
		end;
	end if;
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_transfusao_reserva_js ( nr_seq_reserva_p bigint, nr_lista_reserva_prod_p text, ie_opcao_p bigint, ie_gerar_transfusao_p text, cd_pf_realizou_p text, ie_data_atual_p text, ie_data_utilizacao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_transfusao_p INOUT bigint, ds_msg_reserva_gerada_p INOUT text, ds_msg_transf_gerada_p INOUT text) FROM PUBLIC;

