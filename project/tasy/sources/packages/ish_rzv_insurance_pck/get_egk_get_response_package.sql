-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ish_rzv_insurance_pck.get_egk_get_response (nr_sequencia_p bigint) AS $body$
DECLARE


ds_erro_w			varchar(4000);
ds_xml_w			text;
ds_xml_pessoa_w			varchar(32000);
ds_xml_convenio_w		varchar(32000);
xml_w				xml;
insurancedata_w			xml;
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
nr_seq_doc_origem_w		intpd_fila_transmissao.nr_seq_documento%type;
nr_seq_agrupador_w		intpd_fila_transmissao.nr_seq_agrupador%type;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_sistema_w		intpd_eventos_sistema.nr_seq_sistema%type;
nr_seq_projeto_xml_w		intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_regra_w			intpd_eventos_sistema.nr_seq_regra_conv%type;
nr_seq_interno_w		atend_categoria_convenio.nr_seq_interno%type;
nr_sequencia_w			pessoa_fisica_egk.nr_sequencia%type;
casepatno_w			hcm_fall.casepatno%type;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
pessoa_fisica_egk_new_w		pessoa_fisica_egk%rowtype;
pessoa_fisica_egk_old_w		pessoa_fisica_egk%rowtype;

c01 CURSOR FOR
SELECT  a.egk_data,
	a.retorno
from (select  egk_data,
		retorno
	from	xmltable(
		xmlnamespaces(
		'urn:sap-com:document:sap:soap:functions:mc-style' as "urn",
		'http://schemas.xmlsoap.org/soap/envelope/' as "soap-env"),
		'soap-env:Envelope/soap-env:Body/urn:_-rzvish_-egkGetResponse' passing xml_w columns
	egk_data xml path 'EgkData',
	retorno  xml path 'Return')
	
union all

	SELECT  egk_data,
		retorno
	from	xmltable(
		xmlnamespaces(
		'urn:sap-com:document:sap:soap:functions:mc-style' as "urn",
		'http://schemas.xmlsoap.org/soap/envelope/' as "soap-env"),
		'soap-env:Envelope/soap-env:Body/urn:_-rzvish_-egkGetResponse' passing xml_w columns
	egk_data xml path 'EGKDATA',
	retorno  xml path 'RETURN')) a;

c01_w	c01%rowtype;

ie_status_w			intpd_fila_transmissao.ie_status%type		:=	'S';
ie_tipo_erro_w			intpd_fila_transmissao.ie_tipo_erro%type	:=	'F';


BEGIN
CALL intpd_inicializacao(nr_sequencia_p);

delete	FROM intpd_log_recebimento
where	nr_seq_fila = nr_sequencia_p;

begin
select	a.nr_seq_documento,
	coalesce(b.ie_conversao,'I'),
	b.nr_seq_sistema,
	b.nr_seq_projeto_xml,
	b.nr_seq_regra_conv,
	a.nr_seq_agrupador,
	a.ds_xml_retorno
into STRICT	nr_seq_doc_origem_w,
	ie_conversao_w,
	nr_seq_sistema_w,
	nr_seq_projeto_xml_w,
	nr_seq_regra_w,
	nr_seq_agrupador_w,
	ds_xml_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_sequencia_p;
exception
when others then
	null;
end;

ish_converter_response(nr_sequencia_p, ds_xml_w, ie_status_w, ie_tipo_erro_w, xml_w);

if (ie_status_w = 'E') then
	update	intpd_fila_transmissao
	set	ie_status = ie_status_w,
		ie_tipo_erro = ie_tipo_erro_w,
		nr_doc_externo  = NULL,
		ie_response_procedure = 'S',
		ds_log  = NULL,
		dt_atualizacao = clock_timestamp(),
		ds_xml_retorno = ds_xml_w
	where	nr_sequencia = nr_sequencia_p;
else	
	begin

	open c01;
	loop
	fetch c01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		SELECT * FROM ish_rzv_insurance_pck.get_xml_conv_pesfisi(c01_w.egk_data, ds_xml_pessoa_w, ds_xml_convenio_w) INTO STRICT ds_xml_pessoa_w, ds_xml_convenio_w;
		if (ds_xml_pessoa_w IS NOT NULL AND ds_xml_pessoa_w::text <> '') or (ds_xml_convenio_w IS NOT NULL AND ds_xml_convenio_w::text <> '') then
			importar_dados_egk(ds_xml_pessoa_w, ds_xml_convenio_w, current_setting('ish_rzv_insurance_pck.usernametasy')::varchar(15), nr_sequencia_w);
		end if;
		
		begin
		select	casepatno
		into STRICT	casepatno_w
		from	hcm_fall
		where	nr_sequencia = nr_seq_doc_origem_w;
		exception
		when others then
			ds_erro_w	:=	substr(dbms_utility.format_error_backtrace || chr(13) || chr(10) || sqlerrm,1,4000);

			rollback;

			update	intpd_fila_transmissao
			set	ie_status 			= 'E',
				ie_response_procedure	= 'S',
				ds_log 			= ds_erro_w,
				ds_xml_retorno		= ds_xml_w
			where	nr_sequencia 		= nr_sequencia_p;
		end;
		
		begin
		select	a.cd_pessoa_fisica
		into STRICT	cd_pessoa_fisica_w
		from	pf_codigo_externo a
		where	a.cd_pessoa_fisica_externo 		= casepatno_w
		and	a.ie_tipo_codigo_externo 		= 'ISH'  LIMIT 1;
		exception
		when others then
			cd_pessoa_fisica_w := null;
		end;
		
		if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') and (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		
			begin
				select	*
				into STRICT	pessoa_fisica_egk_new_w
				from	pessoa_fisica_egk
				where	nr_sequencia		= nr_sequencia_w  LIMIT 1;
			exception
			when others then
				pessoa_fisica_egk_new_w.nr_sequencia	:= null;
			end;
			
			begin
				select	*
				into STRICT	pessoa_fisica_egk_old_w
				from	pessoa_fisica_egk
				where	nr_sequencia	= egk_get_person_sequence(cd_pessoa_fisica_w)  LIMIT 1;
			exception
			when others then
				pessoa_fisica_egk_old_w.nr_sequencia	:= null;
			end;
		
			if (pessoa_fisica_egk_old_w.nr_sequencia IS NOT NULL AND pessoa_fisica_egk_old_w.nr_sequencia::text <> '') then
			
				pessoa_fisica_egk_new_w.nr_sequencia		:= pessoa_fisica_egk_old_w.nr_sequencia;
				pessoa_fisica_egk_new_w.cd_pessoa_fisica	:= pessoa_fisica_egk_old_w.cd_pessoa_fisica;
				
				update	pessoa_fisica_egk
				set	row 		= pessoa_fisica_egk_new_w
				where	nr_sequencia	= pessoa_fisica_egk_old_w.nr_sequencia;
				
				delete	from pessoa_fisica_egk
				where	nr_sequencia		= nr_sequencia_w;
			else			
	
				update	pessoa_fisica_egk
				set	cd_pessoa_fisica	= cd_pessoa_fisica_w
				where	nr_sequencia		= nr_sequencia_w;
			end if;
			
		end if;
		
		ish_return_processing(nr_sequencia_p, c01_w.retorno, ie_status_w);

	end loop;
	close c01;

	update	intpd_fila_transmissao
	set	ie_status 			= coalesce(ie_status_w,'S'),
		ie_response_procedure	= 'S',
		ds_xml_retorno		= ds_xml_w
	where	nr_sequencia 		= nr_sequencia_p;

	exception
	when others then
		ds_erro_w	:=	substr(dbms_utility.format_error_backtrace || chr(13) || chr(10) || sqlerrm,1,4000);

		rollback;

		update	intpd_fila_transmissao
		set	ie_status 			= 'E',
			ie_response_procedure	= 'S',
			ds_log 			= ds_erro_w,
			ds_xml_retorno		= ds_xml_w
		where	nr_sequencia 		= nr_sequencia_p;
	end;
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ish_rzv_insurance_pck.get_egk_get_response (nr_sequencia_p bigint) FROM PUBLIC;
