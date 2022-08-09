-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_valores_discussao (nr_seq_discussao_p bigint) AS $body$
DECLARE


vl_negado_w		double precision := 0;
vl_recurso_w		double precision := 0;
vl_aceito_w		double precision := 0;


BEGIN
if (nr_seq_discussao_p IS NOT NULL AND nr_seq_discussao_p::text <> '') then
	select	sum(vl_negado),
		sum(vl_recurso),
		sum(vl_aceito)
	into STRICT	vl_negado_w,
		vl_recurso_w,
		vl_aceito_w
	from (SELECT	sum(vl_negado) vl_negado,
			sum(vl_recurso) vl_recurso,
			sum(vl_aceito) vl_aceito
		from	pls_discussao_proc
		where	nr_seq_discussao	= nr_seq_discussao_p
		
union all

		SELECT	sum(vl_negado) vl_negado,
			sum(vl_recurso) vl_recurso,
			sum(vl_aceito) vl_aceito
		from	pls_discussao_mat
		where	nr_seq_discussao	= nr_seq_discussao_p) alias10;

	update	pls_contestacao_discussao
	set	vl_recurso	= coalesce(vl_recurso_w,0),
		vl_negado	= coalesce(vl_negado_w,0),
		vl_aceito	= coalesce(vl_aceito_w,0)
	where	nr_sequencia	= nr_seq_discussao_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_valores_discussao (nr_seq_discussao_p bigint) FROM PUBLIC;
