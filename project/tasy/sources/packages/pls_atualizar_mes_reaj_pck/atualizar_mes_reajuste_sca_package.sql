-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_atualizar_mes_reaj_pck.atualizar_mes_reajuste_sca ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_sca_vinculo_p pls_sca_vinculo.nr_sequencia%type, nr_mes_reajuste_p pls_segurado.nr_mes_reajuste%type, ie_vetor_p text, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_mes_reajuste_sca_w	pls_sca_vinculo.nr_mes_reajuste%type;

c01 CURSOR(	nr_seq_segurado_pc	pls_segurado.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_sca_vinculo,
		coalesce(a.dt_reajuste, b.dt_reajuste) dt_reajuste_sca,
		a.nr_mes_reajuste
	from	pls_sca_vinculo a,
		pls_plano b
	where	b.nr_sequencia = a.nr_seq_plano
	and	a.nr_seq_segurado = nr_seq_segurado_pc
	and	b.ie_permite_reajuste = 'S'
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	coalesce(nr_seq_sca_vinculo_p::text, '') = ''
	
union all

	SELECT	a.nr_sequencia nr_seq_sca_vinculo,
		coalesce(a.dt_reajuste, b.dt_reajuste) dt_reajuste_sca,
		a.nr_mes_reajuste
	from	pls_sca_vinculo a,
		pls_plano b
	where	b.nr_sequencia = a.nr_seq_plano
	and	a.nr_sequencia = nr_seq_sca_vinculo_p
	and	b.ie_permite_reajuste = 'S'
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	(nr_seq_sca_vinculo_p IS NOT NULL AND nr_seq_sca_vinculo_p::text <> '');

BEGIN

for r_c01_w in c01(nr_seq_segurado_p) loop
	begin
	if (r_c01_w.dt_reajuste_sca IS NOT NULL AND r_c01_w.dt_reajuste_sca::text <> '') then
		nr_mes_reajuste_sca_w	:= (to_char(r_c01_w.dt_reajuste_sca, 'mm'))::numeric;
	else
		nr_mes_reajuste_sca_w	:= nr_mes_reajuste_p;
	end if;

	if	((coalesce(r_c01_w.nr_mes_reajuste, 0) <> nr_mes_reajuste_sca_w) and (nr_mes_reajuste_sca_w IS NOT NULL AND nr_mes_reajuste_sca_w::text <> '')) then
		CALL pls_atualizar_mes_reaj_pck.att_mes_reajuste_benef_sca(r_c01_w.nr_seq_sca_vinculo, nr_mes_reajuste_sca_w, ie_vetor_p, nm_usuario_p);
	end if;
	end;
end loop; --C01
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_mes_reaj_pck.atualizar_mes_reajuste_sca ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_sca_vinculo_p pls_sca_vinculo.nr_sequencia%type, nr_mes_reajuste_p pls_segurado.nr_mes_reajuste%type, ie_vetor_p text, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;