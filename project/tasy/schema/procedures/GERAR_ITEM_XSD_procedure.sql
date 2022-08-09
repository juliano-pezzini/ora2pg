-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_item_xsd (nr_seq_projeto_p xml_projeto.nr_sequencia%type, ie_tipo_item_p xsd_item.ie_tipo_item%type, nm_item_p xsd_item.nm_item%type, nr_seq_item_p INOUT xsd_item.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

insert	into xsd_item(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_projeto_xml,
		nm_item,
		ie_tipo_item)
values (nextval('xsd_item_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_projeto_p,
		nm_item_p,
		ie_tipo_item_p) returning nr_sequencia into nr_seq_item_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_item_xsd (nr_seq_projeto_p xml_projeto.nr_sequencia%type, ie_tipo_item_p xsd_item.ie_tipo_item%type, nm_item_p xsd_item.nm_item%type, nr_seq_item_p INOUT xsd_item.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
