-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_sessao_agenda_js ( nr_seq_agenda_p bigint, nr_atendimento_p bigint, ds_msg_p INOUT text, nm_usuario_p text) AS $body$
DECLARE

 
ie_tipo_atend_w		smallint;

BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	ie_tipo_atend_w := obter_tipo_atendimento(nr_atendimento_p);
	 
	if (ie_tipo_atend_w <> 1) and (ie_tipo_atend_w IS NOT NULL AND ie_tipo_atend_w::text <> '') then 
		begin 
		ds_msg_p := consistir_sessao_agenda(nr_seq_agenda_p, ds_msg_p);
		end;
	end if;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_sessao_agenda_js ( nr_seq_agenda_p bigint, nr_atendimento_p bigint, ds_msg_p INOUT text, nm_usuario_p text) FROM PUBLIC;

