-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_titular_contrato_pf ( nr_seq_proposta_p bigint, nr_contrato_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_titular_p INOUT bigint) AS $body$
DECLARE


ie_titular_pf_w			varchar(10);
qt_registros_w			bigint;
nr_seq_titular_w		bigint;
qt_proposta_pf_w		bigint;


BEGIN

ie_titular_pf_w	:= coalesce(obter_valor_param_usuario(1232, 41, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p), 'N');

select	count(*)
into STRICT	qt_proposta_pf_w
from	pls_proposta_adesao
where	nr_sequencia	= nr_seq_proposta_p
and	coalesce(cd_cgc_estipulante::text, '') = '';

select	count(*)
into STRICT	qt_registros_w
from	pls_segurado         a,
	pls_contrato         b
where	b.nr_sequencia	= a.nr_seq_contrato
and	coalesce(a.nr_seq_titular::text, '') = ''
and	coalesce(a.dt_rescisao::text, '') = ''
and	b.nr_contrato	= nr_contrato_p;

if (qt_registros_w = 1) and (qt_proposta_pf_w > 0) and (ie_titular_pf_w = 'S') then
	select	a.nr_sequencia
	into STRICT	nr_seq_titular_w
	from	pls_segurado         a,
		pls_contrato         b
	where	b.nr_sequencia	= a.nr_seq_contrato
	and	coalesce(a.nr_seq_titular::text, '') = ''
	and	coalesce(a.dt_rescisao::text, '') = ''
	and	b.nr_contrato	= nr_contrato_p;
end if;

nr_seq_titular_p	:= nr_seq_titular_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_titular_contrato_pf ( nr_seq_proposta_p bigint, nr_contrato_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_titular_p INOUT bigint) FROM PUBLIC;

