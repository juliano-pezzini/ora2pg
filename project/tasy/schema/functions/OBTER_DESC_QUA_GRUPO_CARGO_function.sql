-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_qua_grupo_cargo (nr_seq_grupo_cargo_p qua_grupo_cargo.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


expressao_w	dic_expressao.ds_expressao_br%type;


BEGIN

select  SUBSTR(obter_desc_expressao(cd_exp_agrupamento, ds_agrupamento),1,255) ds
into STRICT	expressao_w
from 	qua_grupo_cargo
where	nr_sequencia = nr_seq_grupo_cargo_p;


return	expressao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_qua_grupo_cargo (nr_seq_grupo_cargo_p qua_grupo_cargo.nr_sequencia%type) FROM PUBLIC;

