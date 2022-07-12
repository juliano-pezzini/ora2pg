-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ish_patient_pck.patient_sending_response (( nr_sequencia_p bigint, ds_xml_p text) is nr_seq_doc_origem_w intpd_fila_transmissao.nr_seq_documento%type) RETURNS FROM AS $body$
DECLARE
 "urn",
		'http://schemas.xmlsoap.org/soap/envelope/' as "soapenv"),
	'soapenv:Envelope/soapenv:Body/urn:PatientCreateResponse' passing xml_w columns
	newpatientdata		xml	path	'NewPatientData',
	return 			xml	path	'Return')

union all

SELECT  'A' ie_tipo,
	newpatientdata,
	return
from	xmltable(
		xmlnamespaces(
		'urn:sap-com:document:sap:soap:functions:mc-style' as "urn",
		'http://schemas.xmlsoap.org/soap/envelope/' as "soapenv"),
	'soapenv:Envelope/soapenv:Body/urn:PatientChangeResponse' passing xml_w columns
	newpatientdata		xml	path	'NewPatientData',
	return 			xml	path	'Return')

union all

SELECT  'E' ie_tipo,
	newpatientdata,
	return
from	xmltable(
		xmlnamespaces(
		'urn:sap-com:document:sap:soap:functions:mc-style' as "urn",
		'http://schemas.xmlsoap.org/soap/envelope/' as "soapenv"),
	'soapenv:Envelope/soapenv:Body/urn:PatientCancelResponse' passing xml_w columns
	newpatientdata		xml	path	'NewPatientData',
	return 			xml	path	'Return')

union all

select  'EN' ie_tipo,
	newpatientdata,
	return
from	xmltable(
		xmlnamespaces(
		'urn:sap-com:document:sap:soap:functions:mc-style' as "urn",
		'http://schemas.xmlsoap.org/soap/envelope/' as "soapenv"),
	'soapenv:Envelope/soapenv:Body/urn:PatientEnqueueResponse' passing xml_w columns
	newpatientdata		xml	path	'NewPatientData',
	return 			xml	path	'Return')

union all

select  'DC' ie_tipo,
	newpatientdata,
	return
from	xmltable(
		xmlnamespaces(
		'urn:sap-com:document:sap:soap:functions:mc-style' as "urn",
		'http://schemas.xmlsoap.org/soap/envelope/' as "soapenv"),
	'soapenv:Envelope/soapenv:Body/urn:PatientDequeueResponse' passing xml_w columns
	newpatientdata		xml	path	'NewPatientData',
	return 			xml	path	'Return');

c01_w	c01%rowtype;

ds_erro_w				varchar(2000);
ie_status_w				intpd_fila_transmissao.ie_status%type		:=	'S';
ie_tipo_erro_w			intpd_fila_transmissao.ie_tipo_erro%type	:=	'F';
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
cd_estabelecimento_w	pf_codigo_externo.cd_estabelecimento%type;
conv_meio_externo_w		conversao_meio_externo.cd_externo%type;


BEGIN
intpd_reg_integracao_inicio(nr_sequencia_p, 'R', reg_integracao_w);
ish_converter_response(nr_sequencia_p, ds_xml_p, ie_status_w, ie_tipo_erro_w, xml_w);

if (ie_status_w = 'E') then
	update	intpd_fila_transmissao
	set	ie_status = ie_status_w,
		ie_tipo_erro = ie_tipo_erro_w,
		nr_doc_externo  = NULL,
		ie_response_procedure = 'S',
		ds_log  = NULL,
		dt_atualizacao = clock_timestamp(),
		ds_xml_retorno = ds_xml_p
	where	nr_sequencia = nr_sequencia_p;
else
	begin

	select	a.nr_seq_documento,
		a.nr_seq_agrupador
	into STRICT	nr_seq_doc_origem_w,
		nr_seq_agrupador_w
	from	intpd_fila_transmissao a,
		intpd_eventos_sistema b
	where	a.nr_seq_evento_sistema = b.nr_sequencia
	and	a.nr_sequencia = nr_sequencia_p;

	open c01;
	loop
	fetch c01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (c01_w.ie_tipo not in ('EN','DC')) then
			begin
			select	patientid,
					institution
			into STRICT	nr_doc_externo_w,
					conv_meio_externo_w
			from	xmltable('NewPatientData' passing c01_w.newpatientdata columns
					patientid varchar2(10) path 'Patientid',
					institution	varchar2(4)	path 'Institution')
			where	coalesce(patientid,'X') <> 'X';
			exception
			when others then
				begin
				select	patientid,
						institution
				into STRICT	nr_doc_externo_w,
						conv_meio_externo_w
				from	xmltable('NewPatientData' passing c01_w.newpatientdata columns
					patientid varchar2(10) path 'PATIENTID',
					institution	varchar2(4)	path 'INSTITUTION');
				exception
				when others then
					nr_doc_externo_w	:=	null;
				end;
			end;
		end if;

		if (c01_w.ie_tipo = 'I') and (length(nr_doc_externo_w) > 0) then
			begin

			reg_integracao_w.nm_tabela		:= 'ESTABELECIMENTO';
			reg_integracao_w.nm_elemento	:= 'PatientData';
			reg_integracao_w.nr_seq_visao	:= 0;

			intpd_processar_atributo(reg_integracao_w, 'CD_ESTABELECIMENTO', conv_meio_externo_w, 'S', cd_estabelecimento_w);

			begin
			select	*
			into STRICT	pf_codigo_externo_w
			from	pf_codigo_externo
			where	cd_pessoa_fisica = nr_seq_doc_origem_w
			and	cd_pessoa_fisica_externo = nr_doc_externo_w
			and	ie_tipo_codigo_externo = 'ISH'  LIMIT 1;
			exception
			when others then
				pf_codigo_externo_w.nr_sequencia	:=	null;
			end;

			if (coalesce(pf_codigo_externo_w.nr_sequencia::text, '') = '') then
				begin
				select	nextval('pf_codigo_externo_seq')
				into STRICT	pf_codigo_externo_w.nr_sequencia
				;

				pf_codigo_externo_w.cd_pessoa_fisica_externo	:= nr_doc_externo_w;
				pf_codigo_externo_w.cd_pessoa_fisica			:= nr_seq_doc_origem_w;
				pf_codigo_externo_w.nm_usuario					:= current_setting('ish_patient_pck.usernametasy')::varchar(15);
				pf_codigo_externo_w.nm_usuario_nrec				:= current_setting('ish_patient_pck.usernametasy')::varchar(15);
				pf_codigo_externo_w.dt_atualizacao				:= clock_timestamp();
				pf_codigo_externo_w.dt_atualizacao_nrec			:= clock_timestamp();
				pf_codigo_externo_w.ie_tipo_codigo_externo		:= 'ISH';
				pf_codigo_externo_w.cd_estabelecimento			:= cd_estabelecimento_w;

				insert into pf_codigo_externo values (pf_codigo_externo_w.*);
				end;
			end if;
			end;
		end if;

		ish_return_processing(nr_sequencia_p, c01_w.return, ie_status_w);


		exit;
		end;
	end loop;
	close c01;

	if	((c01_w.ie_tipo in ('I','E')) and (length(nr_doc_externo_w) = 0)) then
		ie_status_w	:=	'E';
	elsif (coalesce(ie_status_w,'X') <> 'E') then
		ie_status_w	:=	'S';
	end if;

	update	intpd_fila_transmissao
	set	ie_status = ie_status_w,
		nr_doc_externo = nr_doc_externo_w,
		ie_response_procedure = 'S',
		ds_log  = NULL,
		dt_atualizacao = clock_timestamp(),
		ds_xml_retorno = ds_xml_p
	where	nr_sequencia = nr_sequencia_p;

	exception
	when others then
		begin
		ds_erro_w	:=	substr(dbms_utility.format_error_backtrace || chr(13) || chr(10) || sqlerrm,1,2000);
		rollback;

		update	intpd_fila_transmissao
		set	ie_status = 'E',
			nr_doc_externo = nr_doc_externo_w,
			ie_response_procedure = 'S',
			ds_log = ds_erro_w,
			dt_atualizacao = clock_timestamp(),
			ds_xml_retorno = ds_xml_p
		where	nr_sequencia = nr_sequencia_p;
		end;
	end;
end if;

if (nr_seq_agrupador_w > 0) then
	CALL intpd_processar_fila_trans(null, 'S', nr_seq_agrupador_w);
end if;

commit;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ish_patient_pck.patient_sending_response (( nr_sequencia_p bigint, ds_xml_p text) is nr_seq_doc_origem_w intpd_fila_transmissao.nr_seq_documento%type) FROM PUBLIC;
