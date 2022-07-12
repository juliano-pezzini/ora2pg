-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_mat_med_assoc_sae_adep (nr_seq_horario_p bigint) RETURNS varchar AS $body$
DECLARE

 
nr_prescricao_w	bigint;
nr_seq_item_w		bigint;
ds_associados_w	varchar(255);


BEGIN 
if (nr_seq_horario_p IS NOT NULL AND nr_seq_horario_p::text <> '') then 
	/* obter dados horario prescricao */
 
	select	c.nr_prescricao, 
		b.nr_sequencia 
	into STRICT	nr_prescricao_w, 
		nr_seq_item_w 
	from	pe_prescricao c, 
		pe_prescr_proc b, 
		pe_prescr_proc_hor a 
	where	c.nr_sequencia = b.nr_seq_prescr 
	and	b.nr_seq_prescr = a.nr_seq_pe_prescr 
	and	b.nr_sequencia = a.nr_seq_pe_proc 
	and	a.nr_sequencia = nr_seq_horario_p;
 
	/* obter diluicao */
 
	select	substr(obter_mat_med_assoc_pe_proc(nr_prescricao_w, nr_seq_item_w),1,255) 
	into STRICT	ds_associados_w 
	;
 
end if;
 
return ds_associados_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_mat_med_assoc_sae_adep (nr_seq_horario_p bigint) FROM PUBLIC;
