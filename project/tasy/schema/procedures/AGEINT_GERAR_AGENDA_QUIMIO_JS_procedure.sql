-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gerar_agenda_quimio_js ( nr_seq_pend_quimio_p bigint, cd_paciente_p text, cd_profissional_p text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_ageint_quimio_p INOUT text, cd_prof_p INOUT text, nr_seq_status_p INOUT text, dt_agenda_p INOUT text, ie_edicao_p INOUT text, dt_Agenda_html_p INOUT timestamp) AS $body$
DECLARE

		
ie_status_w		varchar(10);
dt_data_w		varchar(50);
nr_sequencia_w		varchar(10);
cd_profissional_w	varchar(10);
ie_edicao_w		varchar(1);


BEGIN

ie_status_w := substr(ageint_obter_dados_quimio(nr_seq_pend_quimio_p,'S'),1,255);
dt_data_w := substr(ageint_obter_dados_quimio(nr_seq_pend_quimio_p,'DI'),1,255);
nr_sequencia_w := substr(ageint_obter_dados_quimio(nr_seq_pend_quimio_p,'SE'),1,255);
cd_profissional_w := substr(ageint_obter_dados_quimio(nr_seq_pend_quimio_p,'P'),1,255);

if (coalesce(nr_sequencia_w::text, '') = '') then
	begin
	SELECT * FROM ageint_gerar_agenda_quimio(	
		nr_seq_pend_quimio_p, cd_paciente_p, cd_profissional_p, nm_usuario_p, cd_estabelecimento_p, nr_sequencia_w, cd_profissional_w, ie_status_w, dt_data_w) INTO STRICT nr_sequencia_w, cd_profissional_w, ie_status_w, dt_data_w;
		
	ie_edicao_w := 'S';
	
	end;
end if;

nr_seq_ageint_quimio_p	:= nr_sequencia_w;
cd_prof_p		:= cd_profissional_w;
nr_seq_status_p		:= ie_status_w;
dt_agenda_p		:= to_char(to_date(dt_data_w, 'dd/mm/yyyy hh24:mi:ss'), 'dd/mm/yyyy');
ie_edicao_p		:= ie_edicao_w;
dt_agenda_html_p	:= trunc(to_DatE(substr(ageint_obter_dados_quimio(nr_seq_pend_quimio_p,'DT'),1,255),'dd/mm/yyyy hh24:mi:ss'));

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_gerar_agenda_quimio_js ( nr_seq_pend_quimio_p bigint, cd_paciente_p text, cd_profissional_p text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_ageint_quimio_p INOUT text, cd_prof_p INOUT text, nr_seq_status_p INOUT text, dt_agenda_p INOUT text, ie_edicao_p INOUT text, dt_Agenda_html_p INOUT timestamp) FROM PUBLIC;
