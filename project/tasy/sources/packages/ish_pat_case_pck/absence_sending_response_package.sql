-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ish_pat_case_pck.absence_sending_response (( nr_sequencia_p bigint, ds_xml_p text) is nr_seq_doc_origem_w intpd_fila_transmissao.nr_seq_documento%type) RETURNS FROM AS $body$
DECLARE
 "n0",
		'http://schemas.xmlsoap.org/soap/envelope/' as "soapenv"),
		'soapenv:Envelope/soapenv:Body/n0:PatcaseAddabsenceResponse' passing xml_w columns
		NewMovemntDataBeg		xml	path	'NewMovemntDataBeg',
return	xml	path	'Return')

union all

SELECT	'A' ie_tipo,
	NewMovemntDataBeg,
return
from	xmltable(
		xmlnamespaces(
		'urn:sap-com:document:sap:soap:functions:mc-style' as "n0",
		'http://schemas.xmlsoap.org/soap/envelope/' as "soapenv"),
		'soapenv:Envelope/soapenv:Body/n0:PatcaseChangeabsenceResponse' passing xml_w columns
		NewMovemntDataBeg		xml	path	'NewMovemntDataBeg',
return	xml	path	'Return');

c01_w	c01%rowtype;


c02 CURSOR FOR
SELECT  'I' ie_tipo,
	NewMovemntDataEnd,
	return
from	xmltable(
		xmlnamespaces(
		'urn:sap-com:document:sap:soap:functions:mc-style' as "n0",
		'http://schemas.xmlsoap.org/soap/envelope/' as "soapenv"),
		'soapenv:Envelope/soapenv:Body/n0:PatcaseAddabsenceResponse' passing xml_w columns
		NewMovemntDataEnd		xml	path	'NewMovemntDataEnd',
return	xml	path	'Return')

union all

select	'A' ie_tipo,
	NewMovemntDataEnd,
return
from	xmltable(
		xmlnamespaces(
		'urn:sap-com:document:sap:soap:functions:mc-style' as "n0",
		'http://schemas.xmlsoap.org/soap/envelope/' as "soapenv"),
		'soapenv:Envelope/soapenv:Body/n0:PatcaseChangeabsenceResponse' passing xml_w columns
		NewMovemntDataEnd		xml	path	'NewMovemntDataEnd',
return	xml	path	'Return');

c02_w	c02%rowtype;

ie_status_w		intpd_fila_transmissao.ie_status%type		:=	'S';
ie_tipo_erro_w	intpd_fila_transmissao.ie_tipo_erro%type	:=	'F';


BEGIN
CALL intpd_inicializacao(nr_sequencia_p);
ish_converter_response(nr_sequencia_p, ds_xml_p, ie_status_w, ie_tipo_erro_w, xml_w);

if (ie_status_w = 'E') then
	update	intpd_fila_transmissao
	set		ie_status				= ie_status_w,
			ie_tipo_erro			= ie_tipo_erro_w,
			nr_doc_externo			 = NULL,
			ie_response_procedure	= 'S',
			ds_log					 = NULL,
			dt_atualizacao			= clock_timestamp(),
			ds_xml_retorno			= ds_xml_p
	where	nr_sequencia			= nr_sequencia_p;
else
	begin
	begin
	select	a.nr_seq_documento,
			b.nr_seq_regra_conv,
			a.nr_seq_agrupador
	into STRICT	nr_seq_doc_origem_w,
			nr_seq_regra_conv_w,
			nr_seq_agrupador_w
	from	intpd_fila_transmissao	a,
			intpd_eventos_sistema 	b
	where	a.nr_seq_evento_sistema	= b.nr_sequencia
	and		a.nr_sequencia			= nr_sequencia_p;
	exception
	when others then
		null;
	end;
	
	open c01;
	loop
	fetch c01 into	
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin	
		
		begin
		select	patcaseid,
			movemntseqno,
			extmovementid,
			movemnttype
		into STRICT	patcaseid_w,
			movemntseqno_w,
			nr_doc_interno_w,
			movemnttype_w
		from	xmltable('NewMovemntDataBeg' passing c01_w.NewMovemntDataBeg columns
				patcaseid varchar2(10) path 'Patcaseid',
				movemntseqno varchar2(10) path 'MovemntSeqno',
				extmovementid varchar2(20) path 'ExtMovementId',
				movemnttype varchar2(10) path 'MovemntType');
		exception
		when others then
			movemntseqno_w	:= null;
		end;
		
		if (coalesce(movemntseqno_w::text, '') = '') then
			begin
			select	patcaseid,
				movemntseqno,
				extmovementid,
				movemnttype
			into STRICT	patcaseid_w,
				movemntseqno_w,
				nr_doc_interno_w,
				movemnttype_w
			from	xmltable('NewMovemntDataBeg' passing c01_w.NewMovemntDataBeg columns
					patcaseid varchar2(10) path 'PATCASEID',
					movemntseqno varchar2(10) path 'MOVEMNT_SEQNO',
					extmovementid varchar2(20) path 'EXT_MOVEMENT_ID',
					movemnttype varchar2(10) path 'MOVEMNT_TYPE');
			exception
			when others then
				movemntseqno_w	:=	null;
			end;
		end if;
		
		if (c01_w.ie_tipo = 'I') and (somente_numero(movemntseqno_w) > 0) then
			begin
			CALL gerar_conv_meio_externo(
				null,
				'ATEND_PACIENTE_UNIDADE', 
				'NR_SEQ_INTERNO', 
				nr_seq_doc_origem_w || current_setting('ish_pat_case_pck.ds_separador_w')::varchar(10) || movemnttype_w,
				substr(patcaseid_w || current_setting('ish_pat_case_pck.ds_separador_w')::varchar(10) || movemntseqno_w,1,40),
				null, 
				nr_seq_regra_conv_w, 
				'A', 
				'INTPDTASY');
			end;
		end if;
		
		ish_return_processing(nr_sequencia_p, c01_w.return, ie_status_w);	
		exit;
		end;
	end loop;
	close c01;
	
	open c02;
	loop
	fetch c02 into	
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin	
		begin
		select	patcaseid,
			movemntseqno,
			extmovementid,
			movemnttype
		into STRICT	patcaseid_w,
			movemntseqno_w,
			nr_doc_interno_w,
			movemnttype_w
		from	xmltable('NewMovemntDataEnd' passing c02_w.NewMovemntDataEnd columns
				patcaseid varchar2(10) path 'Patcaseid',
				movemntseqno varchar2(10) path 'MovemntSeqno',
				extmovementid varchar2(20) path 'ExtMovementId',
				movemnttype varchar2(10) path 'MovemntType');
		exception
		when others then
			movemntseqno_w	:= null;
		end;
		
		if (coalesce(movemntseqno_w::text, '') = '') then
			begin
			select	patcaseid,
				movemntseqno,
				extmovementid,
				movemnttype
			into STRICT	patcaseid_w,
				movemntseqno_w,
				nr_doc_interno_w,
				movemnttype_w
			from	xmltable('NewMovemntDataEnd' passing c02_w.NewMovemntDataEnd columns
					patcaseid varchar2(10) path 'PATCASEID',
					movemntseqno varchar2(10) path 'MOVEMNT_SEQNO',
					extmovementid varchar2(20) path 'EXT_MOVEMENT_ID',
					movemnttype varchar2(10) path 'MOVEMNT_TYPE');
			exception
			when others then
				movemntseqno_w	:=	null;
			end;
		end if;
		
		if (c02_w.ie_tipo = 'I') and (somente_numero(movemntseqno_w) > 0) then
			begin
			CALL gerar_conv_meio_externo(
				null,
				'ATEND_PACIENTE_UNIDADE', 
				'NR_SEQ_INTERNO', 
				nr_seq_doc_origem_w || current_setting('ish_pat_case_pck.ds_separador_w')::varchar(10) || movemnttype_w,
				substr(patcaseid_w || current_setting('ish_pat_case_pck.ds_separador_w')::varchar(10) || movemntseqno_w,1,40),
				null, 
				nr_seq_regra_conv_w, 
				'A', 
				'INTPDTASY');
			end;
		end if;
		
		exit;
		end;
	end loop;
	close c02;

	if (coalesce(ie_status_w,'X') <> 'E') then
		ie_status_w	:=	'S';
	end if;
	exception
	when others then
		begin
		ds_erro_w	:=	substr(dbms_utility.format_error_backtrace || chr(13) || chr(10) || sqlerrm,1,2000);
		ie_status_w	:=	'E';
		end;
	end;

	update	intpd_fila_transmissao
	set		ie_status 				= ie_status_w,
			nr_doc_externo			= movemntseqno_w,
			ds_log 					= ds_erro_w,
			dt_atualizacao 			= clock_timestamp(),
			ds_xml_retorno 			= ds_xml_p,
			ie_response_procedure	= 'S'
	where	nr_sequencia 			= nr_sequencia_p;
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
-- REVOKE ALL ON PROCEDURE ish_pat_case_pck.absence_sending_response (( nr_sequencia_p bigint, ds_xml_p text) is nr_seq_doc_origem_w intpd_fila_transmissao.nr_seq_documento%type) FROM PUBLIC;
