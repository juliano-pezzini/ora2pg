-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_tabela_sline_oper_exam (nr_seq_laudo_oper_p bigint ,ds_oper_exam_p text ,nm_usuario_p text) AS $body$
DECLARE

nr_seq_xml_laudo_oper_exam_w bigint;

BEGIN

select nextval('sline_xml_laudo_oper_exam_seq')
  into STRICT nr_seq_xml_laudo_oper_exam_w
;

insert
into sline_xml_laudo_oper_exam(nr_sequencia
                              ,dt_atualizacao
                              ,nm_usuario
                              ,dt_atualizacao_nrec
                              ,nm_usuario_nrec
                              ,nr_seq_laudo_oper
                              ,ds_oper_exam)
                     values (nr_seq_xml_laudo_oper_exam_w
                              ,clock_timestamp()
                              ,nm_usuario_p
                              ,clock_timestamp()
                              ,nm_usuario_p
                              ,nr_seq_laudo_oper_p
                              ,ds_oper_exam_p);
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_tabela_sline_oper_exam (nr_seq_laudo_oper_p bigint ,ds_oper_exam_p text ,nm_usuario_p text) FROM PUBLIC;

