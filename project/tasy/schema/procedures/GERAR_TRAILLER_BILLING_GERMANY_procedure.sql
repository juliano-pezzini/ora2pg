-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_trailler_billing_germany (quantidade_dataset_p integer, sequencial_arquivo_p text, trailler_arquivo_p INOUT text) AS $body$
BEGIN
  trailler_arquivo_p := 'UNZ+'||lpad(coalesce(to_char(quantidade_dataset_p), 0), 6, '0')||'+'||
                        substr(lpad(coalesce(sequencial_arquivo_p, '0'),14, '0'),1,14)|| '''';
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_trailler_billing_germany (quantidade_dataset_p integer, sequencial_arquivo_p text, trailler_arquivo_p INOUT text) FROM PUBLIC;
