-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_nao_conform_sac ( nr_seq_bol_ocor_p bigint ,nr_sequencia_p bigint ) AS $body$
DECLARE

nr_seq_bol_ocor_w	SAC_BOLETIM_OCORRENCIA.NR_SEQUENCIA%type;


BEGIN
	nr_seq_bol_ocor_w := null;
	if (nr_seq_bol_ocor_p > 0) then
		nr_seq_bol_ocor_w := nr_seq_bol_ocor_p;
	end if;


	update qua_nao_conformidade
	set    nr_seq_bol_ocor = nr_seq_bol_ocor_w
	where  nr_sequencia = nr_sequencia_p;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_nao_conform_sac ( nr_seq_bol_ocor_p bigint ,nr_sequencia_p bigint ) FROM PUBLIC;
