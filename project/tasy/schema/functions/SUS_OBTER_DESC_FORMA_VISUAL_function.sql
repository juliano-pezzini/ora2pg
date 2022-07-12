-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_desc_forma_visual ( nr_seq_forma_visual_p sus_fpo_regra.nr_seq_forma_visual%type) RETURNS varchar AS $body$
DECLARE


ds_forma_visualizacao_w		sus_forma_visual_est_fpo.ds_forma_visualizacao%type := '';


BEGIN

begin
select	ds_forma_visualizacao
into STRICT	ds_forma_visualizacao_w
from	sus_forma_visual_est_fpo
where	nr_sequencia = nr_seq_forma_visual_p;
exception
when others then
	ds_forma_visualizacao_w := '';
end;

return	ds_forma_visualizacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_desc_forma_visual ( nr_seq_forma_visual_p sus_fpo_regra.nr_seq_forma_visual%type) FROM PUBLIC;
