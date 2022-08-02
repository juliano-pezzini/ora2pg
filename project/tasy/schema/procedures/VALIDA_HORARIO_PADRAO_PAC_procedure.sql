-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE valida_horario_padrao_pac ( nr_atendimento_p cpoe_material.nr_atendimento%type, ds_horarios_p cpoe_material.ds_horarios%type, nr_seq_cpoe_p cpoe_material.nr_sequencia%type, ie_tipo_item_p text, ds_mensagem_out_p INOUT text, ds_valido_out_p INOUT text, dt_fim_out_p INOUT timestamp ) AS $body$
BEGIN

	ds_valido_out_p := 'S';
	dt_fim_out_p := null;
	ds_mensagem_out_p := null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE valida_horario_padrao_pac ( nr_atendimento_p cpoe_material.nr_atendimento%type, ds_horarios_p cpoe_material.ds_horarios%type, nr_seq_cpoe_p cpoe_material.nr_sequencia%type, ie_tipo_item_p text, ds_mensagem_out_p INOUT text, ds_valido_out_p INOUT text, dt_fim_out_p INOUT timestamp ) FROM PUBLIC;

