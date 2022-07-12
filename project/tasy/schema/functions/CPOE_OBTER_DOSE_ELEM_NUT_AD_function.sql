-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_dose_elem_nut_ad ( nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE

 
 
qt_volume_w		double precision := 0;


BEGIN 
 
select	coalesce(sum(coalesce(b.qt_dose,0)),0) 
into STRICT	qt_volume_w 
from	nut_elem_material x, 
	cpoe_dieta c, 
	cpoe_npt_produto b, 
	cpoe_npt_elemento a 
where	a.nr_sequencia		= nr_sequencia_p 
and	a.nr_seq_npt_cpoe	= c.nr_sequencia 
and	c.nr_sequencia		= b.nr_seq_npt_cpoe 
and	a.nr_seq_elemento	= x.nr_seq_elemento 
and	x.cd_material		= b.cd_material 
and	coalesce(x.ie_tipo,'NPT')	= 'NPT';
 
return qt_volume_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_dose_elem_nut_ad ( nr_sequencia_p bigint) FROM PUBLIC;

