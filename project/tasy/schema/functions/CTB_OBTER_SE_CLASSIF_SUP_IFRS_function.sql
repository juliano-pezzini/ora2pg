-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_se_classif_sup_ifrs ( nr_seq_conta_ifrs_p bigint, cd_classificacao_p text) RETURNS varchar AS $body$
DECLARE


ie_pertence_w			varchar(1)	:= 'N';
cd_classificacao_w		varchar(40);


BEGIN

begin
	select	a.cd_classificacao
	into STRICT	cd_classificacao_w
	from	ctb_plano_conta_ifrs a
	where	a.nr_sequencia	= nr_seq_conta_ifrs_p;
exception
when no_data_found then
	return ie_pertence_w;
when too_many_rows  then
	return ie_pertence_w;
end;

if (substr(cd_classificacao_w, 1, length(cd_classificacao_p)) = cd_classificacao_p) then
	ie_pertence_w	:= 'S';
end if;

return ie_pertence_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_se_classif_sup_ifrs ( nr_seq_conta_ifrs_p bigint, cd_classificacao_p text) FROM PUBLIC;
