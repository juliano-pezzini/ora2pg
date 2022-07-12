-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtde_bipada_palm (nr_prescricao_p bigint, cd_material_p bigint, nr_seq_lote_fornec_p bigint) RETURNS bigint AS $body$
DECLARE


qt_total_bipada_w	double precision	:= 0;


BEGIN


begin
	select 	coalesce(sum(b.qt_material),0)
	into STRICT	qt_total_bipada_w
	from	administracao_lote_fornec b
	where	b.nr_prescricao = nr_prescricao_p
	and 	substr(obter_dados_material(b.cd_material, 'EST'),1,30) = substr(obter_dados_material(cd_material_p,'EST'),1,30)
	and	nr_seq_lote_fornec = nr_seq_lote_fornec_p;
exception
when others then
	qt_total_bipada_w	:= 0;
end;

return	qt_total_bipada_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtde_bipada_palm (nr_prescricao_p bigint, cd_material_p bigint, nr_seq_lote_fornec_p bigint) FROM PUBLIC;

