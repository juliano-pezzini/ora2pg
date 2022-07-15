-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dados_agenda_int_pop_js ( nr_seq_agenda_p bigint, nr_seq_item_p bigint, nr_seq_ageint_p bigint, nr_seq_proc_interno_p bigint, nr_seq_status_p bigint, dt_liberacao_p timestamp, nr_seq_em_agenda_p INOUT bigint, nr_seq_agendado_p INOUT bigint, nr_seq_cancelado_p INOUT bigint, nr_seq_reservado_p INOUT bigint, nr_seq_pre_agend_p INOUT bigint, qt_sugestao_hor_p INOUT bigint, qt_nao_agendados_p INOUT bigint, qt_marcaoes_p INOUT bigint, qt_prof_item_p INOUT bigint, nr_min_entre_datas_p INOUT bigint, qt_agenda_excons_p INOUT bigint, ie_check_list_lib_p INOUT text, ie_status_tasy_ageint_p INOUT text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
	select	min(nr_sequencia) 
	into STRICT	nr_seq_em_agenda_p 
	from	agenda_integrada_status 
	where	ie_situacao = 'A' 
	and	ie_status_tasy = 'EA';
	 
	select	min(nr_sequencia) 
	into STRICT	nr_seq_agendado_p 
	from	agenda_integrada_status 
	where	ie_situacao = 'A' 
	and	ie_status_tasy = 'AG';
	 
	select	min(nr_sequencia) 
	into STRICT	nr_seq_cancelado_p 
	from	agenda_integrada_status 
	where	ie_situacao = 'A' 
	and	ie_status_tasy = 'CA';
	 
	select	min(nr_sequencia) 
	into STRICT	nr_seq_reservado_p 
	from	agenda_integrada_status 
	where	ie_situacao = 'A' 
	and	ie_status_tasy = 'RS';
	 
	select	min(nr_sequencia) 
	into STRICT	nr_seq_pre_agend_p 
	from	agenda_integrada_status 
	where	ie_situacao = 'A' 
	and	ie_status_tasy = 'PA';
	 
	select	count(*) 
	into STRICT	qt_sugestao_hor_p 
	from	ageint_sugestao_horarios 
	where	nr_seq_agenda	= nr_seq_agenda_p 
	and	nm_usuario	= nm_usuario_p;
 
	select	count(*) 
	into STRICT 	qt_nao_agendados_p 
	from	agenda_integrada_item 
	where	nr_seq_agenda_int = nr_seq_agenda_p 
	and	coalesce(nr_seq_agenda_exame::text, '') = '' 
	and	coalesce(nr_seq_agenda_cons::text, '') = '';
	 
	select	count(*) 
	into STRICT	qt_marcaoes_p 
	from	ageint_marcacao_usuario 
	where	nr_seq_ageint	= nr_seq_agenda_p 
	and	nm_usuario	= nm_usuario_p 
	and	coalesce(ie_gerado,'N') = 'N';
	 
	select	count(*) 
	into STRICT 	qt_prof_item_p 
	from	ageint_medico_item 
	where	nr_seq_item = nr_seq_item_p;
	 
	nr_min_entre_datas_p := obter_min_entre_datas(dt_liberacao_p, clock_timestamp(), 1);
	 
	select	count(*) 
	into STRICT	qt_agenda_excons_p 
	from	agenda_integrada_item 
	where	nr_seq_agenda_int = nr_seq_agenda_p 
	and ((nr_seq_agenda_exame IS NOT NULL AND nr_seq_agenda_exame::text <> '') or (nr_seq_agenda_cons IS NOT NULL AND nr_seq_agenda_cons::text <> ''));
	 
	select	coalesce(ageint_obter_se_check_list_lib(nr_seq_ageint_p,nr_seq_proc_interno_p, cd_estabelecimento_p),'0') 
	into STRICT 	ie_check_list_lib_p 
	;
	 
	ie_status_tasy_ageint_p	:= coalesce(obter_status_tasy_ageint(nr_seq_status_p),'0');
	 
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dados_agenda_int_pop_js ( nr_seq_agenda_p bigint, nr_seq_item_p bigint, nr_seq_ageint_p bigint, nr_seq_proc_interno_p bigint, nr_seq_status_p bigint, dt_liberacao_p timestamp, nr_seq_em_agenda_p INOUT bigint, nr_seq_agendado_p INOUT bigint, nr_seq_cancelado_p INOUT bigint, nr_seq_reservado_p INOUT bigint, nr_seq_pre_agend_p INOUT bigint, qt_sugestao_hor_p INOUT bigint, qt_nao_agendados_p INOUT bigint, qt_marcaoes_p INOUT bigint, qt_prof_item_p INOUT bigint, nr_min_entre_datas_p INOUT bigint, qt_agenda_excons_p INOUT bigint, ie_check_list_lib_p INOUT text, ie_status_tasy_ageint_p INOUT text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

