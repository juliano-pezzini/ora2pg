-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE kodip_pck.generate_items_reg ( ie_tipo_item_p text, dt_item_p timestamp, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_doenca_p text, ie_origem_item_p text, qt_horas_resp_p bigint, nr_seq_propaci_p bigint) AS $body$
DECLARE


index_w			bigint;
		

BEGIN
index_w	:=	current_setting('kodip_pck.t_reg_itens_w')::t_reg_itens.count;

current_setting('kodip_pck.t_reg_itens_w')::t_reg_itens[index_w].ie_tipo_item		:= ie_tipo_item_p;
current_setting('kodip_pck.t_reg_itens_w')::t_reg_itens[index_w].dt_item		:= dt_item_p;
current_setting('kodip_pck.t_reg_itens_w')::t_reg_itens[index_w].cd_procedimento	:= cd_procedimento_p;
current_setting('kodip_pck.t_reg_itens_w')::t_reg_itens[index_w].ie_origem_proced	:= ie_origem_proced_p;
current_setting('kodip_pck.t_reg_itens_w')::t_reg_itens[index_w].cd_doenca		:= cd_doenca_p;
current_setting('kodip_pck.t_reg_itens_w')::t_reg_itens[index_w].ie_origem_item		:= ie_origem_item_p;
current_setting('kodip_pck.t_reg_itens_w')::t_reg_itens[index_w].qt_horas_resp		:= qt_horas_resp_p;
current_setting('kodip_pck.t_reg_itens_w')::t_reg_itens[index_w].nr_seq_propaci		:= nr_seq_propaci_p;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE kodip_pck.generate_items_reg ( ie_tipo_item_p text, dt_item_p timestamp, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_doenca_p text, ie_origem_item_p text, qt_horas_resp_p bigint, nr_seq_propaci_p bigint) FROM PUBLIC;