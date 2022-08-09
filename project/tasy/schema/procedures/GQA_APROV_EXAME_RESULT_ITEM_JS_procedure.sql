-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gqa_aprov_exame_result_item_js ( nr_seq_resultado_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

nr_regras_atendidas_w varchar(2000);


BEGIN 
 
  nr_regras_atendidas_w := GQA_Aprov_Exame_result_item(nr_seq_resultado_p, nr_sequencia_p, nm_usuario_p, nr_regras_atendidas_w);
  
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gqa_aprov_exame_result_item_js ( nr_seq_resultado_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
