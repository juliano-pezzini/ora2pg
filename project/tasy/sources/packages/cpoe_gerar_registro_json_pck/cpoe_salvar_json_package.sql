-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE cpoe_gerar_registro_json_pck.cpoe_salvar_json ( nr_atendimento_p bigint, dt_referencia_p timestamp, nm_usuario_p text, ie_tipo_item_p text, ds_json_p text) AS $body$
BEGIN

insert into CPOE_JSON_ITEM(nr_atendimento,
						   nr_sequencia,
						   dt_atualizacao,
						   nm_usuario,
						   dt_atualizacao_nrec,
						   nm_usuario_nrec,
						   ie_tipo_item,
						   ds_json,
						   dt_referencia)
				   values (nr_atendimento_p,
						   nextval('cpoe_json_item_seq'),
						   clock_timestamp(),
						   nm_usuario_p,
						   clock_timestamp(),
						   nm_usuario_p,
						   IE_TIPO_ITEM_p,
						   DS_JSON_P,
						   trunc(dt_referencia_p));


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_registro_json_pck.cpoe_salvar_json ( nr_atendimento_p bigint, dt_referencia_p timestamp, nm_usuario_p text, ie_tipo_item_p text, ds_json_p text) FROM PUBLIC;
