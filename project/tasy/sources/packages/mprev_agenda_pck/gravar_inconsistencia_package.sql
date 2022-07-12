-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	/*---------------------------------------------------------------------------------------------------------------------------------------------
	|			GRAVAR_INCONSISTENCIA				|
	*/
	/* Grava a inconsistencia */

CREATE OR REPLACE PROCEDURE mprev_agenda_pck.gravar_inconsistencia (dados_agenda_p dados_agendamento, nr_seq_mensagem_p bigint, ds_macros_p text, ie_tipo_inconsist_p text, /* (E,C,A)(Erro,Confirmacao,Alerta) */
 ie_inconsistencia_p text, /* Dominio:  6080 */
 ds_inconsistencia_p text, nm_usuario_p text) AS $body$
DECLARE


	ds_erro_w	varchar(2000);
	qt_registros_w	bigint;

	
BEGIN

	if (nr_seq_mensagem_p IS NOT NULL AND nr_seq_mensagem_p::text <> '') then
		begin
			CALL wheb_mensagem_pck.exibir_mensagem_abort(nr_seq_mensagem_p, ds_macros_p);
		exception
		when others then
			ds_erro_w := substr(substr(SQLERRM, 12, length(SQLERRM)-15),1,2000);
		end;
	else
		ds_erro_w := substr(ds_inconsistencia_p,1,2000);
	end if;


	select 	count(1)
	into STRICT	qt_registros_w
	from	w_mprev_agenda_inconsist
	where	nm_usuario = dados_agenda_p.nm_usuario
	and	cd_agenda  =  dados_agenda_p.cd_agenda;
	

	/* [OS-1732052] inconsistencias devem ser geradas mais de uma vez */

	insert	into	w_mprev_agenda_inconsist(nr_sequencia, dt_atualizacao, nm_usuario,
			cd_agenda, ie_tipo, ie_inconsistencia,
			ds_mensagem, nr_seq_participante, nr_seq_turma)
		values (nextval('w_mprev_agenda_inconsist_seq'), clock_timestamp(), nm_usuario_p,
			dados_agenda_p.cd_agenda, ie_tipo_inconsist_p, ie_inconsistencia_p,
			ds_erro_w, dados_agenda_p.nr_seq_participante, dados_agenda_p.nr_seq_turma);

	if (ie_tipo_inconsist_p = 'C') then
		PERFORM set_config('mprev_agenda_pck.qt_mensagens_confirm_w', current_setting('mprev_agenda_pck.qt_mensagens_confirm_w')::smallint + 1, false);
	elsif (ie_tipo_inconsist_p = 'A') then
		PERFORM set_config('mprev_agenda_pck.qt_mensagens_atencao_w', current_setting('mprev_agenda_pck.qt_mensagens_atencao_w')::smallint + 1, false);
	else
		PERFORM set_config('mprev_agenda_pck.qt_mensagens_erro_w', current_setting('mprev_agenda_pck.qt_mensagens_erro_w')::smallint +1, false);
	end if;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_agenda_pck.gravar_inconsistencia (dados_agenda_p dados_agendamento, nr_seq_mensagem_p bigint, ds_macros_p text, ie_tipo_inconsist_p text,  ie_inconsistencia_p text,  ds_inconsistencia_p text, nm_usuario_p text) FROM PUBLIC;