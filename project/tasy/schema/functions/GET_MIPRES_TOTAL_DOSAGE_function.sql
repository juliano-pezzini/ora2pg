-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_mipres_total_dosage ( nr_seq_mipres_p prescr_mipres.nr_sequencia%type ) RETURNS bigint AS $body$
DECLARE


    qt_result_w	double precision;
    ie_ie_tipo_item_presc_w prescr_mipres.ie_tipo_item_presc%type;


BEGIN

	select max(a.ie_tipo_item_presc)
	into STRICT ie_ie_tipo_item_presc_w
	from prescr_mipres a
	where a.nr_sequencia = nr_seq_mipres_p;

	if (ie_ie_tipo_item_presc_w = 'M') then

		select  sum(c.qt_dose)
		into STRICT    qt_result_w
		from    prescr_mipres a,
				prescr_material b,
				prescr_mat_hor c
		where   b.nr_prescricao = a.nr_prescricao
		and     b.nr_sequencia = a.nr_seq_item_presc
		and     c.nr_prescricao = b.nr_prescricao
		and     c.nr_seq_material = b.nr_sequencia
		and (a.nr_sequencia = nr_seq_mipres_p or a.nr_seq_superior = nr_seq_mipres_p)
		and     b.ie_agrupador in (1, 3, 7, 9);

	elsif (ie_ie_tipo_item_presc_w = 'MAT') then

		select  sum(c.qt_dose)
		into STRICT    qt_result_w
		from    prescr_mipres a,
				prescr_material b,
				prescr_mat_hor c
		where   b.nr_prescricao = a.nr_prescricao
		and     b.nr_sequencia = a.nr_seq_item_presc
		and     c.nr_prescricao = b.nr_prescricao
		and     c.nr_seq_material = b.nr_sequencia
		and (a.nr_sequencia = nr_seq_mipres_p or a.nr_seq_superior = nr_seq_mipres_p)
		and     b.ie_agrupador = 2;

	elsif (ie_ie_tipo_item_presc_w = 'D') then

		select	sum(c.qt_dose)
		into STRICT    qt_result_w
		from    prescr_mipres a,
				prescr_material b,
				prescr_mat_hor c
		where   b.nr_prescricao = a.nr_prescricao
		and     b.nr_sequencia = a.nr_seq_item_presc
		and     c.nr_prescricao = b.nr_prescricao
		and     c.nr_seq_material = b.nr_sequencia
		and (a.nr_sequencia = nr_seq_mipres_p or a.nr_seq_superior = nr_seq_mipres_p)
		and     b.ie_agrupador in (8, 12, 16);

	elsif (ie_ie_tipo_item_presc_w = 'SOL') then

		select  sum(c.qt_dose)
		into STRICT    qt_result_w
		from    prescr_mipres a,
				prescr_material b, 
				prescr_solucao d, 
				prescr_mat_hor c 
		where   b.nr_prescricao = a.nr_prescricao 
		and     b.nr_sequencia = a.nr_seq_item_presc
		and     d.nr_seq_solucao = b.nr_sequencia_solucao 
		and     c.nr_prescricao = b.nr_prescricao
		and     c.nr_seq_material = b.nr_sequencia
		and (a.nr_sequencia = nr_seq_mipres_p or a.nr_seq_superior = nr_seq_mipres_p)
		and     b.ie_agrupador in (4);

	elsif (ie_ie_tipo_item_presc_w = 'P') then

		select  sum(c.nr_etapa)
		into STRICT    qt_result_w
		from    prescr_mipres a,
				prescr_procedimento b,
				prescr_proc_hor c
		where   b.nr_prescricao = a.nr_prescricao
		and     b.nr_sequencia = a.nr_seq_item_presc
		and     c.nr_prescricao = b.nr_prescricao
		and     c.nr_seq_procedimento = b.nr_sequencia
		and (a.nr_sequencia = nr_seq_mipres_p or a.nr_seq_superior = nr_seq_mipres_p);

	elsif (ie_ie_tipo_item_presc_w = 'ASS') then

		select	sum(c.qt_dose)
		into STRICT	qt_result_w
		from	prescr_mipres a,
				prescr_material b,
				prescr_mat_hor c
		where	b.nr_prescricao = a.nr_prescricao
		and		b.nr_sequencia = a.nr_seq_item_presc
		and 	c.nr_prescricao = b.nr_prescricao
		and 	c.nr_seq_material = b.nr_sequencia
		and (a.nr_sequencia = nr_seq_mipres_p or a.nr_seq_superior = nr_seq_mipres_p)
		and 	b.ie_agrupador = 5;

	elsif (ie_ie_tipo_item_presc_w = 'MAG') then

		select	sum(c.qt_dose)
		into STRICT	qt_result_w
		from	prescr_mipres a,
				prescr_material b,
				prescr_mat_hor c
		where	a.nr_prescricao = b.nr_prescricao
		and		a.nr_seq_item_presc = b.nr_sequencia
		and		c.nr_prescricao = b.nr_prescricao
		and		c.nr_seq_material = b.nr_sequencia
		and (a.nr_sequencia = nr_seq_mipres_p or a.nr_seq_superior = nr_seq_mipres_p)
		and		b.ie_agrupador = 15;

	elsif (ie_ie_tipo_item_presc_w = 'MAD') then

		select	sum(c.qt_dose)
		into STRICT	qt_result_w
		from	prescr_mipres a,
				prescr_material b,
				prescr_mat_hor c
		where	b.nr_prescricao = a.nr_prescricao
		and		b.nr_sequencia = a.nr_seq_item_presc
		and		c.nr_prescricao = b.nr_prescricao
		and		c.nr_seq_material = b.nr_sequencia
		and (a.nr_sequencia = nr_seq_mipres_p or a.nr_seq_superior = nr_seq_mipres_p)
		and		b.ie_agrupador = 17;

	elsif (ie_ie_tipo_item_presc_w = 'AP') then

		select  sum(c.nr_etapa)
		into STRICT    qt_result_w
		from    prescr_mipres a,
				prescr_procedimento b,
				prescr_proc_hor c
		where   b.nr_prescricao = a.nr_prescricao
		and     b.nr_sequencia = a.nr_seq_item_presc
		and     c.nr_prescricao = b.nr_prescricao
		and     c.nr_seq_procedimento = b.nr_sequencia
		and (a.nr_sequencia = nr_seq_mipres_p or a.nr_seq_superior = nr_seq_mipres_p);

	elsif (ie_ie_tipo_item_presc_w = 'MREC') then

		select	sum(d.qt_dose)
		into STRICT    qt_result_w
		from	prescr_mipres a,
				prescr_material b,
				prescr_recomendacao c,
				prescr_mat_hor d
		where	a.nr_prescricao = b.nr_prescricao
		and		a.nr_seq_item_presc = b.nr_sequencia
		and		b.nr_prescricao = c.nr_prescricao
		and		b.nr_seq_recomendacao = c.nr_sequencia
		and		d.nr_prescricao = b.nr_prescricao
		and		d.nr_seq_material = b.nr_sequencia
		and (a.nr_sequencia = nr_seq_mipres_p or a.nr_seq_superior = nr_seq_mipres_p);
		
	elsif (ie_ie_tipo_item_presc_w = 'R') then

		select	count(*)
		into STRICT	qt_result_w
		from	prescr_mipres a,
				prescr_recomendacao b,
				prescr_rec_hor c
		where	b.nr_prescricao = a.nr_prescricao
		and		b.nr_sequencia = a.nr_seq_item_presc
		and		c.nr_prescricao = b.nr_prescricao
		and		c.nr_seq_recomendacao = b.nr_sequencia
		and (a.nr_sequencia = nr_seq_mipres_p or a.nr_seq_superior = nr_seq_mipres_p);
		
	end if;

	return coalesce(qt_result_w, 0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_mipres_total_dosage ( nr_seq_mipres_p prescr_mipres.nr_sequencia%type ) FROM PUBLIC;

