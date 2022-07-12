-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tiss_dashboard_data_pck.calcula_item_pendente (nr_interno_conta_p conta_paciente.nr_interno_conta%type, cd_autorizacao_p conta_paciente_guia.cd_autorizacao%type, qt_item_p INOUT bigint) AS $body$
DECLARE


qt_item_pend_w bigint;


BEGIN

	select	count(a.nr_sequencia)
	into STRICT	qt_item_pend_w
	from	lote_audit_hist_item a,
		lote_audit_hist_guia b
	where	a.nr_seq_guia = b.nr_sequencia
	and	b.nr_interno_conta = nr_interno_conta_p
	and	coalesce(b.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738)) = cd_autorizacao_p
	and	coalesce(a.ie_acao_glosa::text, '') = '';

	qt_item_p := coalesce(qt_item_pend_w, 0);

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_dashboard_data_pck.calcula_item_pendente (nr_interno_conta_p conta_paciente.nr_interno_conta%type, cd_autorizacao_p conta_paciente_guia.cd_autorizacao%type, qt_item_p INOUT bigint) FROM PUBLIC;