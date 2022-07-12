-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS intpd_fila_transmissao_delete ON intpd_fila_transmissao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_intpd_fila_transmissao_delete() RETURNS trigger AS $BODY$
declare

ds_host_w		varchar(255);
nr_ip_address_w		varchar(255);
ds_user_w		varchar(255);
ds_session_user_w	varchar(255);
ds_stack_w 		varchar(4000);
ie_baixa_encontro_contas_w bigint := 0;
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	BEGIN
	
	BEGIN
	select	sys_context('USERENV', 'HOST') DS_HOST,
		sys_context('USERENV', 'IP_ADDRESS') NR_IP_ADDRESS,
		sys_context('USERENV', 'OS_USER') DS_USER,
		sys_context('USERENV', 'SESSION_USER') DS_SESSION_USER
	into STRICT	ds_host_w,
		nr_ip_address_w,
		ds_user_w,
		ds_session_user_w
	;
	exception
	when others then
		ds_host_w 	:= null;
		nr_ip_address_w 	:= null;
		ds_user_w 	:= null;
		ds_session_user_w 	:= null;
	end;

	ds_stack_w 		:= substr(dbms_utility.format_call_stack,1,4000);

	/*select	count(*)
	into	ie_baixa_encontro_contas_w
	from	v$session
	where	audsid = (select userenv('sessionid') from dual)
	and		upper(action) = 'INTPD_LOG_CLEANING';

	if (ie_baixa_encontro_contas_w = 0) then
	*/

		insert into intpd_log_exclusao(
			dt_exclusao,
			dt_registro,
			nr_seq_fila,
			nr_seq_documento,
			nr_seq_item_documento,
			nr_doc_externo,
			ie_evento,
			ie_operacao,
			ie_status,
			ds_xml,
			ds_xml_retorno,
			ds_stack,
			ds_host,
			nr_ip_address,
			ds_user,
			ds_session_user)
		values (	LOCALTIMESTAMP,
			OLD.dt_atualizacao,
			OLD.nr_sequencia,
			OLD.nr_seq_documento,
			OLD.nr_seq_item_documento,
			OLD.nr_doc_externo,
			OLD.ie_evento,
			OLD.ie_operacao,
			OLD.ie_status,
			OLD.ds_xml,
			OLD.ds_xml_retorno,
			ds_stack_w,
			ds_host_w,
			nr_ip_address_w,
			ds_user_w,
			ds_session_user_w);

	--end if;


	end;
end if;

  END;
RETURN OLD;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_intpd_fila_transmissao_delete() FROM PUBLIC;

CREATE TRIGGER intpd_fila_transmissao_delete
	BEFORE DELETE ON intpd_fila_transmissao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_intpd_fila_transmissao_delete();

