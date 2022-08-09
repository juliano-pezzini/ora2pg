-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_atualizar_controle_proc ( nr_seq_protocolo_p bigint, ie_opcao_p bigint) AS $body$
DECLARE

 
/* IE_OPCAO_P 
	1 - Inserir 
	2 - Desfazer 
*/
 
 
nr_aih_w		bigint;
nr_seq_aih_w		bigint;
nr_processo_w		bigint	:= 0;
qt_reg_controle_w	integer	:= 0;
vl_sh_w			double precision	:= 0;
vl_sp_w			double precision	:= 0;
vl_sadt_w		double precision	:= 0;
vl_sangue_w		double precision	:= 0;
vl_opm_w		double precision	:= 0;
vl_rnato_w		double precision	:= 0;
vl_s_rateio_w		double precision	:= 0;
vl_analg_w		double precision	:= 0;
vl_pedcon_w		double precision	:= 0;
vl_pago_w		double precision	:= 0;

C01 CURSOR FOR 
	SELECT	b.nr_aih, 
		b.nr_seq_aih, 
		a.nr_processo 
	from	sus_aih_rejeitada	b, 
		sus_aih_processo	a 
	where	a.nr_seq_protocolo	= nr_seq_protocolo_p 
	and	a.nr_processo		= b.nr_processo 
	and	not exists (	SELECT	1 
				from	sus_aih_paga	x 
				where	x.nr_seq_protocolo	= b.nr_seq_protocolo 
				and	x.nr_aih		= b.nr_aih 
				and	x.nr_seq_aih		= b.nr_seq_aih);

C02 CURSOR FOR 
	SELECT	b.nr_aih, 
		b.nr_seq_aih, 
		a.nr_processo, 
		b.vl_sh, 
		b.vl_sp, 
		b.vl_sadt, 
		b.vl_sangue, 
		b.vl_opm, 
		b.vl_rnato, 
		b.vl_s_rateio, 
		b.vl_analg, 
		b.vl_pedcon 
	from	sus_aih_paga		b, 
		sus_aih_processo	a 
	where	a.nr_seq_protocolo	= nr_seq_protocolo_p 
	and	a.nr_processo		= b.nr_processo 
	and	b.nr_ident		= 1;


BEGIN 
 
if (ie_opcao_p	= 1) then 
	OPEN C01;
	LOOP 
	FETCH C01 into 
		nr_aih_w, 
		nr_seq_aih_w, 
		nr_processo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		select	count(*) 
		into STRICT	qt_reg_controle_w 
		from	sus_aih_controle_proc 
		where	nr_aih		= nr_aih_w 
		and	nr_seq_aih	= nr_seq_aih_w 
		and	coalesce(nr_processo::text, '') = '';
		if (qt_reg_controle_w	> 0) then 
			update	sus_aih_controle_proc 
			set	nr_processo	= nr_processo_w, 
				vl_rejeitado	= vl_original, 
				vl_pago		= 0 
			where	nr_aih		= nr_aih_w 
			and	nr_seq_aih	= nr_seq_aih_w;
			 
			update	protocolo_convenio 
			set	dt_controle_proc_sus	= clock_timestamp() 
			where	nr_seq_protocolo	= nr_seq_protocolo_p;
		end if;
		end;
	END LOOP;
	CLOSE C01;
	 
	OPEN C02;
	LOOP 
	FETCH C02 into 
		nr_aih_w, 
		nr_seq_aih_w, 
		nr_processo_w, 
		vl_sh_w, 
		vl_sp_w, 
		vl_sadt_w, 
		vl_sangue_w, 
		vl_opm_w, 
		vl_rnato_w, 
		vl_s_rateio_w, 
		vl_analg_w, 
		vl_pedcon_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin 
		select	count(*) 
		into STRICT	qt_reg_controle_w 
		from	sus_aih_controle_proc 
		where	nr_aih		= nr_aih_w 
		and	nr_seq_aih	= nr_seq_aih_w 
		and	coalesce(nr_processo::text, '') = '';
		if (qt_reg_controle_w	> 0) then 
			vl_pago_w	:=	vl_sh_w + vl_sp_w + vl_sadt_w + vl_sangue_w + vl_opm_w + 
						vl_rnato_w + vl_s_rateio_w + vl_analg_w + vl_pedcon_w;
			update	sus_aih_controle_proc 
			set	nr_processo	= nr_processo_w, 
				vl_pago		= vl_pago_w, 
				vl_rejeitado	= 0 
			where	nr_aih		= nr_aih_w 
			and	nr_seq_aih	= nr_seq_aih_w;
	 
			update	protocolo_convenio 
			set	dt_controle_proc_sus	= clock_timestamp() 
			where	nr_seq_protocolo	= nr_seq_protocolo_p;
		end if;	
		end;
	END LOOP;
	CLOSE C02;
elsif (ie_opcao_p	= 2) then 
	update	protocolo_convenio 
	set	dt_controle_proc_sus	 = NULL 
	where	nr_seq_protocolo	= nr_seq_protocolo_p;
 
	update	sus_aih_controle_proc 
	set	nr_processo		= '', 
		vl_pago			= '', 
		vl_rejeitado		= '' 
	where	nr_seq_protocolo	= nr_seq_protocolo_p;
end if;
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_atualizar_controle_proc ( nr_seq_protocolo_p bigint, ie_opcao_p bigint) FROM PUBLIC;
