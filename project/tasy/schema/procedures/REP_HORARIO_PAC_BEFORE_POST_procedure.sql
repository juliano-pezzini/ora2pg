-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rep_horario_pac_before_post ( cd_item_p text, nr_prescricoes_p text, ds_horarios_p text, nr_atendimento_p bigint, nm_usuario_p text, ie_tipo_item_p text, cd_procedimento_p text) AS $body$
DECLARE


ds_erro_w	varchar(255);


BEGIN

if (cd_item_p IS NOT NULL AND cd_item_p::text <> '') and (nr_prescricoes_p IS NOT NULL AND nr_prescricoes_p::text <> '') and (ds_horarios_p IS NOT NULL AND ds_horarios_p::text <> '') and (nr_atendimento_p > 0) then
	begin
	ds_erro_w := Consistir_horarios_padroes(	cd_item_p, nr_prescricoes_p, ds_horarios_p, 0, ds_erro_w);

	if (coalesce(ds_erro_w::text, '') = '')then
		CALL Atualizar_rep_horario_pac(	nr_atendimento_p,
						cd_item_p,
						nm_usuario_p,
						ie_tipo_item_p,
						cd_procedimento_p);
	else
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(238415,'DS_ERRO_W='||ds_erro_w);
	end if;
	end;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rep_horario_pac_before_post ( cd_item_p text, nr_prescricoes_p text, ds_horarios_p text, nr_atendimento_p bigint, nm_usuario_p text, ie_tipo_item_p text, cd_procedimento_p text) FROM PUBLIC;

