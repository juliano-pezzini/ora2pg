-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_conv_xml_cta_pck.alimenta_campo_grau_partic () AS $body$
DECLARE


tb_nr_sequencia_w	pls_util_cta_pck.t_number_table;

C01 CURSOR FOR
	SELECT 	nr_sequencia
	from	pls_grau_participacao
	where	coalesce(ie_situacao::text, '') = '';


BEGIN
tb_nr_sequencia_w.delete;

open C01;
loop
	fetch C01 bulk collect into	tb_nr_sequencia_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_sequencia_w.count = 0;
	
	forall i in tb_nr_sequencia_w.first..tb_nr_sequencia_w.last
		update	pls_grau_participacao
		set	ie_situacao = 'A'
		where	nr_sequencia = tb_nr_sequencia_w(i);
	commit;
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conv_xml_cta_pck.alimenta_campo_grau_partic () FROM PUBLIC;
