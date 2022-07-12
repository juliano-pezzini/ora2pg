-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION aval_c (nr_seq_avaliacao_p bigint, nr_seq_item_p bigint) RETURNS varchar AS $body$
DECLARE


ds_resultado_w	varchar(4000);


BEGIN


select	obter_result_avaliacao_check(nr_seq_avaliacao_p, nr_seq_item_p)
into STRICT	ds_resultado_w
;


return	ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION aval_c (nr_seq_avaliacao_p bigint, nr_seq_item_p bigint) FROM PUBLIC;

