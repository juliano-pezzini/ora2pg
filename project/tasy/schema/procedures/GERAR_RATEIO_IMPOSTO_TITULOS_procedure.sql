-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_rateio_imposto_titulos (nr_seq_receb_p bigint, nm_usuario_p text, nr_seq_trans_financ_p bigint, vl_total_trib_p bigint, cd_tributo_p bigint) AS $body$
DECLARE


nr_titulo_w		bigint;
nr_seq_receb_adic_w	bigint;
vl_total_pago_w		double precision;
vl_adicional_w		double precision;
vl_recebido_w		double precision;

c01 CURSOR FOR
SELECT	a.nr_titulo,
	a.vl_recebido
from	convenio_receb_titulo a
where	a.nr_seq_receb	= nr_seq_receb_p;


BEGIN
if (coalesce(vl_total_trib_p,0) > 0) and (cd_tributo_p IS NOT NULL AND cd_tributo_p::text <> '') and (nr_seq_trans_financ_p IS NOT NULL AND nr_seq_trans_financ_p::text <> '') then

	select	sum(vl_recebido)
	into STRICT	vl_total_pago_w
	from	convenio_receb_titulo a
	where	a.nr_seq_receb	= nr_seq_receb_p;

	open C01;
	loop
	fetch C01 into
		nr_titulo_w,
		vl_recebido_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		vl_adicional_w	:= (vl_recebido_w / vl_total_pago_w) * vl_total_trib_p;

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
-- REVOKE ALL ON PROCEDURE gerar_rateio_imposto_titulos (nr_seq_receb_p bigint, nm_usuario_p text, nr_seq_trans_financ_p bigint, vl_total_trib_p bigint, cd_tributo_p bigint) FROM PUBLIC;
