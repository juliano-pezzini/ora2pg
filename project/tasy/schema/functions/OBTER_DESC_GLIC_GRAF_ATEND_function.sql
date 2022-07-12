-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_glic_graf_atend (nr_seq_glicemia_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_prot_glic_w	bigint;
nr_glic_atend_w		bigint;
nm_prot_glic_w		varchar(80);
dt_inicial_w		varchar(19);
dt_final_w		varchar(19);
ds_grafico_w		varchar(2000);
ie_tipo_w		varchar(1);


BEGIN
if (nr_seq_glicemia_p IS NOT NULL AND nr_seq_glicemia_p::text <> '') then

	/* obter se ccg */

	select	coalesce(max(nr_glic_atend),0) nr_glic_atend,
		coalesce(max(nr_seq_prot_glic),0) nr_seq_prot_glic
	into STRICT	nr_glic_atend_w,
		nr_seq_prot_glic_w
	from	atend_glicemia
	where	nr_sequencia = nr_seq_glicemia_p;

	select	max(ie_tipo)
	into STRICT	ie_tipo_w
	from	pep_protocolo_glicemia
	where	nr_sequencia = nr_seq_prot_glic_w;

	/* obter dados ccg */

	if (nr_seq_prot_glic_w > 0) and (ie_tipo_w	= 'C') then

		select	substr(obter_nome_prot_glic(nr_seq_prot_glic_w),1,80) nm_prot_glic_w,
			to_char(min(dt_controle),'dd/mm/yyyy hh24:mi:ss') dt_inicial,
			to_char(max(dt_controle),'dd/mm/yyyy hh24:mi:ss') dt_final
		into STRICT	nm_prot_glic_w,
			dt_inicial_w,
			dt_final_w
		from	atendimento_glicemia
		where	nr_seq_glicemia = nr_seq_glicemia_p;

		ds_grafico_w :=	to_char(nr_glic_atend_w) || 'º ' || nm_prot_glic_w ||' '|| obter_desc_expressao(310214)/*' de '*/ ||' '|| dt_inicial_w ||' '|| obter_desc_expressao(318244) /* ' a ' */||' '|| dt_final_w;

	elsif (nr_seq_prot_glic_w = 0) or (ie_tipo_w	= 'I') then /* obter dados cig */
		select	to_char(min(dt_controle),'dd/mm/yyyy hh24:mi:ss') dt_inicial,
			to_char(max(dt_controle),'dd/mm/yyyy hh24:mi:ss') dt_final
		into STRICT	dt_inicial_w,
			dt_final_w
		from	atendimento_cig
		where	nr_seq_glicemia = nr_seq_glicemia_p;

		ds_grafico_w :=	to_char(nr_glic_atend_w) || 'º '|| obter_desc_expressao(308116) ||' '|| obter_desc_expressao(310214)/*' de '*/ ||' '||  dt_inicial_w ||' '|| obter_desc_expressao(318244)/*a*/||' '|| dt_final_w; --' Controle intensivo da glicemia - Goldberg de '
	end if;

end if;

return ds_grafico_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_glic_graf_atend (nr_seq_glicemia_p bigint) FROM PUBLIC;

