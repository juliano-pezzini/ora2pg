-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION new_icu_notifications_pck.get_all_new_orders () RETURNS SETOF T_OBJECT_CENTRAL_NOTICES AS $body$
DECLARE


t_objeto_row_w    	t_central_notices;
cd_pessoa_fisica_w  varchar(10);
qt_items_w      	bigint := 0;
ds_conteudo_w    	varchar(4000);
ie_medico_w      	varchar(1);
ie_notification_w  	varchar(2);
ds_login_w      	subject.ds_login%type;

usuarios_logados CURSOR FOR
	SELECT 	distinct(a.ds_login)
	from    subject_activity_log b,
			subject a
	where   a.id = b.id_subject
	and     trunc(b.dt_creation) between clock_timestamp() - interval '1 days' and clock_timestamp() + interval '86399 days'/86400
	and     trunc(b.dt_expiration) >= trunc(clock_timestamp());

c01 CURSOR FOR
	SELECT	a.nr_atendimento,
			a.cd_pessoa_fisica
  from 		atendimento_paciente a
  where   	((ie_medico_w = 'S' and (a.cd_medico_resp = cd_pessoa_fisica_w or obter_se_medico_assistente(a.nr_atendimento, cd_pessoa_fisica_w, ds_login_w, 36) = 'S'))
  or (ie_medico_w = 'N' and obter_enfermeiro_resp(a.nr_atendimento,'C') = cd_pessoa_fisica_w))
  and   	coalesce(a.dt_alta::text, '') = '';
BEGIN

	CALL new_icu_notifications_pck.verify_execution('get_all_new_orders');

	for usuarios_logado_w in usuarios_logados
	loop
		ds_login_w      := '';
		ie_notification_w  := '';
		ds_login_w      := usuarios_logado_w.ds_login;
		cd_pessoa_fisica_w   := obter_codigo_usuario(ds_login_w);
		ie_medico_w     := obter_se_usuario_medico(ds_login_w);
		obter_param_usuario(0, 239, 0, usuarios_logado_w.ds_login, 0, ie_notification_w);

		if (ie_notification_w = 'X') then

			for c01_w in c01
			loop

				qt_items_w := new_icu_notifications_pck.get_new_orders_items(c01_w.nr_atendimento);

				if (coalesce(qt_items_w, 0) > 0) then
					t_objeto_row_w.ds_titulo       := obter_nome_paciente(c01_w.nr_atendimento);
					t_objeto_row_w.dt_criacao       := clock_timestamp();
					t_objeto_row_w.nm_usuarios_destino  := ds_login_w;
					t_objeto_row_w.ds_conteudo      := wheb_mensagem_pck.get_texto(1119570,'DS_TOTAL_P='||'('||qt_items_w||')');
					RETURN NEXT t_objeto_row_w;
				end if;

			end loop;
		end if;
	end loop;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION new_icu_notifications_pck.get_all_new_orders () FROM PUBLIC;
