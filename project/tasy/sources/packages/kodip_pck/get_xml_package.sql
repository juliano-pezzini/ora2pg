-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--
-- dblink wrapper to call function kodip_pck.get_xml() as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION kodip_pck.get_xml (nr_seq_documento_p text) RETURNS text AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	text;
BEGIN
	v_query := 'SELECT * FROM kodip_pck.get_xml_atx ( ' || quote_nullable(nr_seq_documento_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret text);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION kodip_pck.get_xml_atx (nr_seq_documento_p text) RETURNS text AS $body$
DECLARE


nr_seq_fila_ww		bigint;
ds_xml_w		text;
nr_seq_log_w		tasy_xml_banco.nr_sequencia%type;
ie_conversao_w		intpd_eventos_sistema.ie_conversao%type;
ds_parametros_w		varchar(4000);
nr_seq_documento_w	intpd_fila_transmissao.nr_seq_documento%type;
ie_operacao_w		intpd_fila_transmissao.ie_operacao%type;
nr_seq_projeto_xml_w	intpd_eventos_sistema.nr_seq_projeto_xml%type;
BEGIN
nr_seq_fila_ww	:=	kodip_pck.get_fila_transmissao(somente_numero(nr_seq_documento_p), '62', 'A');

CALL kodip_pck.set_seq_fila(nr_seq_fila_ww);

select	a.nr_seq_documento,
	a.ie_operacao,
	b.nr_seq_projeto_xml,
	b.ie_conversao
into STRICT	nr_seq_documento_w,
	ie_operacao_w,			
	nr_seq_projeto_xml_w,
	ie_conversao_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_seq_fila_ww;

ds_parametros_w	:=	'NR_SEQ_FILA=' || nr_seq_fila_ww ||';'||
			'NR_SEQ_DOCUMENTO='|| nr_seq_documento_p || ';'||
			'IE_CONVERSAO=' || ie_conversao_w || ';'||
			'IE_OPERACAO=' || ie_operacao_w;

select	nextval('tasy_xml_banco_seq')
into STRICT 	nr_seq_log_w
;
						
CALL wheb_exportar_xml(nr_seq_projeto_xml_w, nr_seq_log_w, '', ds_parametros_w);

pls_convert_long_( 'TASY_XML_BANCO', 'DS_XML', 'WHERE NR_SEQUENCIA = :NR_SEQUENCIA', 'NR_SEQUENCIA='||nr_seq_log_w, ds_xml_w);						

--tratamento para remover o cabecalho da mesma forma que e feito no whebservidorintegracao
select	replace_clob(ds_xml_w,'<?xml version="1.0" encoding="ISO-8859-1"?>','')
into STRICT	ds_xml_w
;

select	replace_clob(ds_xml_w,'<?xml version="1.0" encoding="UTF-8"?>','')
into STRICT	ds_xml_w
;

delete	FROM intpd_fila_transmissao
where	nr_sequencia = nr_seq_fila_ww;

commit;

return ds_xml_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION kodip_pck.get_xml (nr_seq_documento_p text) FROM PUBLIC; -- REVOKE ALL ON FUNCTION kodip_pck.get_xml_atx (nr_seq_documento_p text) FROM PUBLIC;