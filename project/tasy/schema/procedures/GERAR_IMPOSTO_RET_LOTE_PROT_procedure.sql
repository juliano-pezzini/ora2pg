-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_imposto_ret_lote_prot (nr_seq_receb_p bigint, nr_seq_lote_prot_p bigint, nm_usuario_p text, nr_seq_trans_financ_p bigint, cd_tributo_p bigint, vl_total_trib_p bigint) AS $body$
DECLARE

 
nr_seq_protocolo_w	bigint;
nr_seq_retorno_w	bigint;
nr_titulo_w		bigint;
nr_seq_receb_adic_w	bigint;
vl_total_pago_w		double precision;
vl_adicional_w		double precision;
vl_total_vinculado_w	double precision;

c01 CURSOR FOR 
SELECT	a.nr_seq_protocolo 
from	protocolo_convenio a 
where	a.nr_seq_lote_protocolo	= nr_seq_lote_prot_p;

c02 CURSOR FOR 
SELECT	a.nr_seq_retorno, 
	sum(a.vl_vinculacao) 
from	convenio_ret_receb a 
where	a.nr_seq_receb	= nr_seq_receb_p 
group by a.nr_seq_retorno 
having 	sum(a.vl_vinculacao) > 0;

c03 CURSOR FOR 
SELECT (coalesce(sum(a.vl_pago),0) + coalesce(sum(a.vl_adicional),0)) vl_total_pago, 
	a.nr_titulo 
from	convenio_retorno_item a, 
	conta_paciente b 
where	a.nr_interno_conta	= b.nr_interno_conta 
and	b.nr_seq_protocolo	= nr_seq_protocolo_w 
and	a.nr_seq_retorno	= nr_seq_retorno_w 
group by a.nr_titulo 
having(coalesce(sum(a.vl_pago),0) + coalesce(sum(a.vl_adicional),0)) > 0;


BEGIN 
 
if (coalesce(vl_total_trib_p,0) > 0) and (cd_tributo_p IS NOT NULL AND cd_tributo_p::text <> '') then 
 
	/*Buscar os protocolos do lote de protocolo*/
 
	open C01;
	loop 
	fetch C01 into 
		nr_seq_protocolo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		 
		/*Buscar os retornos e valor total vinculado de cada retorno*/
 
		open C02;
		loop 
		fetch C02 into 
			nr_seq_retorno_w, 
			vl_total_vinculado_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			 
			/*Buscar os títulos e valor pago de cada título do retorno do lote de protocolo*/
 
			open C03;
			loop 
			fetch C03 into 
				vl_total_pago_w, 
				nr_titulo_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin 
 
				vl_adicional_w	:= (vl_total_pago_w / vl_total_vinculado_w) * vl_total_trib_p;
				 
				select	nextval('convenio_receb_adic_seq') 
				into STRICT	nr_seq_receb_adic_w 
				;
 
				insert into CONVENIO_RECEB_ADIC(nr_sequencia, 
					nr_seq_receb, 
					dt_atualizacao, 
					nm_usuario, 
					nr_seq_trans_financ, 
					vl_adicional, 
					nr_lote_contabil, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					nr_titulo, 
					vl_cambial_ativo, 
					vl_cambial_passivo, 
					cd_tributo) 
				values (nr_seq_receb_adic_w, 
					nr_seq_receb_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					nr_seq_trans_financ_p, 
					vl_adicional_w, 
					0, 
					clock_timestamp(), 
					nm_usuario_p, 
					nr_titulo_w, 
					null, 
					null, 
					cd_tributo_p);
 
				end;
			end loop;
			close C03;
 
		end loop;
		close C02;
 
	end loop;
	close C01;
	 
	if (nr_seq_receb_adic_w IS NOT NULL AND nr_seq_receb_adic_w::text <> '') then 
		/*Ajustar arredondamento no último imposto gerado*/
 
		select	sum(vl_adicional) 
		into STRICT	vl_adicional_w 
		from	convenio_receb_adic 
		where	nr_seq_receb	= nr_seq_receb_p 
		and	(cd_tributo IS NOT NULL AND cd_tributo::text <> '');
		 
		if (vl_adicional_w < vl_total_trib_p) then 
		 
			update	convenio_receb_adic 
			set	vl_adicional 	= vl_adicional + (vl_total_trib_p-vl_adicional_w) 
			where	nr_sequencia	= nr_seq_receb_adic_w;
			 
		end if;	
	end if;
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_imposto_ret_lote_prot (nr_seq_receb_p bigint, nr_seq_lote_prot_p bigint, nm_usuario_p text, nr_seq_trans_financ_p bigint, cd_tributo_p bigint, vl_total_trib_p bigint) FROM PUBLIC;
