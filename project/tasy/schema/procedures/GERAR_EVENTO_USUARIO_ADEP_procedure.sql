-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evento_usuario_adep (nm_usuario_p text, nr_atendimento_p bigint, dt_evento_p timestamp, ds_evento_p text, ds_objeto_p text, ds_param_p text) AS $body$
DECLARE


nr_seq_evento_w	bigint;


BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (dt_evento_p IS NOT NULL AND dt_evento_p::text <> '') and (ds_evento_p IS NOT NULL AND ds_evento_p::text <> '') and (ds_objeto_p IS NOT NULL AND ds_objeto_p::text <> '') and (ds_param_p IS NOT NULL AND ds_param_p::text <> '') then
	/* obter sequencia evento */

	select	nextval('w_adep_evento_seq')
	into STRICT	nr_seq_evento_w
	;

	/* gerar evento */

	insert into w_adep_evento(
					nr_sequencia,
					nm_usuario,
					nr_atend_evento,
					dt_evento,
					ds_evento,
					ds_obj_evento,
					ds_param
					)
	values (
					nr_seq_evento_w,
					nm_usuario_p,
					nr_atendimento_p,
					dt_evento_p,
					ds_evento_p,
					ds_objeto_p,
					ds_param_p
					);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evento_usuario_adep (nm_usuario_p text, nr_atendimento_p bigint, dt_evento_p timestamp, ds_evento_p text, ds_objeto_p text, ds_param_p text) FROM PUBLIC;
