-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lote_audit_hist_lib (nr_seq_lote_audit_hist_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_regra_lib_w	bigint;
ie_tipo_valor_w		varchar(15);
vl_minimo_w		double precision;
vl_maximo_w		double precision;
nm_usuario_lib_w	varchar(15);
ie_gerar_w		varchar(5);
vl_reapresentacao_w	double precision;
vl_glosa_aceita_w	double precision;
dt_aprovacao_w		timestamp;
C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.ie_tipo_valor,
		coalesce(a.vl_minimo,0),
		coalesce(a.vl_maximo,999999999999),
		b.nm_usuario_lib,
		'N'
	from	regra_lib_grg a,
		regra_lib_grg_usuario b
	where	a.nr_sequencia = b.nr_seq_regra
	and	coalesce(a.ie_situacao,'A') = 'A'
	and	clock_timestamp() between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp())
	and	not exists (	SELECT 1 from lote_audit_hist_lib x
				where	x.nr_seq_lote_audit_hist = nr_seq_lote_audit_hist_p
				and	x.nm_usuario_lib = b.nm_usuario_lib)
	order by a.nr_sequencia,
		 b.nr_sequencia;


BEGIN

CALL atualizar_valor_lote_recurso(nr_seq_lote_audit_hist_p,'F',nm_usuario_p);

select	max(vl_recurso),
	max(vl_glosa),
	max(dt_aprovacao)
into STRICT	vl_reapresentacao_w,
	vl_glosa_aceita_w,
	dt_aprovacao_w
from	lote_audit_hist
where	nr_sequencia = nr_seq_lote_audit_hist_p;

if (coalesce(dt_aprovacao_w::text, '') = '') then

	open C01;
	loop
	fetch C01 into
		nr_seq_regra_lib_w,
		ie_tipo_valor_w,
		vl_minimo_w,
		vl_maximo_w,
		nm_usuario_lib_w,
		ie_gerar_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (ie_tipo_valor_w = 'R') and (coalesce(vl_reapresentacao_w,0) >= vl_minimo_w) and (coalesce(vl_reapresentacao_w,0) <= vl_maximo_w) and (coalesce(vl_reapresentacao_w,0) > 0) then

			ie_gerar_w := 'S';

		elsif (ie_tipo_valor_w = 'A') and (coalesce(vl_glosa_aceita_w,0) >= vl_minimo_w) and (coalesce(vl_glosa_aceita_w,0) <= vl_maximo_w) and (coalesce(vl_glosa_aceita_w,0) > 0)then

			ie_gerar_w := 'S';
		end if;

		if (coalesce(ie_gerar_w,'N') = 'S') then

			insert	into	lote_audit_hist_lib(
				dt_atualizacao,
				dt_atualizacao_nrec,
				nm_usuario,
				nm_usuario_lib,
				nm_usuario_nrec,
				nr_seq_lote_audit_hist,
				nr_seq_regra_lib,
				nr_sequencia)
			values (
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				nm_usuario_lib_w,
				nm_usuario_p,
				nr_seq_lote_audit_hist_p,
				nr_seq_regra_lib_w,
				nextval('lote_audit_hist_lib_seq'));

		end if;

		end;
	end loop;
	close C01;

	update	lote_audit_hist
	set	dt_aprovacao 	= clock_timestamp(),
		nm_usuario  	= nm_usuario_p,
		dt_atualizacao 	= clock_timestamp()
	where	nr_sequencia 	= nr_seq_lote_audit_hist_p
	and	coalesce(dt_aprovacao::text, '') = '';

elsif (dt_aprovacao_w IS NOT NULL AND dt_aprovacao_w::text <> '') then

	delete
	from	lote_audit_hist_lib
	where	nr_seq_lote_audit_hist = nr_seq_lote_audit_hist_p;

	update	lote_audit_hist
	set	dt_aprovacao 	 = NULL,
		nm_usuario  	= nm_usuario_p,
		dt_atualizacao 	= clock_timestamp()
	where	nr_sequencia 	= nr_seq_lote_audit_hist_p
	and	(dt_aprovacao IS NOT NULL AND dt_aprovacao::text <> '');

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lote_audit_hist_lib (nr_seq_lote_audit_hist_p bigint, nm_usuario_p text) FROM PUBLIC;
