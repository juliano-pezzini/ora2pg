-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_excluir_partic ( nr_seq_participante_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(2);
ie_insercao_manual_w		varchar(2);
nm_usuario_nrec_w		varchar(255);


BEGIN

begin
	select	coalesce(ie_insercao_manual,'N'),
		nm_usuario_nrec
	into STRICT	ie_insercao_manual_w,
		nm_usuario_nrec_w
	from	pls_proc_participante
	where	nr_sequencia	= nr_seq_participante_p;
exception
when others then
	ie_insercao_manual_w	:= 'N';
end;

if (ie_insercao_manual_w	= 'N') or (ie_insercao_manual_w	= 'S' AND nm_usuario_nrec_w	<> nm_usuario_p) then
	ie_retorno_w	:= 'N';
elsif (ie_insercao_manual_w	= 'S') and (nm_usuario_nrec_w	= nm_usuario_p) then
	ie_retorno_w	:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_excluir_partic ( nr_seq_participante_p bigint, nm_usuario_p text) FROM PUBLIC;
