-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ish_patient_pck.get_table_modify_response ( nr_sequencia_p bigint, ds_xml_p text default null) AS $body$
DECLARE


reg_integracao_w	gerar_int_padrao.reg_integracao_conv;
nr_seq_doc_origem_w	intpd_fila_transmissao.nr_seq_documento%type;
nr_doc_externo_w	intpd_fila_transmissao.nr_doc_externo%type;
nr_seq_agrupador_w	intpd_fila_transmissao.nr_seq_agrupador%type;
pf_codigo_externo_w	pf_codigo_externo%rowtype;
pessoa_classif_w	pessoa_classif%rowtype;
xml_w			xml;
EDatatab_w		xml;
ds_xml_w		text;

c01 CURSOR FOR
SELECT	/*'<item>400;0001;0008276019;02;Text entspricht dem Grund;</item>'*/

	substr(obter_valor_campo_separador(item, 3, ';'),1,10) patientid,
	substr(obter_valor_campo_separador(item, 4, ';'),1,10) nr_seq_classif_conv,
	substr(obter_valor_campo_separador(item, 5, ';'),1,4000) ds_observacao
from	xmltable('/EDatatab' passing EDatatab_w columns
	item	varchar(4000)	path	'item');

c01_w	c01%rowtype;

ds_erro_w	varchar(2000);

ie_status_w			intpd_fila_transmissao.ie_status%type		:=	'S';
ie_tipo_erro_w			intpd_fila_transmissao.ie_tipo_erro%type	:=	'F';


BEGIN
begin
select	a.nr_seq_documento,
	a.nr_seq_agrupador,
	coalesce(ds_xml_p, ds_xml_retorno)
into STRICT	nr_seq_doc_origem_w,
	nr_seq_agrupador_w,
	ds_xml_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_sequencia_p;

intpd_reg_integracao_inicio(nr_sequencia_p, 'R', reg_integracao_w);
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
	select	EDatatab
	into STRICT	EDatatab_w
	from	xmltable(
			xmlnamespaces(
			'urn:sap-com:document:sap:soap:functions:mc-style' as "urn",
			'http://schemas.xmlsoap.org/soap/envelope/' as "soapenv"),
		'soapenv:Envelope/soapenv:Body/urn:_-rzvish_-tableModifyResponse' passing xml_w columns
		EDatatab xmltype path 'EDatatab') a;

	open C01;
	loop
	fetch C01 into	
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		reg_integracao_w.nm_tabela		:=	'PESSOA_CLASSIF';
		reg_integracao_w.nm_elemento		:=	'EDatatab';
		reg_integracao_w.nr_seq_visao		:=	0;
		
		select	max(a.cd_pessoa_fisica)
		into STRICT	pessoa_classif_w.cd_pessoa_fisica
		from	pf_codigo_externo a
		where	a.cd_pessoa_fisica_externo = c01_w.patientid
		and	a.ie_tipo_codigo_externo = 'ISH'
		and	exists (SELECT 1
			from	pessoa_fisica x
			where	x.cd_pessoa_fisica = a.cd_pessoa_fisica);
			
		if (coalesce(pessoa_classif_w.cd_pessoa_fisica,'NULL') <> 'NULL') then
			begin
			if (coalesce(c01_w.nr_seq_classif_conv, 'NULL') <> 'NULL') then
				intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_CLASSIF', c01_w.nr_seq_classif_conv, 'S', pessoa_classif_w.nr_seq_classif);
			elsif (coalesce(c01_w.ds_observacao, 'NULL') <> 'NULL') then
				intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_CLASSIF', 'DEFAULT', 'S', pessoa_classif_w.nr_seq_classif);
			end if;
			
				begin
				select	*
				into STRICT	pessoa_classif_w
				from	pessoa_classif
				where	cd_pessoa_fisica = pessoa_classif_w.cd_pessoa_fisica
				and	nr_seq_classif = pessoa_classif_w.nr_seq_classif
				and	coalesce(dt_final_vigencia::text, '') = ''  LIMIT 1;
				exception
				when others then
					pessoa_classif_w.nr_sequencia	:=	null;
				end;

				delete	FROM pessoa_classif
				where	cd_pessoa_fisica = pessoa_classif_w.cd_pessoa_fisica
				and	nr_seq_classif <> pessoa_classif_w.nr_seq_classif
				and	coalesce(intpd_conv(
						'CLASSIF_PESSOA',
						'NR_SEQUENCIA',
						nr_seq_classif,
						reg_integracao_w.nr_seq_regra_conversao,
						reg_integracao_w.ie_conversao, 'E'),'X') not in ('VIP', 'PUBLISTBLOCK', 'RELIGLIST', 'RESTRICTED');

				if (coalesce(pessoa_classif_w.nr_sequencia::text, '') = '' and
					(pessoa_classif_w.nr_seq_classif IS NOT NULL AND pessoa_classif_w.nr_seq_classif::text <> '')) then
					select	nextval('pessoa_classif_seq')
					into STRICT	pessoa_classif_w.nr_sequencia
					;

					pessoa_classif_w.DT_ATUALIZACAO		:=	clock_timestamp();
					pessoa_classif_w.DT_ATUALIZACAO_NREC	:=	clock_timestamp();
					pessoa_classif_w.DT_INICIO_VIGENCIA	:=	clock_timestamp();
					pessoa_classif_w.NM_USUARIO		:=	current_setting('ish_patient_pck.usernametasy')::varchar(15);
					pessoa_classif_w.NM_USUARIO_NREC	:=	current_setting('ish_patient_pck.usernametasy')::varchar(15);
					pessoa_classif_w.ds_observacao		:=	c01_w.ds_observacao;

					insert into pessoa_classif values (pessoa_classif_w.*);

					nr_doc_externo_w := pessoa_classif_w.nr_sequencia || '|' || pessoa_classif_w.cd_pessoa_fisica;
				end if;
			end;
		end if;
		end;
	end loop;
	close C01;
	
	if (coalesce(ie_status_w,'X') <> 'E') then
		ie_status_w	:=	'S';
	end if;

	update	intpd_fila_transmissao
	set	ie_status = ie_status_w,
		nr_doc_externo = nr_doc_externo_w,
		ie_response_procedure = 'S',
		ds_log  = NULL,
		dt_atualizacao = clock_timestamp(),
		ds_xml_retorno = ds_xml_w
	where	nr_sequencia = nr_sequencia_p;
	
	
	if (reg_integracao_w.qt_reg_log > 0) then
		begin
		/*'Em caso de qualquer consistencia o sistema efetua rollback, atualiza o status para Erro e registra todos os logs de consistencia'*/


		rollback;		
		update	intpd_fila_transmissao
		set	ie_status = 'E',
			ie_response_procedure = 'S',
			ds_log = ds_erro_w,
			ds_xml_retorno = ds_xml_w
		where	nr_sequencia = nr_sequencia_p;
		end;
	else
		update	intpd_fila_transmissao
		set	ie_status = 'S',
			ie_response_procedure = 'S',
			ds_log  = NULL,
			nr_doc_externo = nr_doc_externo_w,
			ds_xml_retorno = ds_xml_w
		where	nr_sequencia = nr_sequencia_p;
	end if;

	reg_integracao_w := gerar_int_padrao.gravar_log(reg_integracao_w);	
	end;
end if;

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
		ds_xml_retorno = ds_xml_w
	where	nr_sequencia = nr_sequencia_p;
	end;
end;

if (nr_seq_agrupador_w > 0) then
	CALL intpd_processar_fila_trans(null, 'S', nr_seq_agrupador_w);
end if;

commit;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ish_patient_pck.get_table_modify_response ( nr_sequencia_p bigint, ds_xml_p text default null) FROM PUBLIC;
