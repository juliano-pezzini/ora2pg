-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_qtd_ocorr_req ( nr_seq_requisicao_p bigint, qt_tipo_quantidade_p bigint, ie_tipo_qtde_p text, qt_liberada_p bigint) RETURNS varchar AS $body$
DECLARE


/*
 IE_TIPO_QTDE_P - Dominio 3540
	D - Dia
	M - Mes
	A - Ano	
	G - Guia
*/
ie_retorno_w			varchar(1)	:= 'S';
nr_seq_segurado_w		bigint;
nr_seq_prestador_w		bigint;
qt_liberacao_w			double precision;
dt_liberacao_w			timestamp;
dt_liberacao_ww			timestamp;				
				

BEGIN

select	dt_requisicao,
	nr_seq_segurado,
	nr_seq_prestador
into STRICT	dt_liberacao_w,
	nr_seq_segurado_w,
	nr_seq_prestador_w
from	pls_requisicao
where	nr_sequencia	= nr_seq_requisicao_p;

if (ie_tipo_qtde_p	= 'D') then   	
	dt_liberacao_ww	:= trunc(dt_liberacao_w - (qt_tipo_quantidade_p - 1));		
elsif (ie_tipo_qtde_p	= 'M') then
	dt_liberacao_ww	:= (add_months(dt_liberacao_w, -qt_tipo_quantidade_p) + 1);
elsif (ie_tipo_qtde_p	= 'A') then
	dt_liberacao_ww	:= (add_months(dt_liberacao_w, -qt_tipo_quantidade_p * 12) + 1); /* Vezes 12 meses ao ano */
elsif (ie_tipo_qtde_p = 'G') then
	dt_liberacao_ww := clock_timestamp();
end if;

select 	count(*)
into STRICT	qt_liberacao_w
from	pls_requisicao		
where	ie_estagio		= 2
and	nr_seq_segurado		= nr_seq_segurado_w
and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_requisicao) 	between dt_liberacao_ww and ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_liberacao_w);

if (qt_liberacao_w	>= qt_liberada_p - 1) then
	ie_retorno_w	:= 'N';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_qtd_ocorr_req ( nr_seq_requisicao_p bigint, qt_tipo_quantidade_p bigint, ie_tipo_qtde_p text, qt_liberada_p bigint) FROM PUBLIC;
