-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qte_conversao_matpaci (nr_seq_matpaci_p bigint) RETURNS varchar AS $body$
DECLARE


ds_conversao_unidade_w	varchar(100);
tx_conversao_qtde_w		double precision;
qt_material_w			double precision;
cd_unidade_medida_w     varchar(30);


BEGIN
begin
select	coalesce(max(tx_conversao_qtde),1),
	coalesce(max(cd_unidade_medida),' ')
into STRICT	tx_conversao_qtde_w,
	cd_unidade_medida_w
from	mat_atend_pac_convenio
where	nr_seq_material = nr_seq_matpaci_p;

select	coalesce(max(qt_material),0)
into STRICT	qt_material_w
from	material_atend_paciente
where	nr_sequencia = nr_seq_matpaci_p;

qt_material_w := qt_material_w * tx_conversao_qtde_w;

--ds_conversao_unidade_w := campo_mascara_virgula(qt_material_w) || ' ' || cd_unidade_medida_w;  --Retirado 331716
ds_conversao_unidade_w := campo_mascara_virgula(qt_material_w);
exception
when others then
	ds_conversao_unidade_w:= '';
end;
return	ds_conversao_unidade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qte_conversao_matpaci (nr_seq_matpaci_p bigint) FROM PUBLIC;

