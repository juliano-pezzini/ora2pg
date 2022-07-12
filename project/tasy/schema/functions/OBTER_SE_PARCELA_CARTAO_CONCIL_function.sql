-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_parcela_cartao_concil (nr_seq_extrato_movto_p bigint, nr_seq_parcela_p bigint) RETURNS varchar AS $body$
DECLARE


ie_conciliada_w		varchar(1)	:= 'N';
cont_w			integer	:= 0;


BEGIN

if (nr_seq_extrato_movto_p IS NOT NULL AND nr_seq_extrato_movto_p::text <> '') then
	select	count(*)
	into STRICT	cont_w
	from	extrato_cartao_cr_movto
	where	nr_sequencia	= nr_seq_extrato_movto_p
	and ((nr_seq_extrato_parcela IS NOT NULL AND nr_seq_extrato_parcela::text <> '') or ie_pagto_indevido = 'S' or (nr_seq_extrato_parc_cred IS NOT NULL AND nr_seq_extrato_parc_cred::text <> ''));

elsif (nr_seq_parcela_p IS NOT NULL AND nr_seq_parcela_p::text <> '') then
	select	count(*)
	into STRICT	cont_w
	from	movto_cartao_cr_parcela
	where	nr_sequencia	= nr_seq_parcela_p
	and	(nr_seq_extrato_parcela IS NOT NULL AND nr_seq_extrato_parcela::text <> '');
end if;

if (cont_w > 0) then
	ie_conciliada_w	:= 'S';
end if;

return	ie_conciliada_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_parcela_cartao_concil (nr_seq_extrato_movto_p bigint, nr_seq_parcela_p bigint) FROM PUBLIC;

