-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_classif_conta_ifrs (nr_seq_conta_ifrs_p ctb_plano_conta_ifrs.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ds_resultado_w  ctb_plano_conta_ifrs.cd_classificacao%type;


BEGIN

if (nr_seq_conta_ifrs_p != 0) then
	begin
		select	cd_classificacao
		into STRICT	ds_resultado_w
		from	ctb_plano_conta_ifrs
		where	nr_sequencia = nr_seq_conta_ifrs_p;
	exception
		when no_data_found then
		        ds_resultado_w := null;
                when too_many_rows then
		        ds_resultado_w := null;
	end;
end if;

return ds_resultado_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_classif_conta_ifrs (nr_seq_conta_ifrs_p ctb_plano_conta_ifrs.nr_sequencia%type) FROM PUBLIC;

