-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_consistir_diops_pck.pls_diops_consist_contrap_pecu (nr_seq_periodo_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE


	ie_tipo_vencimento_w		w_diops_fin_idadesaldo_ati.ie_tipo_vencimento%type;
	vl_idadesaldo_vencer_W          diops_contrap_pecuniarias.vl_vencer%type	:= 0;
	vl_idadesaldo_vencido_w         diops_contrap_pecuniarias.vl_vencido%type	:= 0;
	vl_temp_w                       diops_contrap_pecuniarias.vl_emitido%type;
	vl_pecuniaria_vencer_W          diops_contrap_pecuniarias.vl_vencer%type;
	vl_pecuniaria_vencido_w         diops_contrap_pecuniarias.vl_vencido%type;


	c_idadesaldo CURSOR FOR
		SELECT (a.vl_coletivo_pos + a.vl_coletivo_pre + a.vl_individual + a.vl_individual_pos) vl_total,
			a.ie_tipo_vencimento ie_tipo_vencimento
		from    diops_fin_idadesaldo_ati a
		where   a.nr_seq_periodo = nr_seq_periodo_p;

	
BEGIN

	delete	
	from 	diops_periodo_inconsist a
	where	a.nr_seq_periodo	= nr_seq_periodo_p
	and	a.nr_seq_inconsistencia = 104;

	commit;

	open    c_idadesaldo;
	loop
	fetch   c_idadesaldo into
		vl_temp_w,
		ie_tipo_vencimento_w;
	EXIT WHEN NOT FOUND; /* apply on c_idadesaldo */
		begin
		if (ie_tipo_vencimento_w in (30, 60, 90, 999)) then
			vl_idadesaldo_vencido_w := (vl_idadesaldo_vencido_w + vl_temp_w);
		elsif (ie_tipo_vencimento_w = 00) then
			vl_idadesaldo_vencer_w := (vl_idadesaldo_vencer_w + vl_temp_w);
		end if;
		end;
	end loop;

	select  coalesce(sum(vl_vencer),  0),
		coalesce(sum(vl_vencido), 0)
	into STRICT	vl_pecuniaria_vencer_w,
		vl_pecuniaria_vencido_w
	from    diops_contrap_pecuniarias a
	where   a.nr_seq_periodo = nr_seq_periodo_p;

	if (vl_pecuniaria_vencer_w <> vl_idadesaldo_vencer_w) then
		/* Values to expire do not match */

		select 	obter_desc_expressao(330037)
		into STRICT	current_setting('pls_consistir_diops_pck.ds_campo_macro_w')::varchar(255)
		;
		CALL pls_consistir_diops_pck.pls_gravar_consistencia(nr_seq_periodo_p, cd_estabelecimento_p, 104);
	end if;
	
	if (vl_pecuniaria_vencido_w <> vl_idadesaldo_vencido_w) then
		/* Due values do not match */

		select 	obter_desc_expressao(309833)
		into STRICT	current_setting('pls_consistir_diops_pck.ds_campo_macro_w')::varchar(255)
		;
		CALL pls_consistir_diops_pck.pls_gravar_consistencia(nr_seq_periodo_p, cd_estabelecimento_p, 104);
	end if;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_diops_pck.pls_diops_consist_contrap_pecu (nr_seq_periodo_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;