-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE regerar_xml_integracao ( nr_seq_agend_integr_p text) AS $body$
DECLARE


nr_seq_log_w		agendamento_integracao.nr_seq_log%type;
ds_parametros_w		agendamento_integracao.ds_parametros%type;
nr_seq_proj_xml_w	informacao_integracao.nr_seq_proj_xml%type;
qt_ocorrencias_atual_w	bigint := 0;
qt_ocorrencias_w	bigint := 0;
ie_status_w		agendamento_integracao.ie_status%type;


BEGIN

if (nr_seq_agend_integr_p > 0 ) then
	select	a.nr_seq_log,
		a.ds_parametros,
		a.ie_status
	into STRICT	nr_seq_log_w,
		ds_parametros_w,
		ie_status_w
	from	agendamento_integracao a
	where	nr_sequencia = nr_seq_agend_integr_p;

	/* Se o status do agendamento_integracao estiver como 'O', coloca para o status 'T' e abaixo na hora de recriar o XML caso ainda existir
	inconsistências de ocorrências na hora de inserir já faz update no agendamento_integracao para 'O' novamente */
	if (ie_status_w = 'O') then
		update	agendamento_integracao
		set	ie_status 	= 'T'
		where	nr_sequencia	= nr_seq_agend_integr_p;
	end if;

	update	log_integracao_xml
	set	ie_envio_retorno = 'R'
	where	nr_seq_log = nr_seq_log_w
	and	ie_envio_retorno in ('E','PR');

	select	i.nr_seq_proj_xml
	into STRICT	nr_seq_proj_xml_w
	from	log_integracao l,
		informacao_integracao i
	where	l.nr_sequencia = nr_seq_log_w
	and	l.nr_seq_informacao = i.nr_sequencia;

	CALL wheb_exportar_xml_pck.exportar(nr_seq_proj_xml_w, nr_seq_log_w, 'INTEGRACAO', ds_parametros_w);

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE regerar_xml_integracao ( nr_seq_agend_integr_p text) FROM PUBLIC;

