-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_cid_ocorrencia (nr_seq_requisicao_p bigint, nr_seq_guia_plano_p bigint, nr_seq_conta_p bigint, cd_doenca_cid_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2) := 'N';
qt_cid_w		integer;


BEGIN

if (coalesce(nr_seq_guia_plano_p,0) > 0) then
	select	count(*)
	into STRICT	qt_cid_w
	from	pls_diagnostico
	where	nr_seq_guia = nr_seq_guia_plano_p
	and	cd_doenca = cd_doenca_cid_p;
elsif (coalesce(nr_seq_conta_p,0) > 0) then
	select	count(*)
	into STRICT	qt_cid_w
	from	pls_diagnostico_conta
	where	nr_seq_conta = nr_seq_conta_p
	and	cd_doenca = cd_doenca_cid_p;
elsif (coalesce(nr_seq_requisicao_p,0) > 0) then
	select	count(*)
	into STRICT	qt_cid_w
	from	pls_requisicao_diagnostico
	where	nr_seq_requisicao = nr_seq_requisicao_p
	and	cd_doenca = cd_doenca_cid_p;
end if;

if (qt_cid_w > 0) then
	ds_retorno_w := 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_cid_ocorrencia (nr_seq_requisicao_p bigint, nr_seq_guia_plano_p bigint, nr_seq_conta_p bigint, cd_doenca_cid_p text) FROM PUBLIC;
