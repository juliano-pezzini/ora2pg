-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_valor_autorizacao ( nr_seq_guia_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_procedimentos_w	double precision;
vl_materiais_w		double precision;
vl_autorizacao_w	double precision;



BEGIN

select	coalesce(sum(vl_procedimento * qt_autorizada),0)
into STRICT	vl_procedimentos_w
from	pls_guia_plano_proc
where	nr_seq_guia	= nr_seq_guia_p;

select	coalesce(sum(vl_material * qt_autorizada),0)
into STRICT	vl_materiais_w
from	pls_guia_plano_mat
where	nr_seq_guia	= nr_seq_guia_p;

vl_autorizacao_w	:= vl_procedimentos_w + vl_materiais_w;

update	pls_guia_plano
set	vl_autorizacao	= vl_autorizacao_w
where	nr_sequencia	= nr_seq_guia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_valor_autorizacao ( nr_seq_guia_p bigint, nm_usuario_p text) FROM PUBLIC;
