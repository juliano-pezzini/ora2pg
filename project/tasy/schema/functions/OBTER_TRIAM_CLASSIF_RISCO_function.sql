-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_triam_classif_risco ( ie_classificacao_risco_w text) RETURNS bigint AS $body$
DECLARE


nr_seq_classif_w		bigint;


BEGIN

if (ie_classificacao_risco_w IS NOT NULL AND ie_classificacao_risco_w::text <> '') then

	if (ie_classificacao_risco_w = 'V') then
		nr_seq_classif_w := 1;
	elsif (ie_classificacao_risco_w = 'L') then
		nr_seq_classif_w := 2;
	elsif (ie_classificacao_risco_w = 'A') then
		nr_seq_classif_w := 3;
	elsif (ie_classificacao_risco_w = 'VE') then
			nr_seq_classif_w := 4;
	elsif (ie_classificacao_risco_w = 'AZ') then
			nr_seq_classif_w := 5;
	elsif (ie_classificacao_risco_w = 'B') then
			nr_seq_classif_w := 6;
	elsif (ie_classificacao_risco_w = 'P') then
			nr_seq_classif_w := 7;
	end if;

end if;

return nr_seq_classif_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_triam_classif_risco ( ie_classificacao_risco_w text) FROM PUBLIC;
