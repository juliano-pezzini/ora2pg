-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_mens_cobranca_guia ( nr_seq_mensalidade_seg_p bigint, nr_seq_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_protocolo_w		pls_protocolo_conta.nr_sequencia%type;
vl_conta_w			double precision;
qt_conta_mens_w			integer;
qt_registros_w			integer;
ie_gerou_apropriacao_item_w	boolean;
nr_seq_item_mensalidade_w	pls_mensalidade_seg_item.nr_sequencia%type;

C01 CURSOR(	nr_seq_conta_pc	pls_conta.nr_sequencia%type) FOR
	SELECT	nr_seq_centro_aprop		nr_seq_centro_aprop,
		sum(vl_beneficiario)		vl_beneficiario
	from (SELECT	a.nr_seq_centro_aprop	nr_seq_centro_aprop,
			a.vl_beneficiario	vl_beneficiario
		from	pls_conta_proc_aprop	a,
			pls_conta_proc		b
		where	a.nr_seq_conta_proc	= b.nr_sequencia
		and	b.nr_seq_conta		= nr_seq_conta_pc
		and	(a.vl_beneficiario IS NOT NULL AND a.vl_beneficiario::text <> '')
		
union all

		select	a.nr_seq_centro_aprop	nr_seq_centro_aprop,
			a.vl_beneficiario	vl_beneficiario
		from	pls_conta_mat_aprop	a,
			pls_conta_mat		b
		where	a.nr_seq_conta_mat	= b.nr_sequencia
		and	b.nr_seq_conta		= nr_seq_conta_pc
		and	(a.vl_beneficiario IS NOT NULL AND a.vl_beneficiario::text <> '')) alias4
	group by nr_seq_centro_aprop;

BEGIN

select	count(1)
into STRICT	qt_registros_w

where	exists (SELECT	1
		from	pls_conta_proc k
		where	k.nr_seq_conta		= nr_seq_conta_p
		and	k.ie_cobranca_prevista	= 'S');

if (qt_registros_w	> 0) then
	select	count(1)
	into STRICT	qt_conta_mens_w
	
	where	exists (SELECT	1
			from	pls_mensalidade_seg_item z,
				pls_mensalidade_segurado y,
				pls_mensalidade x
			where	y.nr_sequencia	= z.nr_seq_mensalidade_seg
			and	x.nr_sequencia	= y.nr_seq_mensalidade
			and	z.nr_seq_conta	= nr_seq_conta_p
			and	coalesce(x.ie_cancelamento::text, '') = ''
			and	z.vl_item <> 0
			and	z.ie_tipo_item <> '3');

	if (qt_conta_mens_w = 0) then
		select	coalesce(vl_total_beneficiario,coalesce(vl_total,0)) vl_conta,
			nr_seq_protocolo
		into STRICT	vl_conta_w,
			nr_seq_protocolo_w
		from	pls_conta
		where	nr_sequencia	= nr_seq_conta_p;

		if (vl_conta_w <> 0) then

			nr_seq_item_mensalidade_w := null;

			nr_seq_item_mensalidade_w := pls_insert_mens_seg_item('13', nm_usuario_p, null, null, null, null, null, null, null, 'N', null, null, null, null, nr_seq_conta_p, null, null, nr_seq_mensalidade_seg_p, null, null, null, nr_seq_protocolo_w, null, null, null, null, null, null, null, null, null, vl_conta_w, nr_seq_item_mensalidade_w);

			if (nr_seq_item_mensalidade_w IS NOT NULL AND nr_seq_item_mensalidade_w::text <> '') then
				ie_gerou_apropriacao_item_w	:= false;

				for r_c01_w in C01(nr_seq_conta_p) loop
					insert into pls_mens_seg_item_aprop(nr_sequencia, dt_atualizacao, dt_atualizacao_nrec, nm_usuario, nm_usuario_nrec,
						nr_seq_item, nr_seq_centro_apropriacao, vl_apropriacao)
					values (nextval('pls_mens_seg_item_aprop_seq'), clock_timestamp(), clock_timestamp(), nm_usuario_p, nm_usuario_p,
						nr_seq_item_mensalidade_w, r_c01_w.nr_seq_centro_aprop, r_c01_w.vl_beneficiario);

					ie_gerou_apropriacao_item_w	:= true;
				end loop;

				if (ie_gerou_apropriacao_item_w) then
					update	pls_mensalidade_seg_item
					set	ie_valor_apropriado	= 'S'
					where	nr_sequencia = nr_seq_item_mensalidade_w;
				end if;
			end if;
		end if;
	end if;
end if;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_mens_cobranca_guia ( nr_seq_mensalidade_seg_p bigint, nr_seq_conta_p bigint, nm_usuario_p text) FROM PUBLIC;
