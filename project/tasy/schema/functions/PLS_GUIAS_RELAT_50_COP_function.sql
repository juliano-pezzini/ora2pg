-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_guias_relat_50_cop (nr_seq_segurado_p bigint, dt_autorizacao_inicio_p timestamp, dt_autorizacao_final_p timestamp) RETURNS bigint AS $body$
DECLARE


qt_guias_w bigint;

BEGIN

qt_guias_w := 0;

select	((select	count(1)
	 from		pls_conta_v	d
	 where		d.nr_seq_segurado = x.nr_sequencia
	 and		d.ie_status <> 'D'
	 and		exists (select	1
				from	pls_conta_proc_v z
				where	z.nr_seq_conta = d.nr_sequencia
				and	z.ie_status <> 'D'
				and	exists (select	1
						from	pls_conta_coparticipacao w
						where	w.nr_seq_conta_proc = z.nr_sequencia
						and	coalesce(w.nr_seq_mensalidade_seg::text, '') = '')
				
union all

				select	1
				from	pls_conta_mat_v z
				where	z.nr_seq_conta = d.nr_sequencia
					and 	z.ie_status <> 'D'
					and	exists (select	1
							from	pls_conta_coparticipacao w
							where	w.nr_seq_conta_mat = z.nr_sequencia
							and	coalesce(w.nr_seq_mensalidade_seg::text, '') = '')))
	+
	(select	count(1)
	 from		pls_conta_v	d,
			pls_segurado	f
	 where		d.nr_seq_segurado = f.nr_sequencia
	 and		f.nr_seq_titular	= x.nr_sequencia
	 and		d.ie_status <> 'D'
	 and		exists (select	1
				from	pls_conta_proc_v z
				where	z.nr_seq_conta = d.nr_sequencia
				and	z.ie_status <> 'D'
				and	exists (select	1
						from	pls_conta_coparticipacao w
						where	w.nr_seq_conta_proc = z.nr_sequencia
						and	coalesce(w.nr_seq_mensalidade_seg::text, '') = '')
				
union all

				select	1
				from	pls_conta_mat_v z
				where	z.nr_seq_conta = d.nr_sequencia
					and 	z.ie_status <> 'D'
					and	exists (select	1
							from	pls_conta_coparticipacao w
							where	w.nr_seq_conta_mat = z.nr_sequencia
							and	coalesce(w.nr_seq_mensalidade_seg::text, '') = '')))
	+
	(select	count(1)
	from	pls_guia_plano d
	where	d.nr_seq_segurado = x.nr_sequencia
	and	d.ie_status = '1'
	and	d.dt_autorizacao >= dt_autorizacao_inicio_p
	and 	d.dt_autorizacao <= (dt_autorizacao_final_p + 1)
	and	coalesce(d.ie_utilizado,'N') = 'N'
	and	exists (	select	1
				from	pls_guia_plano_proc z
				where	z.nr_seq_guia = d.nr_sequencia
				and	exists ( 	select	1
							from	pls_guia_coparticipacao w
							where	w.nr_seq_guia_proc = z.nr_sequencia)
				
union all

				select	1
				from	pls_guia_plano_mat z
				where	z.nr_seq_guia = d.nr_sequencia
				and	exists ( 	select	1
							from	pls_guia_coparticipacao w
							where	w.nr_seq_guia_mat = z.nr_sequencia)))
	+
	(select	count(1)
	from	pls_guia_plano d,
		pls_segurado	f
	where	d.nr_seq_segurado = f.nr_sequencia
	and	f.nr_seq_titular  = x.nr_sequencia
	and	d.ie_status = '1'
	and	d.dt_autorizacao >= dt_autorizacao_inicio_p
	and 	d.dt_autorizacao <= (dt_autorizacao_final_p + 1)
	and	coalesce(d.ie_utilizado,'N') = 'N'
	and	exists (	select	1
				from	pls_guia_plano_proc z
				where	z.nr_seq_guia = d.nr_sequencia
				and	exists ( 	select	1
							from	pls_guia_coparticipacao w
							where	w.nr_seq_guia_proc = z.nr_sequencia)
				
union all

				select	1
				from	pls_guia_plano_mat z
				where	z.nr_seq_guia = d.nr_sequencia
				and	exists ( 	select	1
							from	pls_guia_coparticipacao w
							where	w.nr_seq_guia_mat = z.nr_sequencia)))) qt_guias
into STRICT	qt_guias_w
from	pls_segurado x
where 	x.nr_sequencia = nr_seq_segurado_p;

return	qt_guias_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_guias_relat_50_cop (nr_seq_segurado_p bigint, dt_autorizacao_inicio_p timestamp, dt_autorizacao_final_p timestamp) FROM PUBLIC;
