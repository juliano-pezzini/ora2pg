-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION com_obter_bsc_acerto_analista ( dt_referencia_p timestamp, pr_padrao_prev_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


qt_prev_faixa_w		bigint;
qt_prev_total_w		bigint;
qt_retorno_w		double precision;


BEGIN
/*
des_gerar_estim_analista(	dt_referencia_p,
				pr_padrao_prev_p,
				nm_usuario_p);*/
qt_Retorno_w	:= 0;

select	coalesce(sum(a.qt_os_total),0),
	coalesce(sum(a.qt_os_faixa),0)
into STRICT	qt_prev_total_w,
	qt_prev_faixa_w
from	des_ind_estim_analista a
where	dt_referencia	= dt_referencia_p
and	nm_usuario	= nm_usuario_p;

qt_retorno_w	:= (dividir(qt_prev_faixa_w, qt_prev_total_w) * 100);
return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION com_obter_bsc_acerto_analista ( dt_referencia_p timestamp, pr_padrao_prev_p bigint, nm_usuario_p text) FROM PUBLIC;

