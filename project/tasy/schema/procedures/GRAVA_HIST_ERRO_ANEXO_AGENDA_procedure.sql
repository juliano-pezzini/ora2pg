-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_hist_erro_anexo_agenda ( qt_horas_p bigint, nr_seq_agenda_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then 
	begin 
	CALL grava_historico_agenda_cir( 
			nr_seq_agenda_p, 
			obter_texto_tasy(89842, wheb_usuario_pck.get_nr_seq_idioma), 
			obter_dados_usuario_opcao(nm_usuario_p,'C'), 
			clock_timestamp(), 
			wheb_usuario_pck.get_cd_setor_atendimento, 
			'B', 
			null, 
			nm_usuario_p);
	ds_erro_p := obter_texto_dic_objeto(69966, wheb_usuario_pck.get_nr_seq_idioma,'QT_HORAS='||qt_horas_p);
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_hist_erro_anexo_agenda ( qt_horas_p bigint, nr_seq_agenda_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

