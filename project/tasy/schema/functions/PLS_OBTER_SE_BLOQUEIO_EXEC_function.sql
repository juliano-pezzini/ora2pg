-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_bloqueio_exec ( nr_seq_requisicao_p bigint, nr_seq_prestador_p bigint, ie_tipo_guia_p text, ie_origem_execucao_p text, ds_parametro_1_p bigint, ds_parametro_2_p bigint, ds_parametro_3_p bigint, ds_parametro_4_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retonor_w			varchar(1) := 'S';
ie_prestador_executor_w		varchar(1) := 'N';
ie_bloqueio_tasy_w		varchar(1) := 'N';
ie_bloqueio_portal_w		varchar(1) := 'N';
ie_tipo_guia_w			varchar(2);

ie_estagio_w			bigint;
nr_seq_prestador_exec_w		bigint;
qt_reg_w			bigint;


BEGIN

select	ie_estagio,
	ie_tipo_guia,
	nr_seq_prestador_exec
into STRICT	ie_estagio_w,
	ie_tipo_guia_w,
	nr_seq_prestador_exec_w
from	pls_requisicao
where	nr_sequencia = nr_seq_requisicao_p;

if (ie_tipo_guia_w = '1') and (coalesce(nr_seq_prestador_exec_w, 0) > 0) and (nr_seq_prestador_exec_w <> nr_seq_prestador_p) then
	ie_prestador_executor_w := 'S';
end if;

if (ie_origem_execucao_p = 'T') then
	ie_bloqueio_tasy_w := 'S';
elsif (ie_origem_execucao_p = 'P') then
	ie_bloqueio_portal_w := 'S';
end if;

if (pls_obter_se_controle_estab('RE') = 'S') then
	select	count(1)
	into STRICT	qt_reg_w
	from	pls_bloqueio_execucao_req
	where	((ie_bloqueio_portal	= 'S' and ie_bloqueio_portal_w = 'S')
	or (ie_bloqueio_tasy	= 'S' and ie_bloqueio_tasy_w = 'S'))
	and (coalesce(ie_estagio::text, '') = '' or ie_estagio = ie_estagio_w)
	and (coalesce(ie_tipo_guia::text, '') = '' or ie_tipo_guia	= ie_tipo_guia_w)
	and	((coalesce(ie_executa_prestador_prev,'N') = 'N') or (ie_executa_prestador_prev = ie_prestador_executor_w and (ie_executa_prestador_prev IS NOT NULL AND ie_executa_prestador_prev::text <> '')))
	and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento);
else
	select	count(1)
	into STRICT	qt_reg_w
	from	pls_bloqueio_execucao_req
	where	((ie_bloqueio_portal	= 'S' and ie_bloqueio_portal_w = 'S')
	or (ie_bloqueio_tasy	= 'S' and ie_bloqueio_tasy_w = 'S'))
	and (coalesce(ie_estagio::text, '') = '' or ie_estagio = ie_estagio_w)
	and (coalesce(ie_tipo_guia::text, '') = '' or ie_tipo_guia	= ie_tipo_guia_w)
	and	((coalesce(ie_executa_prestador_prev,'N') = 'N') or (ie_executa_prestador_prev = ie_prestador_executor_w and (ie_executa_prestador_prev IS NOT NULL AND ie_executa_prestador_prev::text <> '')));
end if;

if (qt_reg_w > 0) then
	ds_retonor_w := 'N';
end if;

return	ds_retonor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_bloqueio_exec ( nr_seq_requisicao_p bigint, nr_seq_prestador_p bigint, ie_tipo_guia_p text, ie_origem_execucao_p text, ds_parametro_1_p bigint, ds_parametro_2_p bigint, ds_parametro_3_p bigint, ds_parametro_4_p bigint) FROM PUBLIC;

