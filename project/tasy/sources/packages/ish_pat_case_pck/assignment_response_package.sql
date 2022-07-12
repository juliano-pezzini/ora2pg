-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ish_pat_case_pck.assignment_response ( nr_sequencia_p bigint) AS $body$
DECLARE

		
nr_seq_doc_origem_w	intpd_fila_transmissao.nr_seq_documento%type;
nr_seq_agrupador_w	intpd_fila_transmissao.nr_seq_agrupador%type;
ds_xml_w		text;
xml_w			xml;
ds_erro_w		varchar(2000);
reg_integracao_w	gerar_int_padrao.reg_integracao_conv;

ie_status_w			intpd_fila_transmissao.ie_status%type		:=	'S';
ie_tipo_erro_w			intpd_fila_transmissao.ie_tipo_erro%type	:=	'F';


BEGIN
begin
select	a.nr_seq_documento,
	a.nr_seq_agrupador,
	a.ds_xml_retorno
into STRICT	nr_seq_doc_origem_w,
	nr_seq_agrupador_w,
	ds_xml_w
from	intpd_fila_transmissao a
where	a.nr_sequencia = nr_sequencia_p;
exception
when others then
	ds_xml_w	:=	null;
end;

intpd_reg_integracao_inicio(nr_sequencia_p, 'E', reg_integracao_w);
ish_converter_response(nr_sequencia_p, ds_xml_w, ie_status_w, ie_tipo_erro_w, xml_w);

if (ie_status_w = 'E') then
	update	intpd_fila_transmissao
	set	ie_status = ie_status_w,
		ie_tipo_erro = ie_tipo_erro_w,
		nr_doc_externo  = NULL,
		ie_response_procedure = 'S',
		ds_log  = NULL,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_sequencia_p;
else	
	update	intpd_fila_transmissao
	set	ie_status = 'S',	
		dt_atualizacao = clock_timestamp(),
		ie_response_procedure = 'S'
	where	nr_sequencia = nr_sequencia_p;
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
-- REVOKE ALL ON PROCEDURE ish_pat_case_pck.assignment_response ( nr_sequencia_p bigint) FROM PUBLIC;
