-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_int_xml_cta_pck.verifica_regra_lib_analise ( nr_seq_prestador_p pls_prestador.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE


nr_seq_tipo_prestador_w		pls_tipo_prestador.nr_sequencia%type;
qt_prestador_regra_w 		bigint;


BEGIN
qt_prestador_regra_w := null;

select	max(b.nr_sequencia)
into STRICT	nr_seq_tipo_prestador_w
from	pls_tipo_prestador b,
	pls_prestador a
where	a.nr_seq_tipo_prestador	= b.nr_sequencia
and	a.nr_sequencia		= nr_seq_prestador_p;

select	count(1)
into STRICT	qt_prestador_regra_w
from	pls_regra_analise_imp_cta b
where	b.nr_seq_param_imp_conta	= current_setting('pls_int_xml_cta_pck.nr_seq_param_analise_w')::pls_param_importacao_conta.nr_sequencia%type
and	((b.nr_seq_prestador 		= nr_seq_prestador_p) or (b.nr_seq_tipo_prestador = nr_seq_tipo_prestador_w))
and	trunc(clock_timestamp()) between trunc(b.dt_inicio_vigencia) and fim_dia(coalesce(b.dt_fim_vigencia,clock_timestamp()));

return	qt_prestador_regra_w;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_int_xml_cta_pck.verifica_regra_lib_analise ( nr_seq_prestador_p pls_prestador.nr_sequencia%type) FROM PUBLIC;