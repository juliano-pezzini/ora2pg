-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_matpaci (nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


nr_doc_convenio_w	varchar(255);
ds_retorno_w		varchar(255);
cd_material_tiss_w	varchar(20);
cd_material_tuss_w	varchar(255);
nr_seq_proc_princ_w	bigint;

/*ie_opcao_p
	NG	Número da guia
	CT	Código TISS do material
	CTU	Código TUSS do material
	PP	Sequência do proc principal vinculado ao item
*/
BEGIN

select	max(nr_doc_convenio),
	max(cd_material_tiss),
	max(cd_material_tuss),
	max(nr_seq_proc_princ)
into STRICT	nr_doc_convenio_w,
	cd_material_tiss_w,
	cd_material_tuss_w,
	nr_seq_proc_princ_w
from	material_atend_paciente
where	nr_sequencia	= nr_sequencia_p;

if (ie_opcao_p = 'NG') then
	ds_retorno_w	:= nr_doc_convenio_w;
elsif (ie_opcao_p = 'CT') then
	ds_retorno_w	:= cd_material_tiss_w;
elsif (ie_opcao_p = 'CTU') then
	ds_retorno_w	:= cd_material_tuss_w;
elsif (ie_opcao_p = 'PP') then
	ds_retorno_w	:= nr_seq_proc_princ_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_matpaci (nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

