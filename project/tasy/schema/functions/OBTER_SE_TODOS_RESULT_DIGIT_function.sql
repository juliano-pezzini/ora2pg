-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_todos_result_digit (nr_seq_resultado_p bigint) RETURNS varchar AS $body$
DECLARE


ie_libera_w  varchar(1);


BEGIN


select   CASE WHEN count(1)=0 THEN  'S'  ELSE 'N' END
into STRICT     ie_libera_w
from     exame_lab_result_item a
where    a.nr_seq_resultado = nr_seq_resultado_p
and      coalesce(qt_resultado::text, '') = ''
and      coalesce(pr_resultado::text, '') = ''
and      coalesce(ds_resultado::text, '') = '';


return ie_libera_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_todos_result_digit (nr_seq_resultado_p bigint) FROM PUBLIC;
