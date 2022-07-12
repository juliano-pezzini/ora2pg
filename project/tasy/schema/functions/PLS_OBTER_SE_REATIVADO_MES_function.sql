-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_reativado_mes (nr_seq_segurado_p text, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1)	:= 'N';
dt_hist_rescisao_w	timestamp;
dt_hist_reativacao_w	timestamp;


BEGIN

select	max(dt_historico)
into STRICT	dt_hist_rescisao_w
from	pls_segurado_historico
where	nr_seq_segurado = nr_seq_segurado_p
and	ie_tipo_historico = '1';

select	max(dt_historico)
into STRICT	dt_hist_reativacao_w
from	pls_segurado_historico
where	nr_seq_segurado = nr_seq_segurado_p
and	ie_tipo_historico = '2';

if (trunc(dt_hist_reativacao_w,'month') = trunc(dt_hist_rescisao_w,'month')) then
	ie_retorno_w := 'S';
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_reativado_mes (nr_seq_segurado_p text, dt_referencia_p timestamp) FROM PUBLIC;

