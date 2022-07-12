-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_proc_mat_requisicao ( nr_seq_requisicao_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_material_p bigint) RETURNS bigint AS $body$
DECLARE


qt_repitido_w		bigint;


BEGIN

if (coalesce(cd_procedimento_p,0) <> 0) and (coalesce(ie_origem_proced_p,0) <> 0) then
	select	count(*)
	into STRICT	qt_repitido_w
	from	pls_requisicao_proc
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p;
elsif (coalesce(nr_seq_material_p,0) <> 0) then
	select	count(*)
	into STRICT	qt_repitido_w
	from	pls_requisicao_mat
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	nr_seq_material		= nr_seq_material_p;
end if;

return	qt_repitido_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_proc_mat_requisicao ( nr_seq_requisicao_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_material_p bigint) FROM PUBLIC;

