-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_criterio_honorario_mat ( nr_sequencia_p bigint, nr_seq_mat_crit_repasse_p bigint, nr_seq_criterio_p INOUT bigint, ds_regra_p INOUT text, ds_repasse_p INOUT text, nr_seq_criterio_rep_p INOUT bigint) AS $body$
DECLARE

 
 
nr_seq_criterio_w		bigint;
ds_resp_credito_w		varchar(255);
ds_regra_w		varchar(80);
ds_repasse_w		varchar(255);
ie_repasse_valor_w		varchar(1);
cd_criterio_w		bigint;
nr_seq_criterio_rep_w	mat_criterio_repasse.nr_sequencia%type;


BEGIN 
 
select	max(obter_criterio_honor_mat(nr_sequencia_p)) 
into STRICT	nr_seq_criterio_w
;
 
select	max(a.ds_regra) 
into STRICT	ds_regra_w 
from	regra_honorario a, 
	regra_material_criterio b 
where	a.cd_regra = b.cd_regra 
and	b.nr_sequencia = nr_sequencia_p;
 
begin 
select	a.ds_regra, 
	b.nr_seq_criterio 
into STRICT	ds_repasse_w, 
	nr_seq_criterio_rep_w 
from	regra_repasse_terceiro a, 
	material_repasse b 
where	a.cd_regra = b.cd_regra 
and	b.nr_seq_material = nr_sequencia_p;
exception 
when others then 
	ds_repasse_w := null;
	nr_seq_criterio_rep_w := null;
end;
 
if (coalesce(nr_seq_criterio_rep_w::text, '') = '') then 
	nr_seq_criterio_rep_w	:= nr_seq_mat_crit_repasse_p;
end if;	
 
if (coalesce(ds_repasse_w::text, '') = '' or 
	ds_repasse_w = '') then 
	select	max(a.ds_regra) 
	into STRICT	ds_repasse_w 
	from	regra_repasse_terceiro a, 
		mat_criterio_repasse b 
	where	a.cd_regra = b.cd_regra 
	and	b.nr_sequencia = nr_seq_mat_crit_repasse_p;
	 
end if;
 
ds_regra_p		:= ds_regra_w;
nr_seq_criterio_p	:= nr_seq_criterio_w;
ds_repasse_p		:= ds_repasse_w;
nr_seq_criterio_rep_p	:= nr_seq_criterio_rep_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_criterio_honorario_mat ( nr_sequencia_p bigint, nr_seq_mat_crit_repasse_p bigint, nr_seq_criterio_p INOUT bigint, ds_regra_p INOUT text, ds_repasse_p INOUT text, nr_seq_criterio_rep_p INOUT bigint) FROM PUBLIC;
