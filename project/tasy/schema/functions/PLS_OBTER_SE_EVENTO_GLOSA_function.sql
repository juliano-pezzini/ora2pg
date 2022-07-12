-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_evento_glosa ( nr_seq_motivo_glosa_p tiss_motivo_glosa.nr_sequencia%type, ie_evento_p pls_glosa_evento.ie_evento%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'N';
qt_evento_w		integer;
ie_ocorrencia_w		pls_controle_estab.ie_ocorrencia%type := 'N';
ie_evento_w		pls_glosa_evento.ie_evento%type := coalesce(ie_evento_p, 'SCE');


BEGIN
ie_ocorrencia_w := pls_obter_se_controle_estab('GO');

if (ie_ocorrencia_w = 'S') then
	select	count(1)
	into STRICT	qt_evento_w
	from	pls_glosa_evento
	where	nr_seq_motivo_glosa = nr_seq_motivo_glosa_p
	and	ie_plano = 'S'
	and	cd_estabelecimento = cd_estabelecimento_p
	and	((ie_evento = ie_evento_w) or (ie_evento_w = 'SCE'));

	if (qt_evento_w > 0) then
		ds_retorno_w := 'S';
	end if;
else
	select	count(1)
	into STRICT	qt_evento_w
	from	pls_glosa_evento
	where	nr_seq_motivo_glosa = nr_seq_motivo_glosa_p
	and	ie_plano = 'S'
	and	((ie_evento = ie_evento_w) or (ie_evento_w = 'SCE'));

	if (qt_evento_w > 0) then
		ds_retorno_w := 'S';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_evento_glosa ( nr_seq_motivo_glosa_p tiss_motivo_glosa.nr_sequencia%type, ie_evento_p pls_glosa_evento.ie_evento%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

